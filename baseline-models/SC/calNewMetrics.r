path <- "D:/OneDrive - Microsoft Student Partners/OneDrive - Student Ambassadors/UCS2/UCS/unsupervised/"
setwd(paste(path,"SC",sep = ""))
getwd()


data <- read.csv('CLA_result.csv')
res <- NULL

for (testName in data$Test){
  cat(testName,'\n')
  test <- read.csv(paste(path,"/SC/result/SC_",testName,'.csv',sep = ""))
  test <- test[with(test, order(-predictLabel, sloc, actualBugLabel)), ]
  
  sloc.cumsum <- cumsum(test[,'sloc'])
  
  tp <- 0
  fp <- 0
  tn <- 0
  fn <- 0
  SNM_precision <- 0
  SNM_recall <- 0
  SNM_fscore <- 0
  SNM_fpr <- 0
  SNM_ifa <- 0
  SNM_ap <- 0
  SNM_rr <- 0
  SNM_cr <- 0
  SNM_roi <- 0
  SNM_mcc <- 0
  SNM_ifap <- 0
  
  tp20 <- 0
  fp20 <- 0
  tn20 <- 0
  fn20 <- 0
  SSC_precision <- 0
  SSC_recall <- 0
  SSC_fscore <- 0
  SSC_fpr <- 0
  SSC_ifa <- 0
  SSC_ap <- 0
  SSC_rr <- 0
  SSC_pii <- 0
  SSC_roi <- 0
  SSC_mcc <- 0
  SSC_ifap <- 0
  SSC_rcr <- 0
  
  counter <- 1
  counter_SNM <- 0
  flag_ifa <- -1
  
  for( i in rownames(test) ){
    if(flag_ifa==-1 && test[i, "predictLabel"]==1 && test[i, "actualBugLabel"]==1){
      flag_ifa <- 0
      SSC_ifa <- SNM_ifa <- counter - 1
      SSC_rr <- SNM_rr <- 1.0 / (counter - 1 + 1)
      SSC_pii_ifa <- SNM_pii_ifa <- SSC_ifa / nrow(test)
      
      if (counter==1){
        SSC_cr_ifa <- SNM_cr_ifa  <- 0
      }
      else{
        SSC_cr_ifa <- SNM_cr_ifa <-  sloc.cumsum[counter-1] / sloc.cumsum[length(sloc.cumsum)]
      }
      SSC_ifap <- SNM_ifap <- SSC_cr_ifa * SSC_pii_ifa
    }
    
    if(test[i, "predictLabel"]==0 && test[i, "actualBugLabel"]==0){
      tn <- tn + 1
    }
    if(test[i, "predictLabel"]==0 && test[i, "actualBugLabel"]==1){
      fn <- fn + 1
    }
    if(test[i, "predictLabel"]==1 && test[i, "actualBugLabel"]==0){
      fp <- fp + 1
    }
    if(test[i, "predictLabel"]==1 && test[i, "actualBugLabel"]==1){
      tp <- tp + 1
    }
    if(test[i, "predictLabel"]==1 ){
      counter_SNM <- counter_SNM + 1
    }
    
    if(sloc.cumsum[counter] <= sloc.cumsum[length(sloc.cumsum)] * 0.2 && test[i, "actualBugLabel"]==1){
      tp20 <- tp20 + 1
    }
    if(sloc.cumsum[counter] <= sloc.cumsum[length(sloc.cumsum)] * 0.2 && test[i, "actualBugLabel"]==0){
      fp20 <- fp20 + 1
    }
    if(sloc.cumsum[counter] > sloc.cumsum[length(sloc.cumsum)] * 0.2 && test[i, "actualBugLabel"]==1){
      fn20 <- fn20 + 1
    }
    if(sloc.cumsum[counter] > sloc.cumsum[length(sloc.cumsum)] * 0.2 && test[i, "actualBugLabel"]==0){
      tn20 <- tn20 + 1
    }
    if(sloc.cumsum[counter] <= sloc.cumsum[length(sloc.cumsum)] * 0.2){
      SSC_rcr <- sloc.cumsum[counter]
      SSC_ap <- SSC_ap + (tp20 / (tp20 + fp20))
    }
    if(test[i, "predictLabel"]==1){
      SNM_ap <- SNM_ap + (tp / (tp + fp))
    }
    counter <- counter + 1
  }
  
  SSC_ap <- SSC_ap / (tp20 + fp20)
  SSC_rcr <- SSC_rcr / (sloc.cumsum[length(sloc.cumsum)] * 0.2)
  
  SSC_pii <- (tp20 + fp20) / (tp20 + fp20 + tn20 + fn20)
  SSC_recall <- tp20 / (tp20 + fn20)
  SSC_precision <- tp20 / (tp20 + fp20)
  SSC_fpr <- fp20 / (fp20 + tn20)
  SSC_fscore <- 2*SSC_recall*SSC_precision/(SSC_recall + SSC_precision)
  SSC_roi <- SSC_recall / (SSC_pii*SSC_rcr)
  
  SSC_mcc <- (tp20 * tn20 - fp20 * fn20) / sqrt((tp20 + fp20) * (tp20 + fn20) * (tn20 + fp20) * (tn20 + fn20))
  
  SNM_ap <- SNM_ap / (tp + fp)
  SNM_cr <- sloc.cumsum[counter_SNM] / sloc.cumsum[length(sloc.cumsum)]
  SNM_recall <- tp / (tp + fn)
  SNM_precision <- tp / (tp + fp)
  SNM_fpr <- fp / (fp + tn)
  SNM_fscore <- 2*SNM_recall*SNM_precision/(SNM_recall + SNM_precision)
  SNM_roi <- SNM_recall / SNM_cr
  SNM_mcc <- (tp * tn - fp * fn) / sqrt((tp + fp) * (tp + fn) * (tn + fp) * (tn + fn))
  
  row <- c(testName,'cpdp','SC',tp,fp,tn,fn,SNM_precision,SNM_recall,SNM_fscore,SNM_fpr,SNM_ifa,SNM_ap,SNM_rr,SNM_cr,SNM_roi,SNM_mcc,SNM_ifap,SNM_cr_ifa,SNM_pii_ifa,tp20,fp20,tn20,fn20,SSC_precision,SSC_recall,SSC_fscore,SSC_fpr,SSC_ifa,SSC_ap,SSC_rr,SSC_pii,SSC_roi,SSC_mcc,SSC_ifap,SSC_cr_ifa,SSC_pii_ifa,SSC_rcr)
  res <- rbind(res,row) 
  
}

ncol(res) 
colnames(res) <- c("Test", "Scenario", "Model", "tp", "fp", "tn", "fn", "SNM_precision", "SNM_recall", "SNM_fscore", "SNM_fpr", "SNM_ifa", "SNM_ap", "SNM_rr", "SNM_cr", "SNM_roi", "SNM_mcc", "SNM_ifap", "SNM_cr_ifa", "SNM_pii_ifa", "tp20", "fp20", "tn20", "fn20", "SSC_precision", "SSC_recall", "SSC_fscore", "SSC_fpr", "SSC_ifa", "SSC_ap", "SSC_rr", "SSC_pii", "SSC_roi", "SSC_mcc", "SSC_ifap", "SSC_cr_ifa", "SSC_pii_ifa", "SSC_rcr")
# write.csv(data,'/SC_result.csv',row.names = FALSE,quote = FALSE)

getwd()
write.csv(res,'SC_result_new.csv',quote = FALSE,row.names = FALSE)
