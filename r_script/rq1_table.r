setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
getwd()
library(dplyr)

get_summary <- function(df,n=3){
    median_df <- df %>%
        group_by(dataset)%>% 
        summarise(across(everything(), list(Median=median)))
    mean_df <- df %>%
      group_by(dataset)%>% 
      summarise(across(everything(), list(Mean=mean)))
    sd_df <- df %>%
        group_by(dataset)%>% 
        summarise(across(everything(), list(SD=sd)))
    
    median_df_total <- df %>%  select(-one_of('dataset')) %>%
        summarise(across(everything(), list(Median=median)))
    
    mean_df_total <- df %>%  select(-one_of('dataset')) %>%
      summarise(across(everything(), list(Mean=mean)))
    
    sd_df_total <- df %>%  select(-one_of('dataset')) %>%
        summarise(across(everything(), list(SD=sd)))
    
    median_df <- as.data.frame(median_df)
    rownames(median_df) <- median_df$dataset
    median_df$dataset <- NULL
    
    mean_df <- as.data.frame(mean_df)
    rownames(mean_df) <- mean_df$dataset
    mean_df$dataset <- NULL
    
    sd_df <- as.data.frame(sd_df)
    rownames(sd_df) <- sd_df$dataset
    sd_df$dataset <- NULL
    
    
    median_df <- format(round(median_df, digits=n), nsmall = n) 
    colnames(median_df) <- colnames(df)[-1]
    sd_df <- format(round(sd_df, digits=n), nsmall = n) 
    colnames(sd_df) <- colnames(df)[-1]
    
    median_df_total <- format(round(median_df_total, digits=n), nsmall = n) 
    colnames(median_df_total) <- colnames(df)[-1]
    sd_df_total <- format(round(sd_df_total, digits=n), nsmall = n) 
    colnames(sd_df_total) <- colnames(df)[-1]
    
    mean_df <- format(round(mean_df, digits=n), nsmall = n) 
    colnames(mean_df) <- colnames(df)[-1]
    
    mean_df_total <- format(round(mean_df_total, digits=n), nsmall = n) 
    colnames(mean_df_total) <- colnames(df)[-1]
    
    if(stats_item=='median'){
      
    }else if(stats_item=='mean'){
      median_df_total <- mean_df_total
      median_df <- mean_df
    }
    
    
    return(list('median_df'=median_df,
                'sd_df'=sd_df,
                'median_df_total'=median_df_total,
                'sd_df_total'=sd_df_total
        ))
}


