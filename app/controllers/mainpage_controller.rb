class MainpageController < ApplicationController
  require 'net/http'
  require 'logger'
  require 'fileutils'
  require 'exifr/jpeg'
  
  @@current_cache = (File::join Rails.root, "cache/")




  def index

  end

  def transfrom

    #images = Rails.cache.read("current_images")

    Dir.foreach(@@current_cache) {|x|
      file_name = (File::join @@current_cache, x)
      if x == '.' or x == '..' or File.directory?(file_name)
        next
      end


      if File.exist?(file_name)
          temp = File.basename(file_name, ".*").split("_")
          id = temp[temp.length - 1]
          begin
            info= flickr.photos.getInfo :photo_id => id
          rescue
          end
         if info
            username = info.owner.username
            username.gsub!(/[\.\/\\\:\*\?\"\<\>\|]/,"")
            upath = (File::join @@current_cache,username, x)

            dirname = @@current_cache +  username
            unless File.directory?(dirname)
              FileUtils.mkdir_p(dirname)
            end
            FileUtils.mv(file_name, upath)
         end

      end
    }
    render :text => "done."

  end




  def recent
    @list   = flickr.photos.getRecent
    session[:list_index] = {:index => 1, :action => params[:action]}
    @index = session[:list_index][:index]
    getCurrentPhotos
    render "list"
  end

  def search_nature
    @list   = flickr.photos.search(:tags =>"nature")
    session[:list_index] = {:index => 1, :action => params[:action]}
    @index = session[:list_index][:index]
    getCurrentPhotos
    render "list"
  end

  def interesting
    @list   = flickr.interestingness.getList
    session[:list_index] = {:index => 1, :action => params[:action]}
    @index = session[:list_index][:index]
    getCurrentPhotos
    render "list"
  end

  def pervous_page
    if session[:list_index][:index] > 1
      session[:list_index][:index] -= 1
    end
    @index = session[:list_index][:index]
    call_position_action
    getCurrentPhotos
    render "list"
  end

  def next_page
    session[:list_index][:index] += 1
    @index = session[:list_index][:index]
    call_position_action
    getCurrentPhotos
    render "list"
  end

  def save_interesting
    @list   = flickr.interestingness.getList(:per_page => '500')
    savelist
    render :text => "saved"
  end

  def batch
  end

  def save_users
    temp = params[:list].to_s.split("\r\n")
    logger.info "lenght: #{temp.length}"
    temp.each_with_index{|v,index|
      begin

        logger.info "#{v}: #{index}"
        save_user_id_core v
      rescue
      end
    }
    render :text => "saved"
  end

  def save_user
    save_user_core params[:id]
    render :text => "saved"
  end

  def save_user_id_core id
    @list   = flickr.people.getPhotos(:user_id => id, :safe_search => 1,:content_type => '7',:per_page => 500,:page => params[:page])
    savelist
  end

  def save_user_core u
    id = flickr.people.findByUsername(:username => u)
    @list   = flickr.people.getPhotos(:user_id => id.id, :safe_search => 1,:content_type => '7',:per_page => 500,:page => params[:page])
    savelist
  end


  def getinfo
    id = params[:id]
    @sList = flickr.photos.getSizes :photo_id => id
    @info = flickr.photos.getInfo :photo_id => id
    @list = [@info]
    filename  = "temp.jpg"
    getCurrentPhotos
    fileUrl = URI.parse(@currentPhotos[0][:big])
     begin
       Net::HTTP.start(fileUrl.host) do |http|
         resp = http.get(fileUrl.request_uri)
         open((File::join Rails.root, "tmp/", filename), "wb") do |file|
           file.write(resp.body)
         end
       end
     rescue StandardError => error
     end
     @exifrObj = EXIFR::JPEG.new((File::join Rails.root, "tmp/", filename))
  end
  
  

  private

  def call_position_action
    eval(session[:list_index][:action] + "_position")
  end

  def interesting_position
    @list   = flickr.interestingness.getList(:page => session[:list_index][:index])
  end

  def recent_position
    @list   = flickr.photos.getRecent(:page => session[:list_index][:index])
  end

  def search_nature_position
    @list   = flickr.photos.search(:tags =>"nature", :page => session[:list_index][:index])
  end


  def savelist
    getCurrentPhotos
    @currentPhotos.each{|photo|
      if photo[:big]
        brokenfileurl = photo[:big].split(".")
        filename = photo[:title] + "_" + photo[:id] + "." + brokenfileurl[brokenfileurl.length - 1]
        filename.gsub!(/[\/\\\:\*\?\"\<\>\|]/,"")

        fileUrl = URI.parse(photo[:big])
        begin
          Net::HTTP.start(fileUrl.host) do |http|
            resp = http.get(fileUrl.request_uri)
            open((File::join Rails.root, "cache/", filename), "wb") do |file|
              file.write(resp.body)
            end
          end
        rescue StandardError => error
        end
      end
    }
  end


  def getCurrentPhotos
    @currentPhotos = []
    i = 0
    @list.each{|item|
      begin
        sList = flickr.photos.getSizes :photo_id => item.id

        if sList
          if sList.length > 0
            newIndex = @currentPhotos.length
            @currentPhotos << {}
            @currentPhotos[newIndex][:title] = item.title
            @currentPhotos[newIndex][:id] = item.id
            x = 0
            @currentPhotos[newIndex][:l_size] = 0
            sList.each{|s|
              if s.label.index("Large")
                n = s.label.sub("Large ","").to_i
                if @currentPhotos[newIndex][:l_size] < n
                  @currentPhotos[newIndex][:big] = s["source"]
                  @currentPhotos[newIndex][:l_size] =  n
                end
              end
              if s.label == "Large" and !@currentPhotos[newIndex][:big]
                @currentPhotos[newIndex][:big] = s["source"]
              end
              if s.label == "Original"
                @currentPhotos[newIndex][:big] = s["source"]
                @currentPhotos[newIndex][:l_size] =  2147483647
              end
              if s.label == "Thumbnail"
                @currentPhotos[newIndex][:thumbnail] = s["source"]
              end
            }
          end
        end
      rescue StandardError => error
      end
    }
  end

  def transfrom1

    images = Rails.cache.read("current_images")
    realname = params[:realname]
    username = params[:username]
    if realname
      dirname = @@current_cache + realname
    elsif username
      dirname = @@current_cache + username
    end
    unless File.directory?(dirname)
      FileUtils.mkdir_p(dirname)
    end

    images.each{|k,v|
      if v == '.' or v == '..'
        next
      end
      file_name = (File::join @@current_cache, k)
      if realname
        rpath = (File::join @@current_cache,realname, k)
        if v.owner.realname == realname
          FileUtils.mv(file_name, rpath)
        end
      elsif username
        upath = (File::join @@current_cache,username, k)
        if v.owner.username == username
          FileUtils.mv(file_name, upath)
        end
      end

    }
    render :text => "done."

  end
end
