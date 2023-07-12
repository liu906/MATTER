# 每个数据集一个表格，行表示模型，列表示性能指标，然后调用API计算tau_b
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
getwd()
#type 2
compute_corr <- function(indicators,effort_aware,target_indicator,thresholds){
  
  for(threshold in thresholds){
    flag_first_column = TRUE
    setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
    getwd()
    root <- 'result/rq1'
    res_root <- 'result/rq_indicator/'
    file_name = list.files(root,pattern = paste(indicators[1],'.*',threshold,'.csv',sep=''))
    ori_data <- read.csv(file.path(root,file_name),row.names = 1)
    ori_data$ONE <- NULL
    ori_data$dataset <- NULL
    n_targets = nrow(ori_data)
    flag_first_target = TRUE
    for(idx in seq(n_targets)){
      flag_first_indicator = TRUE
      for(indicator in indicators){
        file_name = list.files(root,pattern = paste('baseline_',indicator,'_comparison.*',threshold,'.csv',sep=''))
        data <- read.csv(file.path(root,file_name),row.names = 1)
        data$ONE <- NULL
        data$dataset <- NULL
        
        if(flag_first_indicator){
          flag_first_indicator = FALSE
          res_df = data.frame(matrix(nrow = ncol(data),ncol=0))
          rownames(res_df) = colnames(data)
        }
        one_column = t(data[idx,])
        colnames(one_column) = indicator
        res_df[,indicator] = one_column
      }
      # write.csv(res_df,file.path(res_root,paste(effort_aware,'_','performance_',threshold,rownames(ori_data)[idx],sep='')))
      kendall = cor(res_df, method="kendall", use="pairwise") 
      pearson = cor(res_df, method="pearson", use="pairwise") 
      spearman = cor(res_df, method="spearman", use="pairwise") 
      # write.csv(kendall,file.path(res_root,paste(effort_aware,'_','kendall_',threshold,rownames(ori_data)[idx],sep='')))
      # write.csv(pearson,file.path(res_root,paste(effort_aware,'_','pearson_',threshold,rownames(ori_data)[idx],sep='')))
      # write.csv(spearman,file.path(res_root,paste(effort_aware,'_','spearman_',threshold,rownames(ori_data)[idx],sep='')))
      
      if(flag_first_target){
        flag_first_target = FALSE
        total_kendall = kendall[target_indicator,]
        total_pearson = pearson[target_indicator,]
        total_spearman = spearman[target_indicator,]
      }else{
        temp_kendall = kendall[target_indicator,]
        total_kendall = rbind(total_kendall, temp_kendall)
        temp_pearson = pearson[target_indicator,]
        total_pearson = rbind(total_pearson, temp_pearson)
        temp_spearman = spearman[target_indicator,]
        total_spearman = rbind(total_spearman, temp_spearman)
      }
      
    }
    rownames(total_kendall) = rownames(ori_data)
    rownames(total_pearson) = rownames(ori_data)
    rownames(total_spearman) = rownames(ori_data)
    
    
    write.csv(total_kendall,file.path(res_root,paste(effort_aware,'_',target_indicator,'_kendall_',threshold,'.csv',sep='')))
    write.csv(total_pearson,file.path(res_root,paste(effort_aware,'_',target_indicator,'_pearson_',threshold,'.csv',sep='')))
    write.csv(total_spearman,file.path(res_root,paste(effort_aware,'_',target_indicator,'_spearman_',threshold,'.csv',sep='')))
  }
}

thresholds = c('0.2','20')
indicators <-  c('mcc','pf','precision','recall','f1','g1')
effort_aware <- 'NE'
compute_corr(indicators,effort_aware,target_indicator = 'mcc',thresholds)


indicators <-  c('roi_tp','roi','recall','pii','pci')
effort_aware <- 'E'
compute_corr(indicators,effort_aware,target_indicator = 'roi_tp',thresholds)
compute_corr(indicators,effort_aware,target_indicator = 'recall',thresholds)



