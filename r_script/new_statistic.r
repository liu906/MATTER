library(effsize)
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
getwd()

#BY adjust
adjust <- function(df){
  arr <- c()
  for(i in colnames(df)){
    arr <- append(arr , df[,i])
  }
  arr <- p.adjust(arr, method = "BY", n = length(arr))
  for(i in 1:ncol(df)){
    df[,colnames(df)[i]] <- arr[((i - 1)*nrow(df) + 1) : (i*nrow(df))]
    arr <- append(arr , df[,i])
  }
  return(df)
}

stat <- function(indicators,dataset,threshold,res_path,save_path) {
  df_pvalue <- data.frame()
  df_cliff <- data.frame()
  df_cohen <- data.frame()
  
  for (indicator in indicators) {
    
    file <- list.files(res_path,pattern=paste('.*',indicator,'.*_',threshold,'.*csv',sep = ''))[1]
    df <- read.csv(file.path(res_path,file),row.names = 1)
    if(dataset!=''){
      df <- df[df$dataset==dataset,]
    }
    df$dataset = NULL
    
    df_baseline <- df[colnames(df) != "ONE"]
    df_ONE <- df[colnames(df) == "ONE"]
    for(i in colnames(df_baseline)){
      pvalue <- wilcox.test(df_ONE$ONE,df_baseline[,i],paired = TRUE)$p.value
      cliff <- cliff.delta(df_ONE$ONE,df_baseline[,i])$estimate
      cohen <- cohen.d(df_ONE$ONE,df_baseline[,i],paired = TRUE)$estimate
      df_pvalue[i,indicator] <- pvalue
      df_cliff[i,indicator] <- cliff
      df_cohen[i,indicator] <- cohen
    }
  }
  write.csv(df_pvalue,file=file.path(save_path,paste('stat_pvalue_',threshold,'_',dataset,'.csv',sep = '')))
  write.csv(df_cliff,file=file.path(save_path,paste('stat_cliff_',threshold,'_',dataset,'.csv',sep = '')))
  write.csv(df_cohen,file=file.path(save_path,paste('stat_cohen_',threshold,'_',dataset,'.csv',sep = '')))
  
}

# indicators <- c('recall','ifap2','roi','pf','mcc','auc_roc')
indicators <- c('mcc','ifap2','roi_tp')
datasets <- c('','AEEEM', 'ALLJURECZKO', 'IND-JLMIV+R-1Y_change59', 'MA-SZZ-2020', 'RELINK')
thresholds <- c(0.2,20)
res_paths <- c('result/rq1/','result/rq2/')
res_paths <- c('result/rq1/')
for(res_path in res_paths){
  for(threshold in thresholds){
    for(dataset in datasets){
      stat(indicators,dataset,threshold,res_path,res_path)
    }
  }
}





# adjust p value
for (res_path in res_paths) {
  for (dataset in datasets) {
    SSC_file_path <- file.path(res_path,
                               paste('stat_pvalue_',
                                     20,'_',dataset,'.csv',sep = ''))
    SNM_file_path <- file.path(res_path,
                               paste('stat_pvalue_',
                                     0.2,'_',dataset,'.csv',sep = ''))
    #join pvalue of SSC and SNM for BY-adjust
    df_SSC <- read.csv(SSC_file_path,row.names = 1)
    df_SNM <- read.csv(SNM_file_path,row.names = 1)
    colnames(df_SSC) <- paste('SSC',colnames(df_SSC),sep = '_')
    colnames(df_SNM) <- paste('SNM',colnames(df_SNM),sep = '_')
    df_join <- cbind(df_SSC,df_SNM)
    df_join$SSC_ifap2 <- NULL
    df_join$SSC_auc_roc <- NULL
    write.csv(adjust(df_join),
          file.path(res_path,paste('df_join_BYadjust_',dataset,'.csv',sep = '')))
  }
}





