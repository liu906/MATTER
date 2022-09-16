setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
getwd()
source("../performance.r")
source('../config.r')
source('./run.r')
source('../One.r')
library(effsize)

root = '../baseline-result/DSSDPP/detail_result_179/'
# root = '../baseline-result/DSSDPP/CM1_30/'
# root = '../baseline-result/DSSDPP/ReLink_ratio0.9_rep30/'
model_name = 'DSSDPP'
threshold = -1

files <- list.files(root,full.names = TRUE)
first_flag = TRUE
for(file in files){
  df <- read.csv(file)
  metric <- calculateIndicator(df,threshold)
  nii <- metric['tp','value'] + metric['fp','value']
  if(threshold==-1){
    cutoff <- nii / nrow(df)
  }
  else{
    cutoff=threshold
  }
  one_detail_result <- one('',file,20,cutoff,'actualBugLabel','sloc')
  one_metric <- calculateIndicator(one_detail_result,threshold = -1)
  metric$one_value <- one_metric$value
  t_metric <- as.data.frame(t(metric))
  t_metric$target <- basename(file)
  rownames(t_metric) <- c(model_name,'ONE')
  if(first_flag){
    first_flag = FALSE
    total_res <- t_metric
  }else{
    total_res <- rbind(total_res,t_metric)
  }
}
rownames(total_res) <- seq(nrow(total_res))
total_res$model <- rep(c(model_name,'ONE'),nrow(total_res)/2)

#write.csv(total_res,paste('result/otherModels/',model_name,'_ONE_default_',threshold,'_179.csv',sep=''),row.names = FALSE)


cat(indicator, 'pvalue','cliff','\n')
for (indicator in c('recall','mcc','auc_roc','ifap2','roi_tp')){
  pvalue <- wilcox.test(total_res[total_res$model==model_name,indicator],total_res[total_res$model=='ONE',indicator],pair=TRUE)$p.value
  cliff <- cliff.delta(total_res[total_res$model==model_name,indicator],total_res[total_res$model=='ONE',indicator])$estimate
  cat(indicator, pvalue,cliff,'\n')
}