indicators <- c('ifap2','ifa','ifa_pci','ifa_pii')
effort_aware <- 'E'
target_indicator = 'ifa_pci'
compute_corr(indicators,effort_aware,target_indicator = 'ifap2',thresholds)
compute_corr(indicators,effort_aware,target_indicator = 'ifa',thresholds)
compute_corr(indicators,effort_aware,target_indicator = 'ifa_pci',thresholds)
compute_corr(indicators,effort_aware,target_indicator = 'ifa_pii',thresholds)

library(tidyr)
library(dplyr)


summary_indicator <- function(pattern,indicator,flag_abs,res_root = 'result/rq_indicator/'){
  files <- list.files(path=res_root,pattern)
  cat('#files fills pattern,',length(files),'\n')
  flag = TRUE
  for(file in files){
    df <- read.csv(file.path(res_root,file),row.names = 1)
    
    df[,colSums(is.na(df))==nrow(df)] <- -100
    
    #df[rowSums(is.na(df))>0,] <- 0
    df <- df %>% drop_na()
    if(flag_abs){
      df <- apply(df,2,abs)
    }
    
    df <- apply(df,2,median)
    if(flag){
      res_df <- as.data.frame(df)
      colnames(res_df) <- file
      flag =FALSE
    }else{
      res_df[,ncol(res_df)+1] <- as.data.frame(df)
      colnames(res_df)[ncol(res_df)] <- file
    }
  }
  
  res_df = as.data.frame(t(res_df))
  res_df[abs(res_df)>1] = 'NA'
  
  res_df[,'name'] = rownames(res_df)
  if(grepl('_',indicator)){
    df <- res_df %>% separate(name, c('effort', 'indicator_half','indicator','corr','threshold'),sep='_')
  }else{
    df <- res_df %>% separate(name, c('effort', 'indicator','corr','threshold'),sep='_')
  }
  
  df$effort <- NULL
  return(df)
}
res_root <- 'result/rq_indicator/'
df <- summary_indicator(pattern = 'E.*ifap2.*',indicator='ifap2',flag_abs = TRUE)
write.csv(df,file.path(res_root,'summary_abs_ifap2.csv'))

df <- summary_indicator(pattern = 'E.*ifap2.*',indicator='ifap2',flag_abs = FALSE)
write.csv(df,file.path(res_root,'summary_ifap2.csv'))



df <- summary_indicator(pattern = 'E.*ifa_pci.*','ifa_pci',flag_abs = TRUE)
write.csv(df,file.path(res_root,'summary_abs_ifa_pci.csv'))

df <- summary_indicator(pattern = 'E.*ifa_pci.*','ifa_pci',flag_abs = FALSE)
write.csv(df,file.path(res_root,'summary_ifa_pci.csv'))


df <- summary_indicator(pattern = 'E.*ifa_pii.*','ifa_pii',flag_abs = TRUE)
write.csv(df,file.path(res_root,'summary_abs_ifa_pii.csv'))

df <- summary_indicator(pattern = 'E.*ifa_pii.*','ifa_pii',flag_abs = FALSE)
write.csv(df,file.path(res_root,'summary_ifa_pii.csv'))


res_root <- 'result/rq_indicator/'
df <- summary_indicator(pattern = 'E.*roi_tp.*',indicator='roi_tp',flag_abs = TRUE)
write.csv(df,file.path(res_root,'summary_abs_roi_tp.csv'))

df <- summary_indicator(pattern = 'E.*roi_tp.*',indicator='roi_tp',flag_abs = FALSE)
write.csv(df,file.path(res_root,'summary_roi_tp.csv'))

df <- summary_indicator(pattern = 'E.*mcc.*',indicator='mcc',flag_abs = TRUE)
write.csv(df,file.path(res_root,'summary_abs_mcc.csv'))

df <- summary_indicator(pattern = 'E.*mcc.*',indicator='mcc',flag_abs = FALSE)
write.csv(df,file.path(res_root,'summary_mcc.csv'))

