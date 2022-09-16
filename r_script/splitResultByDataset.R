# Author: Ryu Date:20220510
# this script is to split the performance computed in computeIndicatorFromDetailResult.r
# by the datasets

setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
getwd()

splitByDataset <- function(root){
  # order in datasets is matter
  datasets <- c('AEEEM', 'ALLJURECZKO', 'IND-JLMIV+R-1Y_change59', 'MA-SZZ-2020', 'RELINK')
  for(dataset in datasets){
    dir.create(file.path(root,dataset),recursive = TRUE,showWarnings = FALSE)
  }
  if(basename(root)=='rq1'){
    pattern = 'baseline.*csv'
  }else if(basename(root)=='rq2'){
    pattern = 'stateOfArt.*csv'
  }
  
  files <- list.files(root,pattern = pattern)
  for(file in files){
    df <- read.csv(file.path(root,file),row.names = 1)
    for(dataset in datasets){
      num_files <- length(list.files(file.path('..','baseline-result','EASC_E',dataset)))
      write.csv(df[1:num_files,],file = file.path(root,dataset,file))
      df <- df[num_files+1:nrow(df),]
    }
  }  
}
root <- file.path('result','rq1')
splitByDataset(root)
root <- file.path('result','rq2')
splitByDataset(root)

