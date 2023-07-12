setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
getwd()
library(dplyr)
indicators <- c('pci','pii','mcc','pf','roi_tp')
prefix <- 'baseline'
thresholds <- c('0.2','20','-1')
file_path <- 'result/rq1/'

first_flag = TRUE
counter = 1
for(threshold in thresholds){
  for(indicator in indicators){
    filename = paste(prefix,indicator,'comparison',threshold,sep='_')
    filename = paste(filename,'.csv',sep='')
    df <- read.csv(file.path(file_path,filename),row.names = 1)
    median_df <- df %>%  select(-one_of('dataset')) %>%
      summarise(across(everything(), list(Median=median)))
    rownames(median_df) <- counter
    counter <- counter + 1
    median_df$threshold <- threshold
    median_df$indicator <- indicator
    if(first_flag){
      total_res <- median_df
      first_flag = FALSE
    }else{
      total_res[nrow(total_res)+1,] <- median_df
    }
    
  }
  
}
total_res
total_res$ONE_Median <- NULL
write.csv(total_res,file.path(file_path,'total_indicator_median.csv'),row.names = FALSE)

