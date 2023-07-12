get_alberg <- function(filename){
  detail_result <- read.csv(filename)
  detail_result <- detail_result[order(detail_result$actualBugLabel, decreasing = FALSE),]  
  detail_result <- detail_result[order(detail_result$predictedValue, decreasing = TRUE),]
  detail_result <- detail_result[order(detail_result$predictLabel, decreasing = TRUE),]
  detail_result$actualBugLabel <- (detail_result$actualBugLabel >= 1)
  
  cumsum_sloc <- cumsum(detail_result$sloc)
  cumsum_tp <- cumsum(detail_result$actualBugLabel)
  num_positive <- sum(detail_result$actualBugLabel)
  ratio_recall <- cumsum_tp / num_positive
  ratio_sloc <- cumsum_sloc / cumsum_sloc[length(cumsum_sloc)]
  ratio_module <- seq(1,nrow(detail_result),1) / nrow(detail_result)
  df <- data.frame(ratio_recall,ratio_module,ratio_sloc)
  
  # write.csv(file.path(res_root,filename))
  return(df)
}

setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
getwd()
# models <- c('Amasaki15-NB', 'Bellwether', 'CLA', 'CamargoCruz09-NB', 'EASC_E',
#               'EASC_NE', 'FCM',  'ManualDown', 'ManualUp', 'Peters15-NB',
#               'SC')
models <- c('Amasaki15-NB', 'CamargoCruz09-NB', 'Peters15-NB')
# models <- c('EASC_E', 'EASC_NE')
#'KSETE'

datasets <- c('AEEEM', 'ALLJURECZKO', 'IND-JLMIV+R-1Y_change59', 'MA-SZZ-2020',
              'MDP', 'RELINK')
ONE_path <- '../ONE-result/cutoff0.2_exclude20/'

res_path <- file.path('result','alberg')

for(dataset in datasets){
  files <- list.files(file.path(ONE_path,dataset),pattern = 'csv')
  for(file in files){
    ONE_file <- file.path(ONE_path,dataset,file)
    ONE_alberg <- get_alberg(filename = ONE_file)
    ONE_alberg_module  <- ONE_alberg[c('ratio_module','ratio_recall')]
    ONE_alberg_sloc  <- ONE_alberg[c('ratio_sloc','ratio_recall')]
    colnames(ONE_alberg_module) <- paste('ONE',colnames(ONE_alberg_module),sep='_')
    colnames(ONE_alberg_sloc) <- paste('ONE',colnames(ONE_alberg_sloc),sep='_')
    
    for(index in seq(1,length(models),1)){
      model <- models[index]
      model_root <- file.path('../baseline-result/',model,dataset)
      model_file <- list.files(model_root,pattern = file)
      if(length(model_file)>1){
        cat('file match wrong!!!!!')
      }
      model_alberg <- get_alberg(filename = file.path(model_root,model_file))
      model_alberg_module  <- model_alberg[c('ratio_module','ratio_recall')]
      model_alberg_sloc  <- model_alberg[c('ratio_sloc','ratio_recall')]
      colnames(model_alberg_module) <- paste(model,colnames(model_alberg_module),sep='_')
      colnames(model_alberg_sloc) <- paste(model,colnames(model_alberg_sloc),sep='_')
      
      # colnames(model_alberg) <- paste(model,colnames(model_alberg),sep='_')
      ONE_alberg_module <- cbind(ONE_alberg_module,model_alberg_module)
      ONE_alberg_sloc <- cbind(ONE_alberg_sloc,model_alberg_sloc)
    }
    write.csv(ONE_alberg_module,file.path(res_path,paste('module',file,sep='_')),row.names = FALSE)
    write.csv(ONE_alberg_sloc,file.path(res_path,paste('sloc',file,sep='_')),row.names = FALSE)
  }
}





