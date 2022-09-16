library(pROC)
start.time <- Sys.time()
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
getwd()

SC <- function(A){
  # cat("# Normalize software metrics .\n")
  
  gc()
  normA = apply(A, 2, function(x){(x - mean(x))/sd(x)})
  normA = normA[,colSums(is.na(normA))==0]
  gc()
  # cat("# Construct the weighted adjacency matrix W.\n")
  
  
  W = normA %*% t(normA)
  # cat("# Set all negative values to zero .\n")
  W[W <0] = 0
  # cat("# Set the self - similarity to zero .\n")
  W = W - diag(diag(W))
  gc()
  # cat("# Construct the symmetric Laplacian matrix Lsym.\n")
  Dnsqrt = diag(1/(sqrt(rowSums(W)+1e-10)))
  I = diag(rep(1, nrow(W)))
  gc()
  Lsym = I - Dnsqrt %*% W %*% Dnsqrt
  # cat("# Perform the eigendecomposition .\n")
  gc()
  ret_egn = eigen(Lsym, symmetric = TRUE)
  # cat("# Pick up the second smallest eigenvector .\n")
  gc()
  v1 = Dnsqrt %*% ret_egn $ vectors[, nrow(W)-1]
  v1 = v1 / sqrt(sum(v1^2))
  # cat("# Divide the data set into two clusters .\n")
  gc()
  
  predictedLabel = (v1 >0)
  # Label the defective and clean clusters .
  rs = rowSums(normA)
  if( mean(rs[v1>0]) < mean(rs[v1<0]))
    predictedLabel = (v1<0)
  
  result = cbind("predictedValue"=v1, "predictedLabel" = predictedLabel)
  
  # Return the defect proneness .
  return(result)
}

get_sloc <- function(data){
  if('loc' %in% colnames(data)){
    cn <- 'loc'
  }else if('LOC_EXECUTABLE' %in% colnames(data)){
    cn <- 'LOC_EXECUTABLE'
  }else if('numberOfLinesOfCode' %in% colnames(data)){
    cn <- 'numberOfLinesOfCode'
  }else if('CountLineCodeExe' %in% colnames(data)){
    cn <- 'CountLineCodeExe'
  }else if('LOC' %in% colnames(data)){
    cn <- 'LOC'
  }else if('sloc' %in% colnames(data)){
    cn <- 'sloc'
  }else if('SumnumChangedFiles' %in% colnames(data)){
    cn <- 'SumnumChangedFiles'
  }else if('current_LLOC' %in% colnames(data)){
    cn <- 'current_LLOC'
  }
  
  return(data[,cn])
}

get_indicators <- function(predictedValue,predictLabel,sloc,actualBugLabel,fileName){
  test <- cbind("predictedValue" = predictedValue, "predictLabel" = predictLabel, "sloc" = sloc, "actualBugLabel" = actualBugLabel)
  test <- data.frame(test)
  
  flag <- sum(test[test[,"predictLabel"]==TRUE,"predictedValue"])
  # if(flag < 0){
  #   test <- test[with(test, order(-predictLabel, predictedValue,sloc,actualBugLabel)), ]
  # }else{
  #   test <- test[with(test, order(-predictLabel, -predictedValue,sloc,actualBugLabel)), ]
  # }
  test <- test[with(test, order(-predictLabel, sloc, actualBugLabel)), ]
  write.csv(test,paste(res_root, strsplit(fileName,'/')[[1]][length(strsplit(fileName,'/')[[1]])],sep = ''),row.names = FALSE)
  # return(c(tp,fp,tn,fn,SNM_precision,SNM_recall,SNM_fscore,SNM_fpr,SNM_ifa,SNM_ap,SNM_rr,SNM_cr,SNM_roi,SNM_mcc,SNM_ifap,SNM_cr_ifa,SNM_pii_ifa,tp20,fp20,tn20,fn20,SSC_precision,SSC_recall,SSC_fscore,SSC_fpr,SSC_ifa,SSC_ap,SSC_rr,SSC_pii,SSC_roi,SSC_mcc,SSC_ifap,SSC_cr_ifa,SSC_pii_ifa,SSC_rcr))
 }

  
processOneData<-function(fileName){
  data <- read.csv(fileName)
  lastNo <- ncol(data)
  metricData <- data[,-lastNo]
  actualBugLabel <- data[,lastNo]

  # cat("before SC(metricData)...\n")
  temp <- SC(metricData)
  # cat("after SC(metricData)...\n")

  predictedValue <- temp[,1]
  predictLabel <- temp[,2]*1
  sloc <- get_sloc(data)
  indicators <- get_indicators(predictedValue,predictLabel,sloc,actualBugLabel,fileName = fileName)

}

for(i in 1:1){
  start.time <- Sys.time()
  cat(start.time,"\n")
  # setwd("D:\\OneDrive - Microsoft Student Partners\\OneDrive - Student Ambassadors\\UCS2\\UCS\\unsupervised\\SC")
  # res_root <- './MA-SZZ-2020-result/SC_'
  # dir.create('MA-SZZ-2020-result',showWarnings = FALSE)
  # fileNames <- list.files('./MA-SZZ-2020/',full.names = TRUE)
  # for(fileName in fileNames){
  #   cat(fileName,'\n')
  #   processOneData(fileName)
  # }
  # 
  # res_root <- './IND-JLMIV+R-1Y-result//SC_'
  # dir.create('IND-JLMIV+R-1Y-result',showWarnings = FALSE)
  # fileNames <- list.files('./IND-JLMIV+R-1Y/',full.names = TRUE)
  # for(fileName in fileNames){
  #   cat(fileName,'\n')
  #   processOneData(fileName)
  # }
  
  res_root <- './AEEEM_LDHHWCHU-result//SC_'
  dir.create('AEEEM_LDHHWCHU-result',showWarnings = FALSE)
  fileNames <- list.files('./AEEEM_LDHHWCHU/',full.names = TRUE)
  for(fileName in fileNames){
    cat(fileName,'\n')
    processOneData(fileName)
  }
  
}
