source('../config.r')

setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
setwd('../result/')

# codeSizePercentages <- c(0.05,0.1,0.15,0.2,0.25,0.3)
codeSizePercentages <- c('0.0','0.05','0.1','0.15','0.2','0.25','0.3','0.35','0.4','0.45','0.5','0.55','0.6','0.65','0.7','0.75','0.8','0.85','0.9','0.95','1.0')
# codeSizePercentages <- seq(from = 0, to = 1, by = 0.05)
datasets <- c("AEEEM","ALLJURECZKO","IND-JLMIV+R-1Y","MA-SZZ-2020","RELINK")
datasets

scenarios <- c('SNM','SSC')
comparedModels <- c("Amasaki15-NB","Peters15-NB","CamargoCruz09-NB","Turhan09-DT","Watanabe08-DT","CamargoCruz09-DT","TunedManualUp","EASC_E","EASC_NE","CLA","SC","FCM")

snm_indicators <- c('SNM_roi','SNM_ifap','SNM_recall')
ssc_indicators <- c('SSC_roi','SSC_ifap','SSC_recall')

res <- data.frame(matrix(ncol = 6,nrow = 0))
colnames(res) <- c('scenario','comparedModel','codeSizePercentage','roi','ifap','recall')

for(scenario in scenarios){
for(comparedModel in comparedModels){
  for(codeSizePercentage in codeSizePercentages){
    all_df <- data.frame()
    for(dataset in datasets){
      aPattern <- paste(dataset,'.*_',comparedModel,'_.*',scenario,'.*percentage',
                        codeSizePercentage,'.csv',sep = '')
        files <- list.files(path=dataset,pattern=aPattern,full.names = TRUE)
        if(length(files)!=1){
          cat(aPattern,length(files),'\n')
          stop('more than one file fit the pattern or no file fit the pattern')
        }
        file <- files[1]
        df <- read.csv(file)
        if(scenario=='SNM'){
          indicators <- snm_indicators
        }else if(scenario=='SSC'){
          indicators <- ssc_indicators
        }
        all_df <- rbind(all_df, df[,indicators])
        
    }
    res[nrow(res)+1,] <- c(scenario,comparedModel,codeSizePercentage,as.vector(colMeans(all_df)))
    }
  }
  
}


datasets <- c('teraPROMISE')
scenarios <- c('SNM','SSC')
comparedModels <- c('Kcore')
for(scenario in scenarios){
  for(comparedModel in comparedModels){
    for(codeSizePercentage in codeSizePercentages){
      all_df <- data.frame()
      for(dataset in datasets){
        aPattern <- paste(dataset,'.*_',comparedModel,'_.*',scenario,'.*percentage',
                          codeSizePercentage,'.csv',sep = '')
        files <- list.files(path=dataset,pattern=aPattern,full.names = TRUE)
        if(length(files)!=1){
          cat(aPattern,length(files),'\n')
          stop('more than one file fit the pattern or no file fit the pattern')
        }
        file <- files[1]
        df <- read.csv(file)
        if(scenario=='SNM'){
          indicators <- snm_indicators
        }else if(scenario=='SSC'){
          indicators <- ssc_indicators
        }
        all_df <- rbind(all_df, df[,indicators])
        
      }
      res[nrow(res)+1,] <- c(scenario,comparedModel,codeSizePercentage,as.vector(colMeans(all_df)))
    }
  }
  
}





res['pUCS_roi'] <- NULL
res['pUCS_ifap'] <- NULL
res['pUCS_recall'] <- NULL



setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

for(i in 1:nrow(res)){
  scenario <- res[i,'scenario']
  comparedModel <- res[i,'comparedModel']
  codeSizePercentage <- res[i,'codeSizePercentage']
  if(scenario=='SNM'){
    indicators <- snm_indicators
  }else if(scenario=='SSC'){
    indicators <- ssc_indicators
  }
  for(indicator in indicators){
    file_path <- paste('../statistic/tUCS/all-',comparedModel,'_vs_tUCS_',indicator,'_',scenario,'_cutoff_by_positive_number.csv',sep='')
    df <- read.csv(file = file_path,row.names = 1)
    indicator.value <- mean(as.numeric(df[3:nrow(df),2]))
    res[i,paste('pUCS_',strsplit(indicator,'_')[[1]][2],sep='')] <- indicator.value
  }
  
}
write.csv(res,file='./result/indicatorsWithCodeSizePercentage.csv',row.names = FALSE)
#???߳ɹ? ?û?????bili_2014421788?? ??ʱ???롾123456??

