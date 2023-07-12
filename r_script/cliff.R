library(effsize)
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
getwd()


func <- function(file,comparedModelName){
  df <- read.csv(file)
  indicators <- c('mcc','roi_tp','ifap2')
  
  indicator <- 'roi_tp'
  res <- data.frame(matrix(nrow = 1,ncol = length(indicators)))
  colnames(res) <- indicators
  rownames(res)  <- comparedModelName
  for(indicator in indicators){
    one <- df[df$model=='ONE',indicator]
    comparedModel <- df[df$model==comparedModelName,indicator]
    #cliff <- cliff.delta(one,comparedModel)$estimate 
    cliff<- wilcox.test(one,comparedModel,paired = TRUE)$p.value
    res[,indicator] <- cliff
  }  
  res$file <- file
  return(res)
}

file <- './result/otherModels/MSMDA_ONE_originDatasets_0.2.csv'
res <- func(file,comparedModelName <- 'MSMDA')
total_res <- res

file <- './result/otherModels/MSMDA_ONE_originDatasets_20.csv'
res <- func(file,comparedModelName <- 'MSMDA')
total_res <- rbind(total_res,res)

file <- './result/otherModels/top-core_ONE_originDatasets_0.2.csv'
res <- func(file,comparedModelName <- 'top-core')
total_res <- rbind(total_res,res)

file <- './result/otherModels/top-core_ONE_originDatasets_20.csv'
res <- func(file,comparedModelName <- 'top-core')
total_res <- rbind(total_res,res)
