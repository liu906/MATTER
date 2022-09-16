setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
getwd()
source('One.r') 
source('config.r')


run_ONE <- function(target_sets_root,res_root,cutoff,excluded_code_size_percentage,name_actualBugLabel,name_sloc){
  root <- target_sets_root
  files <- list.files(root,recursive = TRUE,pattern = 'csv')
  # excluded_code_size_percentage = 20
  res_folder <- file.path(res_root,dataset)
  dir.create(res_folder,showWarnings = FALSE,recursive = TRUE)
  
  
  for(file in files){
    res = one(root,file,excluded_code_size_percentage,cutoff,name_actualBugLabel,name_sloc)
    res = res[,c('actualBugLabel','sloc','predictLabel','predictedValue')]
    
    write.csv(res,file.path(res_folder,basename(file)),row.names = FALSE)
  }
}


list_dataset <- c('AEEEM','RELINK','ALLJURECZKO','MA-SZZ-2020','IND-JLMIV+R-1Y')
list_dataset <- c('AEEEM_LDHHWCHU')

excluded_code_size_percentages <- c(20)
cutoffs <- c(0.2,20)

for (dataset in list_dataset){
  target_sets_root = datasets[dataset,'root']
  name_actualBugLabel = datasets[dataset,'actualBugLabel']
  name_sloc = datasets[dataset,'sloc']
  
  for (excluded_code_size_percentage in excluded_code_size_percentages) {
    for(cutoff in cutoffs){
      res_root = file.path('One-result',paste('cutoff',cutoff,'_exclude',
      excluded_code_size_percentage,sep = ''))
      dir.create(res_root,recursive = TRUE,showWarnings = FALSE)
      run_ONE(target_sets_root,res_root,cutoff,excluded_code_size_percentage,name_actualBugLabel,name_sloc)
    }
  }
}

