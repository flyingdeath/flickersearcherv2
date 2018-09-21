def removeObstacle(numRows, numColumns, lot)
  d = []
  flat_spaces = []
  ret = []
  
    lot.each_with_index{|a,y|
        a.each_with_index{|b,x|
            if b == 1 
                flat_spaces[i] = [x,y]
            end 
        }
    }
    lot.each_with_index{|a,y|
        a.each_with_index{|b,x|   
            if b == 9 
                flat_spaces.each_with_index{|a,i|
                  d[i] = []
                  d[i][0] = Math.sqrt((a[0] - y)**2) +  ((a[1] - x)**2))
                  d[i][1] = [x,y] 
                 }
            end 
        }
    }
  d.sort!{|a,b|
      
      a[0] <=> b[0]
      
  }
  d.each_with_index{|a,i|
      ret[i] = a[1]
  }
  return d[0][0]
end