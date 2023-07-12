# EASC_E ranks the modules in descending order by score/LOC
# EASC_NE ranks the modules in descending order by score*LOC.
# both EASC_E and EASC_NE first rank the predicted defective 
# modules and non-defective modules separately and then
# concatenate them to obtain a final ranking
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
getwd()
files <- list.files('../baseline-result/EASC_E/IND-JLMIV+R-1Y_change59/',
                    full.names = TRUE)
for (file in files) {
  df <- read.csv(file)
  df[df$predictLabel==1,'predictedValue'] <- 
    1000 + df[df$predictLabel==1,'predictedValue'] / (df[df$predictLabel==1,'sloc']+1)
  df[df$predictLabel==0,'predictedValue'] <- 
    df[df$predictLabel==0,'predictedValue'] / (df[df$predictLabel==0,'sloc']+1)
  write.csv(df,file,row.names = FALSE)
}

files <- list.files('../baseline-result/EASC_NE/IND-JLMIV+R-1Y_change59/',
                    full.names = TRUE)
for (file in files) {
  df <- read.csv(file)
  df[df$predictLabel==1,'predictedValue'] <- 
    10000000 + df[df$predictLabel==1,'predictedValue'] * df[df$predictLabel==1,'sloc']
  df[df$predictLabel==0,'predictedValue'] <- 
    df[df$predictLabel==0,'predictedValue'] * df[df$predictLabel==0,'sloc']
  write.csv(df,file,row.names = FALSE)
}