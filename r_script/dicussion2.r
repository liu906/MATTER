#NOTE: delete all files in /discussion2 before run this scirpt
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
getwd()
library(dplyr)
source("../performance.r")
source('../config.r')
source('run.r')


discussion2 <- function(df_models,indicators,res_path,mode,
                        first_time,datasets,profix=''){
  if(mode=='SNM'){
    cutoffs <- seq(0,1,0.1)
  } else if(mode=='SSC'){
    cutoffs <- seq(0,100,10)
  } else{
    cat('mode error!!!')
  }
  
  if(first_time){
    for(cutoff in cutoffs){
      df_models['ONE','res_root'] <- paste('One-result/cutoff',cutoff,'_exclude20',sep = '')
      if(profix==''){
        profix_run = 'stateOfArt'
      }else{
        profix_run = paste('stateOfArt',profix,sep = '_')
      }
      
      run(baselines = row.names(df_models),
          baseline_paths = df_models$res_root,threshold = cutoff,
          profix = profix_run,
          datasets = datasets,
          res_path = file.path('result','discussion2'))
      
    }
  }
  
  for(indicator in indicators){
    df <- data.frame()
    for(cutoff in cutoffs){
      df_models['ONE','res_root'] <- paste('One-result/cutoff',cutoff,'_exclude20',sep = '')
      if(length(datasets)>1){
        f <- list.files(res_path,pattern = paste('stateOfArt_',indicator,'.*_',cutoff,'.csv',sep=''))[1]
      }else{
        f <- list.files(res_path,pattern = paste('stateOfArt_',profix,'_',indicator,'.*_',cutoff,'.csv',sep=''))[1]
      }
      
      data <- read.csv(file.path(res_path,f),row.names = 1)
      
      temp <- data %>% summarise_at(2:ncol(data), median, na.rm = TRUE)
      temp$threshold <- cutoff 
      df <- rbind(df,as.data.frame(temp))
    }  
    
    df <- df[,append(nrow(df_models)+1,seq(nrow(df_models)))]
    write.csv(df,file.path(res_path,'summary',
                           paste('stateOfArt',profix,indicator,mode,'.csv',sep = '_')),row.names = FALSE)
  }
}

df_models <- models
indicators <- c('roi_tp','recall','pf','mcc')
res_path <- file.path('result','discussion2')

for(mode in c('SSC','SNM')){
  discussion2(df_models,indicators,res_path,mode,first_time = TRUE,datasets = c('AEEEM','ALLJURECZKO','IND-JLMIV+R-1Y_change59','MA-SZZ-2020','RELINK'))
  discussion2(df_models,indicators,res_path,mode,first_time = TRUE,datasets = c('AEEEM'),profix='AEEEM')
  discussion2(df_models,indicators,res_path,mode,first_time = TRUE,datasets = c('ALLJURECZKO'),profix='ALLJURECZKO')
  discussion2(df_models,indicators,res_path,mode,first_time = TRUE,datasets = c('IND-JLMIV+R-1Y_change59'),profix='IND_change59')
  discussion2(df_models,indicators,res_path,mode,first_time = TRUE,datasets = c('MA-SZZ-2020'),profix='MA')
  discussion2(df_models,indicators,res_path,mode,first_time = TRUE,datasets = c('RELINK'),profix='RELINK')
}
