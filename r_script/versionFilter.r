library(dplyr)
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
getwd()
df <- read.csv('../dataset/IND-info.csv')
df <- as_tibble(df)
res <- df %>% filter(num_instance < 100 | num_buggy_instance < 10 | buggy_ratio < 0.05)
root <- file.path('..','dataset','nominal','IND-JLMIV+R-1Y_change59')
root2 <- file.path('..','..','KSETE-master-master','Datasets-new','IND-JLMIV+R-1Y_change59')
for(i in seq(length(res$releases))){
  unlink(file.path(root,res$projects[i],paste(strsplit(res$releases[i],'.csv')[[1]],'.arff',sep='')),recursive = TRUE,force = FALSE)
}
