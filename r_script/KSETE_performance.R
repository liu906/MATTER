setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
getwd()
source("../performance.r")
source('../config.r')
source('./run.r')



run(baselines = c("KSETE"),
    baseline_paths = c("baseline-result/KSETE"),threshold = 0.2,
    profix = 'stateOfArt',res_path = file.path('result','KSETE'),
    datasets=c('AEEEM', 'ALLJURECZKO',
               'IND-JLMIV+R-1Y_change59', 'MA-SZZ-2020', 'RELINK'))

run(baselines = c("KSETE"),
    baseline_paths = c("baseline-result/KSETE"),threshold = 20,
    profix = 'stateOfArt',res_path = file.path('result','KSETE'),
    datasets=c('AEEEM', 'ALLJURECZKO',
               'IND-JLMIV+R-1Y_change59', 'MA-SZZ-2020', 'RELINK'))

run(baselines = c("KSETE"),
    baseline_paths = c("baseline-result/KSETE"),threshold = -1,
    profix = 'stateOfArt',res_path = file.path('result','KSETE'),
    datasets=c('AEEEM', 'ALLJURECZKO',
               'IND-JLMIV+R-1Y_change59', 'MA-SZZ-2020', 'RELINK'))
library(dplyr)
library(tidyr)


# get mean value of each target file
root <- 'D:/work/MATTER/r_script/result/KSETE'
indicator_files <- list.files(root,pattern = 'csv')
for(indicator_file in indicator_files){
  df <- read.csv(file.path(root,indicator_file),row.names = 1)
  df$filenames <- rownames(df)
  temp <- df %>%
    separate(filenames, c("source_name", "target_name","useless"), ".arff_")
  df$source_name <- temp$source_name
  df$target_name <- temp$target_name
  
  res <- df %>%
    group_by(dataset,target_name) %>%
    summarise_at(vars(KSETE), mean)
  write.table(res,file.path('./result/KSETE/mean_res/',indicator_file),sep = ',',row.names = FALSE)
}

KSETE_root <- file.path('./result/KSETE/mean_res/')
rq2_root <- file.path('./result/rq2/')
files <- list.files(KSETE_root)
for (file in files) {
  rq2_file <- file.path(rq2_root,file)
  rq2_df <- read.csv(rq2_file,row.names = 1)
  dataset <- rq2_df$dataset
  rq2_df$dataset <- NULL
  
  ksete_df <- read.csv(file.path(KSETE_root,file))
  res_df <- data.frame(dataset = dataset, KSETE = ksete_df$KSETE, rq2_df)
  write.csv(res_df,file=rq2_file,row.names = TRUE)
}
# root <- 'D:/work/MATTER/baseline-result/KSETE/IND-JLMIV+R-1Y_change59'
# files <- list.files(root,pattern = 'csv')
# for (file in files) {
#   df <- read.csv(file.path(root,file),header = TRUE)
#   
#   if(sum(is.na(df$predictedValue)) > 0){
#     cat(file,'\n')
#     file.rename(from=file.path(root,file),to=file.path(root,'error',file))
#   }
# }


