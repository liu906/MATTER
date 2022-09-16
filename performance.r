library(pROC)

change_label_by_threshold <- function(detail_result,threshold){
  # threshold -1: default classification threshold
  # threshold 0-1: number of module alignment
  # threshold 1-100: SLOC alignment
  
  detail_result <- detail_result[order(detail_result$actualBugLabel, decreasing = FALSE),]  
  detail_result <- detail_result[order(detail_result$predictedValue, decreasing = TRUE),]
  detail_result <- detail_result[order(detail_result$predictLabel, decreasing = TRUE),]
  detail_result$actualBugLabel <- (detail_result$actualBugLabel >= 1)
  # 0.2 means 0.2 of total module
  # 20 means 20% of total SLOC
  if (sum(detail_result$actualBugLabel)==0){
    auc_roc = 0
  }else{
    auc_roc <- auc(roc(detail_result$actualBugLabel, detail_result$predictedValue,direction='<'))
  }
  
  cumsum_sloc <- cumsum(detail_result$sloc)
  cumsum_tp <- cumsum(detail_result$actualBugLabel)
  
  
  
  if(threshold==-1){
    cutoff <- sum(detail_result$predictLabel == 1)
  }else{
    if(threshold<=1&&threshold>0){
      cutoff <- as.integer(nrow(detail_result) * threshold)
    }else{
      if(threshold==100){
        topsum <- cumsum_sloc[length(cumsum_sloc)]
        cutoff <- length(cumsum_sloc)
      }else{
        topsum <- cumsum_sloc[length(cumsum_sloc)] * 0.01 * threshold  
        flag <- which(cumsum_sloc > topsum)
        cutoff <- flag[1] - 1  
      }
      
      
    }
    detail_result[1:cutoff,"predictLabel"] <- 1
    if(cutoff < nrow(detail_result)){
      detail_result[(cutoff+1):nrow(detail_result),"predictLabel"] <- 0  
    }
    
  } 
  return(detail_result)
}

