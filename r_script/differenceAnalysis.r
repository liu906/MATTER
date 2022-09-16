setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
getwd()
source("../performance.r")
source('../config.r')
source('./run.r')
#TODO 处理KSETE
library(dplyr)
library(tidyr)

difference_analysis <- function(baseline_model_name,compared_model_name,threshold,datasets){
  compared_result_root = file.path('../baseline-result/',compared_model_name)
  
  difference_result_filename = paste(baseline_model_name,'_',compared_model_name,'_',threshold,'.csv',sep='')
  
  if(threshold==0.2){
    baseline_result_root = '../ONE-result/cutoff0.2_exclude20'
  }else if(threshold==20){
    baseline_result_root = '../ONE-result/cutoff20_exclude20'
  }
  
  first_row_flag = TRUE
  for(dataset in datasets){
    baseline_files <- list.files(file.path(baseline_result_root,dataset))
    baseline_files <- sort(baseline_files)
    compared_files <- list.files(file.path(compared_result_root,dataset))
    compared_files <- sort(compared_files)
    
    if(compared_model_name!='KSETE' & length(baseline_files)!=length(compared_files)){
      print("baseline file length not euqal to compared file length")
      return()
    }
    for(idx in seq(length(baseline_files))){
      baseline_detail_result = read.csv(file.path(baseline_result_root,dataset,baseline_files[idx]))
      
      if(compared_model_name=='KSETE'){
        KSETE_root <- file.path('../baseline-result/KSETE/',dataset)
        KSETE_files <- list.files(KSETE_root,pattern = 'csv')
        
        df <- data.frame(matrix(ncol = 0,nrow = length(KSETE_files)))
        df$filenames <- KSETE_files
        temp <- df %>%
          separate(filenames, c("source_name", "target_name","useless"), ".arff_")
        temp$filenames <- df$filenames
        temp_files <- temp[temp$target_name==tools::file_path_sans_ext(baseline_files[idx]),'filenames']
        compared_full_files = file.path(KSETE_root,temp_files)
      }else{
        compared_full_files = file.path(compared_result_root,dataset,compared_files[idx])
      }
      for(compared_full_file in compared_full_files){
        compared_detail_result = read.csv(compared_full_file)
        
        if(nrow(baseline_detail_result)!=nrow(compared_detail_result)){
          print("baseline file length not euqal to compared file length")
          return()
        } 
        baseline_detail_result = change_label_by_threshold(baseline_detail_result,threshold)
        compared_detail_result = change_label_by_threshold(compared_detail_result,threshold)
        baseline_tp = baseline_detail_result$predictLabel * (baseline_detail_result$actualBugLabel>=1)
        compared_tp = compared_detail_result$predictLabel * (compared_detail_result$actualBugLabel>=1)
        hit = sum(baseline_tp * compared_tp) / sum(compared_tp)
        over = sum(baseline_tp * !compared_tp) / sum(compared_tp)
        if(first_row_flag){
          first_row_flag = FALSE
          res_df = data.frame(matrix(ncol = 3,nrow = 0))
          res_df[1,] = c(baseline_files[idx],hit,over)
          colnames(res_df) = c('target_file','hit','over')
        }
        else{
          res_df[nrow(res_df)+1,] = c(baseline_files[idx],hit,over)
        }
      }
      
    }
  }
  write.csv(res_df,file.path(difference_result_root,difference_result_filename))
}

difference_result_root = './result/differenceAnalysis/'
baseline_model_name = 'ONE'
compared_model_names = c('Bellwether',
                         'EASC_E',
                         'EASC_NE',
                         'SC',
                         'CLA',
                         'FCM',
                         'ManualDown',
                         'ManualUp',
                         'CamargoCruz09-NB',
                         'Amasaki15-NB',
                         'Peters15-NB')
compared_model_names = c('KSETE')

thresholds = c(0.2,20)

datasets <- c('AEEEM',
              'ALLJURECZKO',
              'IND-JLMIV+R-1Y_change59',
              'MA-SZZ-2020',
              'RELINK')
for(threshold in thresholds){
  for(compared_model_name in compared_model_names){
    difference_analysis(baseline_model_name,compared_model_name,threshold,datasets)
  }
}


summary_mean_median <- function(compared_model_names,threshold){
  first_model_flag = TRUE
  for(model in compared_model_names){
    file_name = list.files(difference_result_root,pattern = paste(model,'_',threshold,sep=''))
    df <- read.csv(file.path(difference_result_root,file_name),row.names = 1)
    df$target_file <- NULL
    df <- df[df$hit!=Inf,]
    df <- df[df$over!=Inf,]
    temp <- df %>% summarise(median_hit = median(hit,na.rm = TRUE),
                             median_over = median(over,na.rm = TRUE),
                             mean_hit = mean(hit,na.rm = TRUE),
                             mean_over = mean(over,na.rm = TRUE))
    rownames(temp) <- model
    if(first_model_flag){
      first_model_flag = FALSE
      res_df <- temp
    }else{
      res_df[nrow(res_df)+1,] <- temp
    }
  }
  return(res_df)
}


  
compared_model_names = c('Bellwether',
                         'EASC_E',
                         'EASC_NE',
                         'SC',
                         'CLA',
                         'FCM',
                         'ManualDown',
                         'ManualUp')

res_df = summary_mean_median(compared_model_names,0.2)
write.csv(res_df,file=file.path(difference_result_root,'summary_rq1_0.2.csv'))

res_df = summary_mean_median(compared_model_names,20)
write.csv(res_df,file=file.path(difference_result_root,'summary_rq1_20.csv'))

compared_model_names = c('KSETE',
                         'CamargoCruz09-NB',
                         'Amasaki15-NB',
                         'Peters15-NB')
res_df = summary_mean_median(compared_model_names,0.2)
write.csv(res_df,file=file.path(difference_result_root,'summary_rq2_0.2.csv'))
res_df = summary_mean_median(compared_model_names,20)
write.csv(res_df,file=file.path(difference_result_root,'summary_rq2_20.csv'))








