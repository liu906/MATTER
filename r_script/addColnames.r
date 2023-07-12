setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
getwd()



modify_sloc_cloumn <- function(des_root,origin_root){
  origin_files <- list.files(origin_root,full.names = TRUE)
  for(origin_file in origin_files){
    origin_data <- read.csv(origin_file)
    list.files(des_root)
    files <- list.files(des_root,pattern = 
                          paste(basename(origin_file),'.*',sep=''),
                        full.names = TRUE)
    for (file in files) {
      data <- read.csv(file)
      # colnames(data) <- c('sloc','predictedValue','predictLabel','actualBugLabel')
      data$sloc <- origin_data$loc
      data[data$predictLabel=='T','predictLabel'] <- 1
      data[data$predictLabel=='F','predictLabel'] <- 0
      
      write.csv(data,file,row.names = FALSE)
    }
  }
}
des_root <- '../baseline-result/FCM/IND-JLMIV+R-1Y_change59/'
origin_root <- "../dataset/nominal/temp"
modify_sloc_cloumn(des_root = des_root,origin_root = origin_root)

des_root <- 'D:/work/MATTER/baseline-result/EASC_E/IND-JLMIV+R-1Y_change59'
origin_root <- "../dataset/nominal/temp"
modify_sloc_cloumn(des_root = des_root,origin_root = origin_root)

des_root <- 'D:/work/MATTER/baseline-result/EASC_NE/IND-JLMIV+R-1Y_change59'
origin_root <- "../dataset/nominal/temp"
modify_sloc_cloumn(des_root = des_root,origin_root = origin_root)


des_root <- 'D:/work/MATTER/baseline-models/Bellwether/Bellwether/version_result/IND-JLMIV+R-1Y_change59'
origin_root <- "../dataset/nominal/temp"
modify_sloc_cloumn(des_root = des_root,origin_root = origin_root)

des_root <- 'D:/work/MATTER/baseline-result/Peters15-NB/IND-JLMIV+R-1Y_change59'
origin_root <- "../dataset/nominal/temp"
modify_sloc_cloumn(des_root = des_root,origin_root = origin_root)

des_root <- 'D:/work/MATTER/baseline-result/Amasaki15-NB/IND-JLMIV+R-1Y_change59'
origin_root <- "../dataset/nominal/temp"
modify_sloc_cloumn(des_root = des_root,origin_root = origin_root)

des_root <- 'D:/work/MATTER/baseline-result/CamargoCruz09-NB/IND-JLMIV+R-1Y_change59'
origin_root <- "../dataset/nominal/temp"
modify_sloc_cloumn(des_root = des_root,origin_root = origin_root)

modify_sloc_cloumn_KSETE <- function(des_root,origin_root){
  origin_files <- list.files(origin_root,full.names = TRUE)
  for(origin_file in origin_files){
    origin_data <- read.csv(origin_file)
    loc <- origin_data$loc
    files <- list.files(des_root,pattern = 
                          paste('.*arff_',tools::file_path_sans_ext(basename(origin_file)),'.*',sep=''),
                        full.names = TRUE)
    for (file in files) {
      data <- read.csv(file,header = FALSE)
      colnames(data) <- c('sloc','predictedValue','predictLabel','actualBugLabel')
      data$sloc <- origin_data$loc
      write.csv(data,file,row.names = FALSE)
    }
  }
}
des_root <- '../new_detail_result/IND-JLMIV+R-1Y_change59/'
origin_root <- "../../MATTER/dataset/nominal/temp"
modify_sloc_cloumn_KSETE(des_root,origin_root)
des_root <- '../new_detail_result/MA-SZZ-2020/'
origin_root <- "../../MATTER/dataset/nominal/MA_temp/"
modify_sloc_cloumn_KSETE(des_root,origin_root)





files <- list.files('D:/work/KSETE-master-master/detail_result_backup/detail_result',full.names = TRUE)
for(file in files){
  data <- read.csv(file,header = FALSE)
  colnames(data) <- c('sloc','predictedValue','predictLabel','actualBugLabel')
  write.csv(data,file,row.names = FALSE)
}