calculateIndicator <- function(detail_result,threshold){
 
  # threshold -1: default classification threshold
  # threshold 0-1: number of module alignment
  # threshold 1-100: SLOC alignment
  
  detail_result <- detail_result[order(detail_result$actualBugLabel, decreasing = FALSE),]  
  detail_result <- detail_result[order(detail_result$predictedValue, decreasing = TRUE),]
  detail_result <- detail_result[order(detail_result$predictLabel, decreasing = TRUE),]
  detail_result$actualBugLabel <- (detail_result$actualBugLabel >= 1)
  # 0.2 means 0.2 of total module
  # 20 means 20% of total SLOC
  if (sum(detail_result$actualBugLabel)==0){
    auc_roc = 0
  }else{
    auc_roc <- auc(roc(detail_result$actualBugLabel, detail_result$predictedValue,direction='<'))
  }
  
  cumsum_sloc <- cumsum(detail_result$sloc)
  cumsum_tp <- cumsum(detail_result$actualBugLabel)
  
  
  
  if(threshold==-1){
    cutoff <- sum(detail_result$predictLabel == 1)
  }else{
    if(threshold<=1&&threshold>0){
      if(nrow(detail_result) * threshold - as.integer(nrow(detail_result) * threshold)>0.99999){
        cutoff <- as.integer(nrow(detail_result) * threshold) + 1
        
      }else{
        cutoff <- as.integer(nrow(detail_result) * threshold)
      }
      
      
    }else{
      if(threshold==100){
        topsum <- cumsum_sloc[length(cumsum_sloc)]
        cutoff <- length(cumsum_sloc)
      }else{
        topsum <- cumsum_sloc[length(cumsum_sloc)] * 0.01 * threshold  
        flag <- which(cumsum_sloc > topsum)
        cutoff <- flag[1] - 1  
      }
      
      
    }
    detail_result[1:cutoff,"predictLabel"] <- 1
    if(cutoff < nrow(detail_result)){
      detail_result[(cutoff+1):nrow(detail_result),"predictLabel"] <- 0  
    }
    
  } 
  
  idx <- which(cumsum_sloc>0)[1]
  cumsum_sloc_sub <- cumsum_sloc[idx:cutoff]
  cumsum_tp_sub <- cumsum_tp[idx:cutoff]
  
  mdd <- sum((cumsum_tp_sub / (cumsum_sloc_sub / 1000) ) )/ length(cumsum_tp_sub)  
  if(is.na(mdd)){
    mdd <- 0
  }
    
  
  tp <- sum(detail_result$predictLabel * (detail_result$actualBugLabel>=1))
  tn <- sum((detail_result$predictLabel + detail_result$actualBugLabel) == 0)
  fp <- sum((detail_result$predictLabel == 1) * (detail_result$actualBugLabel == 0))
  fn <- sum((detail_result$predictLabel == 0) * (detail_result$actualBugLabel >= 1))
  
  if((tp + tn + fp + fn) != nrow(detail_result)){
    cat('confusion matrix calculation error!!!!!\n')
    return(0)
  }
  tp <- as.numeric(tp)
  tn <- as.numeric(tn)
  fp <- as.numeric(fp)
  fn <- as.numeric(fn)
  
  if((tp+fn)!=0){
    recall <- tp / (tp + fn)  
  }else{
    recall <- 0
  }
  if((tp+fp)!=0){
    precision <- tp / (tp + fp)  
  }else{
    precision <- 0
  }
   
  
  pii <- cutoff / nrow(detail_result)
  
  if(cutoff==0){
    pci <- 0
  }else{
    pci <- cumsum_sloc[cutoff]/cumsum_sloc[nrow(detail_result)]
  }
  if((fp + tn)!=0){
    pf <- fp / (fp + tn)  
  }else{
    pf <- 0
  }
  
  if((precision + recall)!=0){
    f1 <- 2 * precision * recall / (precision + recall)  
  }else{
    f1 <- 0
  }
  if((recall + 1 - pf)!=0){
    g1 <-  (2 * recall * (1-pf)) / (recall + 1 - pf)
  }
  else{
    g1 <- 0
  }
  if(((tp + fp) * (tp + fn) * (tn + fp) * (tn + fn)) != 0){
    mcc <- (tp * tn - fp * fn) / sqrt((tp + fp) * (tp + fn) * (tn + fp) * (tn + fn))  
  }else{
    mcc <- 0
  }
  if(sum(detail_result$actualBugLabel)==0){
    ifa <- nrow(detail_result)
  }else{
    ifa <- which(detail_result$actualBugLabel>=1)[1] - 1
  }
  
  if(ifa==0){
    ifa_pii <- ifa_pci <- ifap <- ifap2 <- 0
  }else{
    ifa_pii <- ifa / nrow(detail_result)
    ifa_pci <- (sum(detail_result$sloc[1:ifa]) / sum(detail_result$sloc))
    
    ifap <- (ifa / nrow(detail_result)) * (sum(detail_result$sloc[1:ifa]) / sum(detail_result$sloc))
    ifap2 <- (ifa / nrow(detail_result)) * 0.5 + 0.5 * (sum(detail_result$sloc[1:ifa]) / sum(detail_result$sloc))
  } 
  ifap3 <- sqrt(ifap)
  if (threshold == -1){
    if(0.5*pci+0.5*pii>0){
      roi <- recall/(0.5*pci+0.5*pii)
      roi_tp <- tp/(0.5*pci+0.5*pii)
    }else{
      roi <- 0
      roi_tp <- 0
    }
    
    
  }else if (threshold < 1){
    if(pci==0){
      roi <- 0
      roi_tp <- 0 
    }else{
      roi <- recall/pci  
      roi_tp <- tp/pci
    }
  }else if(threshold >= 1){
    if(pii==0){
      roi <- 0 
      roi_tp <- 0
    }else{
      roi <- recall/pii
      roi_tp <- tp/pii
    }
  }
  if((pii + pci) == 0){
    roi2 <- 0
  }else{
    roi2 = recall/(0.5*pii + 0.5*pci)
  }
  if(pii*pci==0){
    roi3 <- 0
  }else{
    roi3 = recall/sqrt(pii * pci)
  }
  
  df_res <- data.frame()
  df_res['tp','value'] <- tp
  df_res['fp','value'] <- fp
  df_res['tn','value'] <- tn
  df_res['fn','value'] <- fn
  df_res['f1','value'] <- f1
  df_res['g1','value'] <- g1
  df_res['pf','value'] <- pf
  df_res['pci','value'] <- pci
  df_res['pii','value'] <- pii
  df_res['recall','value'] <- recall
  df_res['mcc','value'] <- mcc
  df_res['ifa','value'] <- ifa
  df_res['ifap','value'] <- ifap
  df_res['mdd','value'] <- mdd
  df_res['ifap2','value'] <- ifap2
  df_res['ifa_pii','value'] <- ifa_pii
  df_res['ifa_pci','value'] <- ifa_pci
  df_res['ifap3','value'] <- ifap3
  df_res['auc_roc','value'] <- auc_roc
  df_res['roi','value'] <- roi
  df_res['roi2','value'] <- roi2
  df_res['roi3','value'] <- roi3
  df_res['roi_tp','value'] <- roi_tp
  df_res['precision','value'] <- precision
  return(df_res)
}


summaryPerformance2 <- function(root_path,threshold,mode){
  cols <- c('community','source','target','tp','fp','tn','fn','f1','g1','pf','pci','pii','recall','mcc','ifa','ifap','mdd','ifap2','ifa_pii','ifa_pci','ifap3')
  
  files <- list.files(paste(root_path,sep=''))
  total_res <- data.frame(matrix(nrow = 0,ncol = length(cols)))
  colnames(total_res) <- cols
  
  for(file in files){
    cat(file,'\n')
    data <- read.csv(file=paste(root_path,file,sep = ''))
    perfs <- calculateIndicator(data,threshold = threshold)
    community <- strsplit(file,split = '-')[[1]][1]
    source <- strsplit(file,split = '_')[[1]][1]
    target <- strsplit(file,split = '_')[[1]][2]
    total_res[nrow(total_res)+1,] <- c(community,source,target,perfs)
  }
  if(mode=='SSC'){
    total_res$roi = as.numeric(total_res$recall)/ as.numeric(total_res$pii)  
    total_res[is.nan(total_res$roi),'roi'] <- 0
    
  }else if(mode=='SNM'){
    total_res$roi = as.numeric(total_res$recall)/ as.numeric(total_res$pci)  
    total_res[is.nan(total_res$roi),'roi'] <- 0
    
  }
  total_res$roi2 = as.numeric(total_res$recall)/ (0.5*as.numeric(total_res$pii) + 0.5*as.numeric(total_res$pci))
  total_res[is.nan(total_res$roi2),'roi2'] <- 0
  total_res$roi3 = as.numeric(total_res$recall)/ sqrt(as.numeric(total_res$pii) * as.numeric(total_res$pci))
  total_res[is.nan(total_res$roi3),'roi3'] <- 0
  
  return(total_res)
}

