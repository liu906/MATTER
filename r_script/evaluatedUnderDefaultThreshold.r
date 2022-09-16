setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
getwd()
source("../performance.r")
source('../config.r')
source('./run.r')

one_root = '../One-result/cutoff0.2_exclude20'
# profix = 'baseline'
# root = 'result/rq1/'
profix = 'stateOfArt'
root = 'result/rq2/'
datasets = c('AEEEM',
             'ALLJURECZKO',
             'IND-JLMIV+R-1Y_change59',
             'MA-SZZ-2020',
             'RELINK')
files <- c()
for(dataset in datasets){
  files <- append(files,list.files(file.path(one_root,dataset),full.names = TRUE))
}


file_tp = list.files(root,pattern = paste(profix,'_tp_comparison_-1.csv',sep=''))
file_fp = list.files(root,pattern = paste(profix,'_fp_comparison_-1.csv',sep=''))
tp <- read.csv(file.path(root,file_tp),row.names = 1)
fp <- read.csv(file.path(root,file_fp),row.names = 1)
tp$dataset <- NULL
fp$dataset <- NULL

threshold <- tp+fp
threshold$ONE <- NULL

first_row_flag <- TRUE
for(idx in seq(length(files))){
  file <- files[idx]
  one_df <- read.csv(file)
  
  for(baseline in colnames(threshold)){
    cutoff = threshold[idx,baseline]  / nrow(one_df)
    df_res <- calculateIndicator(one_df,cutoff)
    df_res <- as.data.frame(t(df_res))
    #rownames(df_res) <- basename(file)
    df_res$comparedModel <- baseline
    df_res$file <- basename(file)
    df_res$cutoff <- cutoff
    
    if(first_row_flag){
      first_row_flag = FALSE
      total_res = df_res
    }else{
      total_res[nrow(total_res)+1, ] = df_res
    }
  }
}
rownames(total_res)
write.csv(total_res,file=file.path('./result/ONE_default_threshold/',paste(profix,'_total_res_of_one.csv',sep='')),row.names = FALSE)
indicators <- c('mcc','roi_tp','pf','f1','recall','auc_roc')

for(indicator in indicators){
  file_name = list.files(root,pattern = paste(profix,'_',indicator,'_comparison_-1.csv',sep=''))
  baseline_res <- read.csv(file.path(root,file_name),row.names = 1)
  dataset <- baseline_res$dataset 
  baseline_res$dataset = NULL
  baseline_res$ONE = NULL
  first_flag = TRUE
  for(baseline in colnames(baseline_res)){
    if(first_flag){
      first_flag = FALSE
      two_column_df <- as.data.frame(baseline_res[,baseline])
      colnames(two_column_df) <- baseline
    }else{
      two_column_df[,baseline] <- as.data.frame(baseline_res[,baseline])
    }
    two_column_df[,paste(baseline,'one',sep='_')] <- total_res[total_res$comparedModel==baseline, indicator]
    
  }
  two_column_df$dataset = dataset
  rownames(two_column_df) = rownames(baseline_res)
  write.csv(two_column_df,
            file = file.path('./result/ONE_default_threshold/',
                            paste(profix,'_',indicator,'_comparedUnderAlignedDefaultCutoff.csv',sep='')),
            row.names = TRUE)
  
}
