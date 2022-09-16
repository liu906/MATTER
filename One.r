
one <- function(root, file, excluded_code_size_percentage,cutoff,name_actualBugLabel,name_sloc){
  #D in aescending order of SLOC
  cat(file,'\n')
  data <- read.csv(paste(root,file,sep=''),)
  data$actualBugLabel <- data[,name_actualBugLabel]
  data$sloc <- data[,name_sloc]
  data = data[order(data$actualBugLabel),]
  data = data[order(-data$sloc),]
  data$predictLabel <- 0
  
  nrow_data = nrow(data)
  cumsum_sloc = cumsum(data$sloc)
  
  if(excluded_code_size_percentage>1){
    e = cumsum_sloc[length(cumsum_sloc)] / 100 * excluded_code_size_percentage
    if(cumsum_sloc[1]>e){
      idx = 0
      sub1 = matrix(nrow = 0,ncol = ncol(data))
    }else{
      
      idx = max(which(cumsum_sloc <= e))
      sub1 = data[1:idx,]
      sub1 = sub1[order(sub1$actualBugLabel),]
      sub1 = sub1[order(sub1$sloc),]
    }
  }else{
    idx = floor(nrow(data) * excluded_code_size_percentage)
    if(idx==0){
      sub1 = matrix(nrow = 0,ncol = ncol(data))
    }else{
      sub1 = data[1:idx,]  
      sub1$predictLabel = 0
      sub1 = sub1[order(sub1$actualBugLabel),]
      sub1 = sub1[order(sub1$sloc),]
    }
  }
  
  if(idx>=nrow(data)){
    data = sub1
  }else{
    data = data[(idx+1):nrow(data),]
    data = rbind(data,sub1)
  }
  
  
  if(cutoff>1){
    if(cutoff==100){
      e = cumsum_sloc[length(cumsum_sloc)]
    }else{
      e = cumsum_sloc[length(cumsum_sloc)] / 100 * cutoff
    }
    
    
    if(cumsum_sloc[1]>e){
      
    }else{
      cumsum_sloc = cumsum(data$sloc)
      idx = max(which(cumsum_sloc <= e))
    }
    
  }else{
    idx = floor(nrow_data * cutoff)
  }
  
  if(idx>nrow(data)){
    data[1:nrow(data),'predictLabel'] <- 1
  }else if(idx!=0){
    data[1:idx,'predictLabel'] <- 1
  }else{
    
  }
  data$predictedValue = nrow(data):1
  
  return(data)
}