bash <- function(file_path,prefix,add_default_threshold){
  if(add_default_threshold){
    col_total_res <- c('SSC_mcc','SSC_roi_tp','SNM_mcc','SNM_roi_tp','Default_mcc','Default_roi_tp','ifap2')
  }else{
    col_total_res <- c('SSC_mcc','SSC_roi_tp','SNM_mcc','SNM_roi_tp','ifap2')
  }
    
    
    ###########SSC_MCC###########
    filename = paste(prefix,'mcc','comparison','20',sep='_')
    filename = paste(filename,'.csv',sep='')
    df <- read.csv(file.path(file_path,filename),row.names = 1)
    
    total_res <- data.frame(matrix(ncol = length(col_total_res),nrow = ncol(df)-1))
    colnames(total_res) <- col_total_res
    rownames(total_res) <- colnames(df)[-1]
    
    datasets <- unique(df$dataset)
    
    indicator_options = 2
    if(add_default_threshold){
      alignment_options = 3
    }else{
      alignment_options = 2
    }
    total_res_split_dataset <- 
      data.frame(matrix(ncol = ncol(df)-1+3,
                        nrow = length(datasets)*(indicator_options*alignment_options+1)))
    
    colnames(total_res_split_dataset) <- c('indicator','effort','dataset',colnames(df)[-1])
    total_res_split_dataset$indicator <- 
      c(rep('MCC',length(datasets)*alignment_options),
        rep('ROI',length(datasets)*alignment_options),
        rep('eIFA',length(datasets)))
    if(add_default_threshold){
      total_res_split_dataset$effort <- c(rep(c(rep('SSC',length(datasets)),
                                                rep('SNM',length(datasets))),
                                              rep('Default',length(datasets)),indicator_options),
                                          rep(' ',length(datasets)))
    }else{
      total_res_split_dataset$effort <- c(rep(c(rep('SSC',length(datasets)),
                                                rep('SNM',length(datasets))),alignment_options),
                                          rep(' ',length(datasets)))
    }
    
    total_res_split_dataset$dataset <- rep(datasets,indicator_options*alignment_options+1)
    
    res <- get_summary(df)

    format_med <- res$median_df_total
    format_sd <- res$sd_df_total
    
    total_res$SSC_mcc <- paste(format_med,'(',format_sd,')',sep='')
    
    format_med_split <- as.matrix(res$median_df)
    format_sd_split <- as.matrix(res$sd_df)
    
    temp = matrix(paste(format_med_split,'(',format_sd_split,')',sep=''),
           nrow = nrow(format_med_split),
           dimnames = dimnames(format_med_split))
    total_res_split_dataset[total_res_split_dataset$indicator=='MCC' & 
                                total_res_split_dataset$effort=='SSC',
                            colnames(df)[-1]] <- temp
    
    ###########SSC_roi_tp###########
    filename = paste(prefix,'roi_tp','comparison','20',sep='_')
    filename = paste(filename,'.csv',sep='')
    df <- read.csv(file.path(file_path,filename),row.names = 1)
    rownames(total_res) <- colnames(df)[-1]
    res <- get_summary(df,n=1)
    format_med <- res$median_df_total
    format_sd <- res$sd_df_total
    total_res$SSC_roi_tp <- paste(format_med,'(',format_sd,')',sep='')
    
    format_med_split <- as.matrix(res$median_df)
    format_sd_split <- as.matrix(res$sd_df)
    temp = matrix(paste(format_med_split,'(',format_sd_split,')',sep=''),
                  nrow = nrow(format_med_split),
                  dimnames = dimnames(format_med_split))
    total_res_split_dataset[total_res_split_dataset$indicator=='ROI' & 
                                total_res_split_dataset$effort=='SSC',
                            colnames(df)[-1]] <- temp
    
    
    ###########SNM_MCC###########
    filename = paste(prefix,'mcc','comparison','0.2',sep='_')
    filename = paste(filename,'.csv',sep='')
    df <- read.csv(file.path(file_path,filename),row.names = 1)
    rownames(total_res) <- colnames(df)[-1]
    res <- get_summary(df)
    format_med <- res$median_df_total
    format_sd <- res$sd_df_total
    total_res$SNM_mcc <- paste(format_med,'(',format_sd,')',sep='')
    
    format_med_split <- as.matrix(res$median_df)
    format_sd_split <- as.matrix(res$sd_df)
    temp = matrix(paste(format_med_split,'(',format_sd_split,')',sep=''),
                  nrow = nrow(format_med_split),
                  dimnames = dimnames(format_med_split))
    total_res_split_dataset[total_res_split_dataset$indicator=='MCC' & 
                                total_res_split_dataset$effort=='SNM',
                            colnames(df)[-1]] <- temp
    
    
    ###########SNM_roi_tp###########
    filename = paste(prefix,'roi_tp','comparison','0.2',sep='_')
    filename = paste(filename,'.csv',sep='')
    df <- read.csv(file.path(file_path,filename),row.names = 1)
    rownames(total_res) <- colnames(df)[-1]
    res <- get_summary(df,n=1)
    format_med <- res$median_df_total
    format_sd <- res$sd_df_total
    total_res$SNM_roi_tp <- paste(format_med,'(',format_sd,')',sep='')
    
    format_med_split <- as.matrix(res$median_df)
    format_sd_split <- as.matrix(res$sd_df)
    temp = matrix(paste(format_med_split,'(',format_sd_split,')',sep=''),
                  nrow = nrow(format_med_split),
                  dimnames = dimnames(format_med_split))
    total_res_split_dataset[total_res_split_dataset$indicator=='ROI' & 
                                total_res_split_dataset$effort=='SNM',
                            colnames(df)[-1]] <- temp
    
    
    if(add_default_threshold){
      ###########Default_MCC###########
      filename = paste(prefix,'mcc','comparison','-1',sep='_')
      filename = paste(filename,'.csv',sep='')
      df <- read.csv(file.path(file_path,filename),row.names = 1)
      rownames(total_res) <- colnames(df)[-1]
      res <- get_summary(df)
      format_med <- res$median_df_total
      format_sd <- res$sd_df_total
      total_res$Default_mcc <- paste(format_med,'(',format_sd,')',sep='')
      
      format_med_split <- as.matrix(res$median_df)
      format_sd_split <- as.matrix(res$sd_df)
      temp = matrix(paste(format_med_split,'(',format_sd_split,')',sep=''),
                    nrow = nrow(format_med_split),
                    dimnames = dimnames(format_med_split))
      total_res_split_dataset[total_res_split_dataset$indicator=='MCC' & 
                                total_res_split_dataset$effort=='Default',
                              colnames(df)[-1]] <- temp
      
      ###########Default_roi_tp########
      filename = paste(prefix,'roi_tp','comparison','-1',sep='_')
      filename = paste(filename,'.csv',sep='')
      df <- read.csv(file.path(file_path,filename),row.names = 1)
      rownames(total_res) <- colnames(df)[-1]
      res <- get_summary(df,n=1)
      format_med <- res$median_df_total
      format_sd <- res$sd_df_total
      total_res$Default_roi_tp <- paste(format_med,'(',format_sd,')',sep='')
      
      format_med_split <- as.matrix(res$median_df)
      format_sd_split <- as.matrix(res$sd_df)
      temp = matrix(paste(format_med_split,'(',format_sd_split,')',sep=''),
                    nrow = nrow(format_med_split),
                    dimnames = dimnames(format_med_split))
      total_res_split_dataset[total_res_split_dataset$indicator=='ROI' & 
                                total_res_split_dataset$effort=='Default',
                              colnames(df)[-1]] <- temp
    }
    #######################################################
    filename = paste(prefix,'ifap2','comparison','0.2',sep='_')
    filename = paste(filename,'.csv',sep='')
    df <- read.csv(file.path(file_path,filename),row.names = 1)
    rownames(total_res) <- colnames(df)[-1]
    res <- get_summary(df)
    format_med <- res$median_df_total
    format_sd <- res$sd_df_total
    total_res$ifap2 <- paste(format_med,'(',format_sd,')',sep='')
    
    format_med_split <- as.matrix(res$median_df)
    format_sd_split <- as.matrix(res$sd_df)
    temp = matrix(paste(format_med_split,'(',format_sd_split,')',sep=''),
                  nrow = nrow(format_med_split),
                  dimnames = dimnames(format_med_split))
    total_res_split_dataset[total_res_split_dataset$indicator=='eIFA' & 
                                total_res_split_dataset$effort==' ',
                            colnames(df)[-1]] <- temp
    ######################################################
    
    write.csv(total_res,file = file.path(file_path,paste(stats_item,'_sd_table.csv',sep='')))
    write.csv(total_res_split_dataset,file = file.path(file_path,paste(stats_item,'_sd_split_dataset_table.csv',sep='')))
    
    
}
stats_item = 'mean'

# rq1
file_path <- 'result/rq1/'
prefix <- 'baseline'
bash(file_path,prefix,add_default_threshold=FALSE)

# rq2
file_path <- 'result/rq2/'
prefix <- 'stateOfArt'
bash(file_path,prefix,add_default_threshold=FALSE)
#bash(file_path,prefix,add_default_threshold=TRUE)

########################################

stats_item = 'median'
# rq1
file_path <- 'result/rq1/'
prefix <- 'baseline'
bash(file_path,prefix,add_default_threshold=FALSE)

# rq2
file_path <- 'result/rq2/'
prefix <- 'stateOfArt'
bash(file_path,prefix,add_default_threshold=FALSE)





