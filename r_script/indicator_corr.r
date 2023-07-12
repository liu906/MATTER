setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
getwd()
# install.packages("devtools")
# devtools::install_github("klainfo/ScottKnottESD", ref="development")
# install.packages('svglite')
library(ScottKnottESD)
library(tidyverse)
library(hrbrthemes)
library(viridis)
library(svglite)
source('function.R')
#type 3

# 每个数据集一个表格，行表示模型，列表示性能指标，然后调用API计算tau_b
indicators <-  c('mcc','recall','precision','f1','g1','pf')

indicators <-  c('roi_tp','roi','recall','pii','pci')

indicators <- c('ifap2','ifa','ifa_pci','ifa_pii')


thresholds = c('0.2','20')
getSKrank <- function(ori_data,indicator){
  ori_data$dataset = NULL
  if(indicator == 'ifap2' || indicator == 'pf' || indicator == 'ifa'|| indicator == 'ifa_pci' || indicator == 'ifa_pii'){
    all_rank = as.data.frame(t(apply(ori_data,1,rank)))
  }
  
  else{
    all_rank = as.data.frame(t(apply(-ori_data,1,rank)))
  }
  
  sk <- sk_esd(-all_rank, version='np')
  return(sk)
}


for(threshold in thresholds){
  setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
  getwd()
  root <- 'result/rq1'
  res_root <- 'result/rq_indicator/'
  file_name = list.files(root,pattern = paste(indicators[1],'.*',threshold,'.csv',sep=''))
  ori_data <- read.csv(file.path(root,file_name),row.names = 1)
  ori_data$ONE <- NULL
  
  flag_first_target = TRUE
  
  for(indicator in indicators){
      file_name = list.files(root,pattern = paste('baseline_',indicator,'_comparison.*',threshold,'.csv',sep=''))
      data <- read.csv(file.path(root,file_name),row.names = 1)
      data$dataset <- NULL
      data$ONE <- NULL
      
      sk = getSKrank(data,indicator)
      if(flag_first_target){
        total_sk = as.data.frame(sk$groups)
        colnames(total_sk) <- indicator
        flag_first_target = FALSE
      }else{
        
        total_sk[rownames(as.data.frame(sk$groups)),indicator] = sk$groups
      }
    }
  
  
  kendall = cor(total_sk, method="kendall", use="pairwise") 
  pearson = cor(total_sk, method="pearson", use="pairwise") 
  spearman = cor(total_sk, method="spearman", use="pairwise") 
  WS_res = WS(total_sk)
  
  write.csv(kendall,file.path(res_root,paste('sk_','kendall_',threshold,indicators[1],'.csv',sep='')))
  write.csv(pearson,file.path(res_root,paste('sk_','pearson_',threshold,indicators[1],'.csv',sep='')))
  write.csv(spearman,file.path(res_root,paste('sk_','spearman_',threshold,indicators[1],'.csv',sep='')))
  write.csv(WS_res,file.path(res_root,paste('WS_',threshold,indicators[1],'.csv',sep='')))
    
}
  
