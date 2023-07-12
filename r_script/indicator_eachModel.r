# load dplyr and tidyr library
library(dplyr)
library(tidyr)
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
getwd()
#type 1
compute_corr_on_each_model <- function(indicators,thresholds){
  for(threshold in thresholds){
    flag_first_column = TRUE
    setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
    getwd()
    root <- 'result/rq1'
    res_root <- 'result/rq_indicator/model/'
    file_name = list.files(root,pattern = paste(indicators[1],'.*',threshold,'.csv',sep=''))
    ori_data <- read.csv(file.path(root,file_name),row.names = 1)
    ori_data$dataset <- NULL
    ori_data$ONE <- NULL
    n_models = ncol(ori_data)
    flag_first_model = TRUE
    for(idx in seq(n_models)){
      flag_first_indicator = TRUE
      for(indicator in indicators){
        file_name = list.files(root,pattern = paste('baseline_',indicator,'_comparison.*',threshold,'.csv',sep=''))
        data <- read.csv(file.path(root,file_name),row.names = 1)
        data$dataset <- NULL
        data$ONE <- NULL
        
        if(flag_first_indicator){
          flag_first_indicator = FALSE
          res_df = data.frame(matrix(nrow = nrow(data),ncol=0))
          rownames(res_df) = rownames(data)
        }
        one_column = data[,idx]
        # colnames(one_column) = indicator
        res_df[,indicator] = one_column
      }
      # write.csv(res_df,file.path(res_root,paste(effort_aware,'_','performance_',threshold,rownames(ori_data)[idx],sep='')))
      kendall = cor(res_df, method="kendall", use="pairwise") 
      pearson = cor(res_df, method="pearson", use="pairwise") 
      spearman = cor(res_df, method="spearman", use="pairwise") 
      
      write.csv(kendall,file.path(res_root,paste(colnames(ori_data)[idx],'_',indicators[1],'_kendall_',threshold,'.csv',sep='')))
      write.csv(pearson,file.path(res_root,paste(colnames(ori_data)[idx],'_',indicators[1],'_pearson_',threshold,'.csv',sep='')))
      write.csv(spearman,file.path(res_root,paste(colnames(ori_data)[idx],'_',indicators[1],'_spearman_',threshold,'.csv',sep='')))
    }
    
  }
}

thresholds = c('0.2','20')

indicators <-  c('mcc','recall','precision','f1','g1','pf')
compute_corr_on_each_model(indicators,thresholds)

indicators <-  c('roi_tp','roi','recall','pii','pci')
compute_corr_on_each_model(indicators,thresholds)

indicators <- c('ifap2','ifa','ifa_pci','ifa_pii')
compute_corr_on_each_model(indicators,thresholds)

#summary


summary_function <- function(res_root,pattern){
  files <- list.files(res_root,pattern)
  first_flag = TRUE
  counter <- 1
  for (file in files) {
    df <- read.csv(file.path(res_root,file),row.names = 1)
    
    if(startsWith(file,'EASC_E')){
      file <- str_replace(file,'EASC_E','EASC-E')
    }else if(startsWith(file,'EASC_NE')){
      file <- str_replace(file,'EASC_NE','EASC-NE')
    }
    
    if(grepl('roi_tp',file)){
      file <- str_replace(file,'roi_tp','roi-tp')
    }
    
    df$target <- rownames(df)
    df$model <- file
    rownames(df) <- seq(counter,counter+nrow(df)-1)
    counter <- nrow(df) + 1
    if(first_flag){
      total_df <- df 
      first_flag <- FALSE
    }else{
      total_df <- rbind(total_df,df)
    }
  }
  total_df <- total_df %>% separate(model, into =  c('model','indicator','corr','threshold'),sep='_')
  total_df$indicator <- NULL
  return(total_df)
}

df <- summary_function(res_root = 'result/rq_indicator/model/',pattern = '.*ifap2')
write.csv(df,file.path(res_root,'result/','ifap.csv'),row.names = FALSE)

df <- summary_function(res_root = 'result/rq_indicator/model/',pattern = '.*roi_tp')
write.csv(df,file.path(res_root,'result/','roi_tp.csv'),row.names = FALSE)

df <- summary_function(res_root = 'result/rq_indicator/model/',pattern = '.*mcc')
write.csv(df,file.path(res_root,'result/','mcc.csv'),row.names = FALSE)
