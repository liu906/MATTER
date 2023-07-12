#feature filter
feature <- c("MOSER_age", "MOSER_authors", "MOSER_avg_changeset",
             "MOSER_avg_code_churn", "MOSER_avg_lines_added", "MOSER_avg_lines_deleted", 
             "MOSER_bugfix", "MOSER_max_changeset", "MOSER_max_code_churn", 
             "MOSER_max_lines_added", "MOSER_max_lines_deleted", "MOSER_refactorings",
             "MOSER_revisions", "MOSER_sum_code_churn", "MOSER_sum_lines_added", 
             "MOSER_sum_lines_deleted", "MOSER_weighted_age", "HASSAN_edhcm",
             "HASSAN_hcm", "HASSAN_ldhcm", "HASSAN_lgdhcm", "HASSAN_whcm","bug")
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
getwd()
root <- file.path("..","dataset","nominal","IND-JLMIV+R-1Y_change")
files <- list.files(root)
for(file in files){
  releases <- list.files(file.path(root,file))
  for(release in releases){
    release_path <- file.path(root,file,release)
    df <- read.csv(release_path)
    write.csv(df[,feature],release_path,row.names = FALSE)
  }
}