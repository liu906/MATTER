setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
getwd()
root <- file.path("..","dataset","nominal","IND-JLMIV+R-1Y_change59")
root <- file.path("..","..","KSETE-master-master","Datasets-new","IND-JLMIV+R-1Y_change59")
pattern <- "*.csv"
pattern <- '*.arff'


projects <- list.files(root)
df <- data.frame()
files <- list.files(root,recursive = TRUE,pattern = pattern)
releases <- basename(files)
projects <- dirname(files)
df[seq(length(releases)),"releases"] <- releases
df[seq(length(projects)),"projects"] <- projects
# df <- read.csv('../dataset/IND-small-info.csv')
counter <- 0
for(release in releases){
  project <- df[df$release==release,"projects"]
  target_release <- release
  source_releases <- df[df$projects!=project,'releases']
  result_files <- paste(source_releases,'_',target_release,'_1.csv',sep = '')
  result_path <- file.path("..","..",
                           "KSETE-master-master","new_detail_result","IND")
  new_path <- file.path("..","..",
                           "KSETE-master-master","new_detail_result","IND1")
  file.copy(from = file.path(result_path,result_files),
  to = file.path(new_path,result_files))
  
  counter <- counter + nrow(df[df$projects!=project,])
  
}
cat('one to one stric cpdp pairs:',counter,'\n')

for(file in files){
  data <- read.csv(file.path(root,file))
  df[df$release==basename(file),"num_instance"] <- nrow(data)
  df[df$release==basename(file),"num_buggy_instance"] <- sum(data$bug!=0)
  df[df$release==basename(file),"buggy_ratio"] <- sum(data$bug!=0) / nrow(data)
}
write.csv(df,'../dataset/IND-info.csv',row.names = FALSE)







