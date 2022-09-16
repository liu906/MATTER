library(ggplot2)
library(dplyr)
library(hrbrthemes)
source('../performance.r')
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
getwd()

write_median_table <- function(path,path_allE,threshold){
  codeSizePercentages <- seq(0,1,0.05) * 100
  median_table <- data.frame()
  total_res_allE <- data.frame()
  for(codeSizePercentage in codeSizePercentages){
    
    ONE_root <- paste('../ONE-result/cutoff',threshold,'_exclude',codeSizePercentage,sep='')
    files <- c()
    total_res <- data.frame()
    for(dataset in datasets){
      # files <- append(files,list.files(file.path(ONE_root,dataset),full.names = TRUE))
      files <- list.files(file.path(ONE_root,dataset),full.names = TRUE)
      for(file in files){
        df <- read.csv(file)
        
        res <- calculateIndicator(df,threshold)
        colnames(res) <- basename(file)
        temp_df <- as.data.frame(t(res))
        temp_df$dataset <- dataset
        total_res <- rbind(total_res,temp_df)
      }
    }
    
    total_res_median <- as.data.frame(t(as.data.frame(apply(total_res[,1:(ncol(total_res)-1)],2,median))))
    rownames(total_res_median) <- codeSizePercentage 
    median_table <- rbind(median_table,total_res_median)
    total_res$exclude <- codeSizePercentage
    total_res_allE <- rbind(total_res_allE,total_res)
  }
  write.csv(median_table,file = path,row.names = TRUE)
  write.csv(total_res_allE,file = path_allE,row.names = TRUE)
}

write_compared_model_median_table <- function(compared_models,threshold){
  compared_model_median <- data.frame()
  all_total_res <- data.frame()
  for(compared_model in compared_models){
    files <- c()
    total_res <- data.frame()
    for(dataset in datasets){
      files <- list.files(file.path('../baseline-result/',compared_model,dataset),full.names = TRUE)
      for(file in files){
        df <- read.csv(file)
        res <- calculateIndicator(df,threshold)
        colnames(res) <- basename(file)
        temp_df <- as.data.frame(t(res))
        temp_df$dataset <- dataset
        total_res <- rbind(total_res,temp_df)
      }
      
    }
    total_res$model <- compared_model
    all_total_res <- rbind(all_total_res,total_res)
    total_res_median <- as.data.frame(t(as.data.frame(apply(total_res[,1:(ncol(total_res)-2)],2,median))))
    row.names(total_res_median) <- compared_model
    compared_model_median <- rbind(compared_model_median,total_res_median)
  }
  write.csv(all_total_res,file.path('./result/discussion1/',paste('comparedmodel_all_',threshold,'.csv',sep = '')))
  write.csv(compared_model_median,file.path('./result/discussion1/',paste('comparedmodel_median_',threshold,'.csv',sep = '')))
  df <- all_total_res
  for(dataset in datasets){
    tibble <- df[df$dataset==dataset,] %>%
      group_by(model)%>% 
      summarise(Median_tp = median(tp), Median_fp = median(fp), Median_tn = median(tn), Median_fn = median(fn), Median_f1 = median(f1), Median_g1 = median(g1), Median_pf = median(pf), Median_pci  = median(pci), Median_pii = median(pii), Median_recall = median(recall), Median_mcc  = median(mcc), Median_ifa  = median(ifa), Median_ifap = median(ifap), Median_mdd  = median(mdd), Median_ifap2 = median(ifap2), Median_ifa_pii  = median(ifa_pii), Median_ifa_pci  = median(ifa_pci), Median_ifap3 = median(ifap3), Median_auc_roc = median(auc_roc), Median_roi  = median(roi), Median_roi2 = median(roi2), Median_roi3 = median(roi3))
    write.table(tibble,paste('./result/discussion1/comparedmodel_median_',dataset,'_',threshold,'.csv',sep = ''),sep=',',row.names = FALSE) 
  }
}

path <- file.path('./result/discussion1/','ONE_median_ExcludeCodeSizePercentage.csv')
path_allE <- file.path('./result/discussion1/','total_res_allE.csv')
compared_models <- c('CamargoCruz09-NB','Amasaki15-NB','Peters15-NB','KSETE')
datasets <- c("AEEEM","ALLJURECZKO","IND-JLMIV+R-1Y_change59","MA-SZZ-2020","RELINK")
for(threshold in c(0.2,20)){
  write_median_table(path,path_allE,threshold)
  write_compared_model_median_table(compared_models,threshold)
  table <- read.csv(path,row.names = 1)
  table_allE <- read.csv(path_allE,row.names = 1)
  compared_table <- read.csv(file.path('./result/discussion1/',
                                       paste('comparedmodel_median_',threshold,'.csv',sep = '')),row.names = 1)
  
  sub_table_allE <- table_allE[table_allE$exclude %in% seq(0,100,20),]
  indicators <- c('roi_tp','ifap2','recall','pf','mcc','auc_roc')
  # ncol <- length(unique(sub_table_allE$exclude))
  # df <- data.frame(matrix(ncol = ncol,nrow = nrow(sub_table_allE)/ncol))
  
  for(indicator in indicators){
    data <- sub_table_allE[,indicator]
    df <- data.frame(matrix(ncol=0,nrow = nrow(sub_table_allE)/length(unique(sub_table_allE$exclude))))
    df$dataset <- sub_table_allE[sub_table_allE$exclude==0,'dataset']
    for(e in unique(sub_table_allE$exclude)){
      df <- cbind(df,sub_table_allE[sub_table_allE$exclude == e,indicator])
      colnames(df)[ncol(df)] <- e
    }
    write.csv(df,file.path('./result/discussion1/',
                           paste('One_distribution',threshold,indicator,'.csv',sep = '')),row.names = FALSE)
  }
}
# for(threshold in c(0.2,20)){
#   # write_median_table(path,path_allE,threshold)
#   write_compared_model_median_table(compared_models,threshold)
# }


# if(!file.exists(path)){
#   write_median_table(path,path_allE,threshold)
#   write_compared_model_median_table(compared_models,threshold)
# }








