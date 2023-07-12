library(effsize)


rq1_run <- function(threshold,one_root_path,postfix,performance_indicator_list,adjust=TRUE){
  setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
  getwd()
  
  DF_pci = read.csv(paste('result/alignment_pci_comparison_',as.character(threshold),'.csv',sep=''),row.names = 1,)
  DF_pii = read.csv(paste('result/alignment_pii_comparison_',as.character(threshold),'.csv',sep=''),row.names = 1)
  DF_recall = read.csv(paste('result/alignment_recall_comparison_',as.character(threshold),'.csv',sep=''),row.names = 1)
  DF_ifap = read.csv(paste('result/alignment_ifap_comparison_',as.character(threshold),'.csv',sep=''),row.names = 1)
  DF_mdd = read.csv(paste('result/alignment_mdd_comparison_',as.character(threshold),'.csv',sep=''),row.names = 1)
  DF_ifap2 = read.csv(paste('result/alignment_ifap2_comparison_',as.character(threshold),'.csv',sep=''),row.names = 1)
  DF_ifap3 = read.csv(paste('result/alignment_ifap3_comparison_',as.character(threshold),'.csv',sep=''),row.names = 1)
  DF_ifa = read.csv(paste('result/alignment_ifa_comparison_',as.character(threshold),'.csv',sep=''),row.names = 1)
  DF_ifa_pii = read.csv(paste('result/alignment_ifa_pii_comparison_',as.character(threshold),'.csv',sep=''),row.names = 1)
  DF_ifa_pci = read.csv(paste('result/alignment_ifa_pci_comparison_',as.character(threshold),'.csv',sep=''),row.names = 1)
  DF_ifa_pci = read.csv(paste('result/alignment_ifa_pci_comparison_',as.character(threshold),'.csv',sep=''),row.names = 1)
  DF_auc_roc = read.csv(paste('result/alignment_auc_roc_comparison_',as.character(threshold),'.csv',sep=''),row.names = 1)
  DF_roi = read.csv(paste('result/alignment_roi_comparison_',as.character(threshold),'.csv',sep=''),row.names = 1)
  DF_roi2 = read.csv(paste('result/alignment_roi2_comparison_',as.character(threshold),'.csv',sep=''),row.names = 1)
  DF_roi3 = read.csv(paste('result/alignment_roi3_comparison_',as.character(threshold),'.csv',sep=''),row.names = 1)
  
  
  pvalue <- data.frame(matrix(nrow = ncol(DF_roi),ncol = length(performance_indicator_list)))
  colnames(pvalue) <- performance_indicator_list
  rownames(pvalue) <- colnames(DF_roi)
  
  effect <- data.frame(matrix(nrow = ncol(DF_roi),ncol = length(performance_indicator_list)))
  colnames(effect) <- performance_indicator_list
  rownames(effect) <- colnames(DF_roi)
  
  cohen <- data.frame(matrix(nrow = ncol(DF_roi),ncol = length(performance_indicator_list)))
  colnames(cohen) <- performance_indicator_list
  rownames(cohen) <- colnames(DF_roi)
  
  DF_roi[is.na(DF_roi)] <- 0
  DF_roi2[is.na(DF_roi2)] <- 0
  DF_roi3[is.na(DF_roi3)] <- 0
  DF_roi4[is.na(DF_roi4)] <- 0
  
  DF_recall[is.na(DF_recall)] <- 0
  DF_ifap[is.na(DF_ifap)] <- 0
  DF_ifap2[is.na(DF_ifap2)] <- 0
  DF_ifap3[is.na(DF_ifap3)] <- 0 
  
  DF_ifa[is.na(DF_ifa)] <- 0
  DF_ifa_pii[is.na(DF_ifa_pii)] <- 0
  DF_ifa_pci[is.na(DF_ifa_pci)] <- 0
  DF_mdd[is.na(DF_mdd)] <- 0
  
  data[is.na(data)] <- 0
  
  
  for (idx in 1:ncol(DF_roi)){
    if('ROI' %in% performance_indicator_list){
      roi_pvalue <- wilcox.test(data$roi,DF_roi[,colnames(DF_roi)[idx]],paired = TRUE)$p.value
      roi_cliff <- cliff.delta(data$roi,DF_roi[,colnames(DF_roi)[idx]])$estimate
      roi_cohen <- cohen.d(data$roi,DF_roi[,colnames(DF_roi)[idx]],paired = TRUE)$estimate
      
      pvalue[colnames(DF_roi)[idx],'ROI'] <- roi_pvalue
      effect[colnames(DF_roi)[idx],'ROI'] <- roi_cliff  
      cohen[colnames(DF_roi)[idx],'ROI'] <- roi_cohen 
    }
    if('ROI2' %in% performance_indicator_list){
      roi2_pvalue <- wilcox.test(data$roi2,DF_roi2[,colnames(DF_roi2)[idx]],paired = TRUE)$p.value
      roi2_cliff <- cliff.delta(data$roi2,DF_roi2[,colnames(DF_roi2)[idx]])$estimate
      roi2_cohen <- cohen.d(data$roi2,DF_roi2[,colnames(DF_roi2)[idx]],paired = TRUE)$estimate
      
      pvalue[colnames(DF_roi2)[idx],'ROI2'] <- roi2_pvalue
      effect[colnames(DF_roi2)[idx],'ROI2'] <- roi2_cliff
      cohen[colnames(DF_roi2)[idx],'ROI2'] <- roi2_cohen 
      
    }
    if('ROI3' %in% performance_indicator_list){
      roi3_pvalue <- wilcox.test(data$roi3,DF_roi3[,colnames(DF_roi3)[idx]],paired = TRUE)$p.value
      roi3_cliff <- cliff.delta(data$roi3,DF_roi3[,colnames(DF_roi3)[idx]])$estimate
      roi3_cohen <- cohen.d(data$roi3,DF_roi3[,colnames(DF_roi3)[idx]],paired = TRUE)$estimate
      pvalue[colnames(DF_roi3)[idx],'ROI3'] <- roi3_pvalue
      effect[colnames(DF_roi3)[idx],'ROI3'] <- roi3_cliff  
      cohen[colnames(DF_roi3)[idx],'ROI3'] <- roi3_cohen 
    }
    if('ROI4' %in% performance_indicator_list){
      roi4_pvalue <- wilcox.test(data$roi4,DF_roi4[,colnames(DF_roi4)[idx]],paired = TRUE)$p.value
      roi4_cliff <- cliff.delta(data$roi4,DF_roi4[,colnames(DF_roi4)[idx]])$estimate
      roi4_cohen <- cohen.d(data$roi4,DF_roi4[,colnames(DF_roi4)[idx]],paired = TRUE)$estimate
      
      pvalue[colnames(DF_roi4)[idx],'ROI4'] <- roi4_pvalue
      effect[colnames(DF_roi4)[idx],'ROI4'] <- roi4_cliff 
      cohen[colnames(DF_roi4)[idx],'ROI4'] <- roi4_cohen 
    }
    if('Recall' %in% performance_indicator_list){
      recall_pvalue <- wilcox.test(data$recall,DF_recall[,colnames(DF_recall)[idx]],paired = TRUE)$p.value
      recall_cliff <- cliff.delta(data$recall,DF_recall[,colnames(DF_recall)[idx]])$estimate
      recall_cohen <- cohen.d(data$recall,DF_recall[,colnames(DF_recall)[idx]],paired = TRUE)$estimate
      pvalue[colnames(DF_recall)[idx],'Recall'] <- recall_pvalue
      effect[colnames(DF_recall)[idx],'Recall'] <- recall_cliff
      cohen[colnames(DF_recall)[idx],'Recall'] <- recall_cohen
    }
    if('IFAP' %in% performance_indicator_list){
      ifap_pvalue <- wilcox.test(data$ifap,DF_ifap[,colnames(DF_ifap)[idx]],paired = TRUE)$p.value
      ifap_cliff <- cliff.delta(data$ifap,DF_ifap[,colnames(DF_ifap)[idx]])$estimate
      ifap_cohen <- cohen.d(data$ifap,DF_ifap[,colnames(DF_ifap)[idx]],paired = TRUE)$estimate
      pvalue[colnames(DF_ifap)[idx],'IFAP'] <- ifap_pvalue
      effect[colnames(DF_ifap)[idx],'IFAP'] <- ifap_cliff  
      cohen[colnames(DF_ifap)[idx],'IFAP'] <- ifap_cohen  
    }
    if('IFAP2' %in% performance_indicator_list){
      ifap2_pvalue <- wilcox.test(data$ifap2,DF_ifap2[,colnames(DF_ifap2)[idx]],paired = TRUE)$p.value
      ifap2_cliff <- cliff.delta(data$ifap2,DF_ifap2[,colnames(DF_ifap2)[idx]])$estimate
      ifap2_cohen <- cohen.d(data$ifap2,DF_ifap2[,colnames(DF_ifap2)[idx]],paired = TRUE)$estimate
      
      pvalue[colnames(DF_ifap2)[idx],'IFAP2'] <- ifap2_pvalue
      effect[colnames(DF_ifap2)[idx],'IFAP2'] <- ifap2_cliff  
      cohen[colnames(DF_ifap2)[idx],'IFAP2'] <- ifap2_cohen
      
    }
    if('IFAP3' %in% performance_indicator_list){
      ifap3_pvalue <- wilcox.test(data$ifap3,DF_ifap3[,colnames(DF_ifap3)[idx]],paired = TRUE)$p.value
      ifap3_cliff <- cliff.delta(data$ifap3,DF_ifap3[,colnames(DF_ifap3)[idx]])$estimate
      ifap3_cohen <- cohen.d(data$ifap3,DF_ifap3[,colnames(DF_ifap3)[idx]],paired = TRUE)$estimate
      
      pvalue[colnames(DF_ifap3)[idx],'IFAP3'] <- ifap3_pvalue
      effect[colnames(DF_ifap3)[idx],'IFAP3'] <- ifap3_cliff  
      cohen[colnames(DF_ifap3)[idx],'IFAP3'] <- ifap3_cohen
      
    }
    
    if('IFA' %in% performance_indicator_list){
      ifa_pvalue <- wilcox.test(data$ifa,DF_ifa[,colnames(DF_ifa)[idx]],paired = TRUE)$p.value
      ifa_cliff <- cliff.delta(data$ifa,DF_ifa[,colnames(DF_ifa)[idx]])$estimate
      ifa_cohen <- cohen.d(data$ifa,DF_ifa[,colnames(DF_ifa)[idx]],paired = TRUE)$estimate
      pvalue[colnames(DF_ifa)[idx],'IFA'] <- ifa_pvalue
      effect[colnames(DF_ifa)[idx],'IFA'] <- ifa_cliff  
      cohen[colnames(DF_ifa)[idx],'IFA'] <- ifa_cohen
    }
    if('IFA_PII' %in% performance_indicator_list){
      ifa_pii_pvalue <- wilcox.test(data$ifa_pii,DF_ifa_pii[,colnames(DF_ifa_pii)[idx]],paired = TRUE)$p.value
      ifa_pii_cliff <- cliff.delta(data$ifa_pii,DF_ifa_pii[,colnames(DF_ifa_pii)[idx]])$estimate
      ifa_pii_cohen <- cohen.d(data$ifa_pii,DF_ifa_pii[,colnames(DF_ifa_pii)[idx]],paired = TRUE)$estimate
      pvalue[colnames(DF_ifa_pii)[idx],'IFA_PII'] <- ifa_pii_pvalue
      effect[colnames(DF_ifa_pii)[idx],'IFA_PII'] <- ifa_pii_cliff
      cohen[colnames(DF_ifa_pii)[idx],'IFA_PII'] <- ifa_pii_cohen
    }
    if('IFA_PCI' %in% performance_indicator_list){
      ifa_pci_pvalue <- wilcox.test(data$ifa_pci,DF_ifa_pci[,colnames(DF_ifa_pci)[idx]],paired = TRUE)$p.value
      ifa_pci_cliff <- cliff.delta(data$ifa_pci,DF_ifa_pci[,colnames(DF_ifa_pci)[idx]])$estimate
      ifa_pci_cohen <- cohen.d(data$ifa_pci,DF_ifa_pci[,colnames(DF_ifa_pci)[idx]],paired = TRUE)$estimate
      pvalue[colnames(DF_ifa_pci)[idx],'IFA_PCI'] <- ifa_pci_pvalue
      effect[colnames(DF_ifa_pci)[idx],'IFA_PCI'] <- ifa_pci_cliff  
      cohen[colnames(DF_ifa_pci)[idx],'IFA_PCI'] <- ifa_pci_cohen  
    }
    if('MDD' %in% performance_indicator_list){
      mdd_pvalue <- wilcox.test(data$mdd,DF_mdd[,colnames(DF_mdd)[idx]],paired = TRUE)$p.value
      mdd_cliff <- cliff.delta(data$mdd,DF_mdd[,colnames(DF_mdd)[idx]])$estimate
      mdd_cohen <- cohen.d(data$mdd,DF_mdd[,colnames(DF_mdd)[idx]],paired = TRUE)$estimate
      
      pvalue[colnames(DF_mdd)[idx],'MDD'] <- mdd_pvalue
      effect[colnames(DF_mdd)[idx],'MDD'] <- mdd_cliff  
      cohen[colnames(DF_mdd)[idx],'MDD'] <- mdd_cohen
    }
    
  }
  pvalue <- pvalue[c('Bellwether','EASC_E','EASC_NE','SC','CLA','FCM','ManualDown','ManualUp'),]
  effect <- effect[c('Bellwether','EASC_E','EASC_NE','SC','CLA','FCM','ManualDown','ManualUp'),]
  cohen <- cohen[c('Bellwether','EASC_E','EASC_NE','SC','CLA','FCM','ManualDown','ManualUp'),]
  if(adjust){
    arr <- c()
    for(i in colnames(pvalue)){
      arr <- append(arr , pvalue[,i])
    }
    
    arr <- p.adjust(arr, method = "BH", n = length(arr))
    for(i in 1:ncol(pvalue)){
      pvalue[,colnames(pvalue)[i]] <- arr[((i - 1)*nrow(pvalue) + 1) : (i*nrow(pvalue))]
      arr <- append(arr , pvalue[,i])
    }
  }
  
  
  write.csv(pvalue,paste('./result/rq1_pvalue',as.character(threshold),postfix,'.csv',sep=''),row.names = TRUE)
  write.csv(effect,paste('./result/rq1_effect',as.character(threshold),postfix,'.csv',sep=''),row.names = TRUE)
  write.csv(cohen,paste('./result/rq1_cohen',as.character(threshold),postfix,'.csv',sep=''),row.names = TRUE)
}

 

rq2_run <- function(threshold,one_paths,postfix,performance_indicator_list){
  setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
  setwd("C:/Users/Cecilia/Documents/UCS2/UCS/r_script")
  if(threshold>1){
    mode <- 'SSC'
  }else{
    mode <- 'SNM'
  }
  DF_pci = read.csv(paste('result/alignment_pci_comparison_',as.character(threshold),'.csv',sep=''),row.names = 1,)
  DF_pii = read.csv(paste('result/alignment_pii_comparison_',as.character(threshold),'.csv',sep=''),row.names = 1)
  DF_recall = read.csv(paste('result/alignment_recall_comparison_',as.character(threshold),'.csv',sep=''),row.names = 1)
  DF_ifap = read.csv(paste('result/alignment_ifap_comparison_',as.character(threshold),'.csv',sep=''),row.names = 1)
  DF_ifap2 = read.csv(paste('result/alignment_ifap2_comparison_',as.character(threshold),'.csv',sep=''),row.names = 1)
  DF_ifap3 = read.csv(paste('result/alignment_ifap3_comparison_',as.character(threshold),'.csv',sep=''),row.names = 1)
  DF_ifa = read.csv(paste('result/alignment_ifa_comparison_',as.character(threshold),'.csv',sep=''),row.names = 1)
  DF_ifa_pii = read.csv(paste('result/alignment_ifa_pii_comparison_',as.character(threshold),'.csv',sep=''),row.names = 1)
  DF_ifa_pci = read.csv(paste('result/alignment_ifa_pci_comparison_',as.character(threshold),'.csv',sep=''),row.names = 1)
  DF_mdd = read.csv(paste('result/alignment_mdd_comparison_',as.character(threshold),'.csv',sep=''),row.names = 1)
  
  
  baselines <- c('CamargoCruz09.NB','Amasaki15.NB','Peters15.NB','top-core','MSMDA','KSETE')

  
    
  if (mode=='SSC'){
    DF_roi = DF_recall/DF_pii
   
    
  }else if(mode=='SNM'){
    DF_roi = DF_recall/DF_pci
  
  }
  DF_roi2 = DF_recall/(0.5*DF_pii + 0.5*DF_pci)
  DF_roi3 = DF_recall/sqrt(DF_pii *DF_pci)
  DF_roi4 = DF_recall/(DF_pii + DF_pci)

  
  pvalue <- data.frame(matrix(nrow = length(baselines),ncol = length(performance_indicator_list)))
  colnames(pvalue) <- performance_indicator_list
  rownames(pvalue) <- baselines
  
  effect <- data.frame(matrix(nrow = length(baselines),ncol = length(performance_indicator_list)))
  colnames(effect) <- performance_indicator_list
  rownames(effect) <- baselines
  
  cohen <- data.frame(matrix(nrow = length(baselines),ncol = length(performance_indicator_list)))
  colnames(cohen) <- performance_indicator_list
  rownames(cohen) <- baselines
  
  DF_roi[is.na(DF_roi)] <- 0
  DF_roi2[is.na(DF_roi2)] <- 0
  DF_roi3[is.na(DF_roi3)] <- 0
  DF_roi4[is.na(DF_roi4)] <- 0
  
  DF_recall[is.na(DF_recall)] <- 0
  DF_ifap[is.na(DF_ifap)] <- 0
  DF_ifap2[is.na(DF_ifap2)] <- 0
  DF_ifap3[is.na(DF_ifap3)] <- 0
  DF_ifa[is.na(DF_ifa)] <- 0
  DF_ifa_pii[is.na(DF_ifa_pii)] <- 0
  DF_ifa_pci[is.na(DF_ifa_pci)] <- 0
  
  DF_mdd[is.na(DF_mdd)] <- 0
  sub_baselines <- c('CamargoCruz09.NB','Amasaki15.NB','Peters15.NB')
  
  for (idx in 1:length(sub_baselines)){
    
    files <- list.files(paste(one_paths[idx],mode,'/',sep=''),pattern = '*.csv',full.names = TRUE)
    data <- read.csv(files[1])
    data$roi3 <- data$recall / sqrt(data$pci * data$pii)
    data$roi4 <- data$recall / (data$pci + data$pii)
    data[is.na(data)] <- 0
    
    if('ROI' %in% performance_indicator_list){
      roi_pvalue <- wilcox.test(data$roi,DF_roi[,colnames(DF_roi)[idx]],paired = TRUE)$p.value
      roi_cliff <- cliff.delta(data$roi,DF_roi[,colnames(DF_roi)[idx]])$estimate
      roi_cohen <- cohen.d(data$roi,DF_roi[,colnames(DF_roi)[idx]],paired = TRUE)$estimate
      pvalue[colnames(DF_roi)[idx],'ROI'] <- roi_pvalue
      effect[colnames(DF_roi)[idx],'ROI'] <- roi_cliff
      cohen[colnames(DF_roi)[idx],'ROI'] <- roi_cohen
    }
    if('ROI2' %in% performance_indicator_list){
      roi2_pvalue <- wilcox.test(data$roi2,DF_roi2[,colnames(DF_roi2)[idx]],paired = TRUE)$p.value
      roi2_cliff <- cliff.delta(data$roi2,DF_roi2[,colnames(DF_roi2)[idx]])$estimate
      roi2_cohen <- cohen.d(data$roi2,DF_roi2[,colnames(DF_roi2)[idx]],paired = TRUE)$estimate
      
      pvalue[colnames(DF_roi2)[idx],'ROI2'] <- roi2_pvalue
      effect[colnames(DF_roi2)[idx],'ROI2'] <- roi2_cliff
      cohen[colnames(DF_roi2)[idx],'ROI2'] <- roi2_cohen
    }
    if('ROI3' %in% performance_indicator_list){
      roi3_pvalue <- wilcox.test(data$roi3,DF_roi3[,colnames(DF_roi3)[idx]],paired = TRUE)$p.value
      roi3_cliff <- cliff.delta(data$roi3,DF_roi3[,colnames(DF_roi3)[idx]])$estimate
      roi3_cohen <- cohen.d(data$roi3,DF_roi3[,colnames(DF_roi3)[idx]],paired = TRUE)$estimate
      
      pvalue[colnames(DF_roi3)[idx],'ROI3'] <- roi3_pvalue
      effect[colnames(DF_roi3)[idx],'ROI3'] <- roi3_cliff
      cohen[colnames(DF_roi3)[idx],'ROI3'] <- roi3_cohen
      
    }
    if('ROI4' %in% performance_indicator_list){
      roi4_pvalue <- wilcox.test(data$roi4,DF_roi4[,colnames(DF_roi4)[idx]],paired = TRUE)$p.value
      roi4_cliff <- cliff.delta(data$roi4,DF_roi4[,colnames(DF_roi4)[idx]])$estimate
      roi4_cohen <- cohen.d(data$roi4,DF_roi4[,colnames(DF_roi4)[idx]],paired = TRUE)$estimate
      
      pvalue[colnames(DF_roi4)[idx],'ROI4'] <- roi4_pvalue
      effect[colnames(DF_roi4)[idx],'ROI4'] <- roi4_cliff
      cohen[colnames(DF_roi4)[idx],'ROI4'] <- roi4_cohen
    }
    if('Recall' %in% performance_indicator_list){
      recall_pvalue <- wilcox.test(data$recall,DF_recall[,colnames(DF_recall)[idx]],paired = TRUE)$p.value
      recall_cliff <- cliff.delta(data$recall,DF_recall[,colnames(DF_recall)[idx]])$estimate
      recall_cohen <- cohen.d(data$recall,DF_recall[,colnames(DF_recall)[idx]],paired = TRUE)$estimate
      pvalue[colnames(DF_recall)[idx],'Recall'] <- recall_pvalue
      effect[colnames(DF_recall)[idx],'Recall'] <- recall_cliff
      cohen[colnames(DF_recall)[idx],'Recall'] <- recall_cohen
      
    }
    if('IFAP' %in% performance_indicator_list){
      ifap_pvalue <- wilcox.test(data$ifap,DF_ifap[,colnames(DF_ifap)[idx]],paired = TRUE)$p.value
      ifap_cliff <- cliff.delta(data$ifap,DF_ifap[,colnames(DF_ifap)[idx]])$estimate
      ifap_cohen <- cohen.d(data$ifap,DF_ifap[,colnames(DF_ifap)[idx]],paired = TRUE)$estimate
      pvalue[colnames(DF_ifap)[idx],'IFAP'] <- ifap_pvalue
      effect[colnames(DF_ifap)[idx],'IFAP'] <- ifap_cliff
      cohen[colnames(DF_ifap)[idx],'IFAP'] <- ifap_cohen
    }
    if('IFAP2' %in% performance_indicator_list){
      ifap2_pvalue <- wilcox.test(data$ifap2,DF_ifap2[,colnames(DF_ifap2)[idx]],paired = TRUE)$p.value
      ifap2_cliff <- cliff.delta(data$ifap2,DF_ifap2[,colnames(DF_ifap2)[idx]])$estimate
      ifap2_cohen <- cohen.d(data$ifap2,DF_ifap2[,colnames(DF_ifap2)[idx]],paired = TRUE)$estimate
      pvalue[colnames(DF_ifap2)[idx],'IFAP2'] <- ifap2_pvalue
      effect[colnames(DF_ifap2)[idx],'IFAP2'] <- ifap2_cliff
      cohen[colnames(DF_ifap2)[idx],'IFAP2'] <- ifap2_cohen
    }
    if('IFAP3' %in% performance_indicator_list){
      ifap3_pvalue <- wilcox.test(data$ifap3,DF_ifap3[,colnames(DF_ifap3)[idx]],paired = TRUE)$p.value
      ifap3_cliff <- cliff.delta(data$ifap3,DF_ifap3[,colnames(DF_ifap3)[idx]])$estimate
      ifap3_cohen <- cohen.d(data$ifap3,DF_ifap3[,colnames(DF_ifap3)[idx]],paired = TRUE)$estimate
      pvalue[colnames(DF_ifap3)[idx],'IFAP3'] <- ifap3_pvalue
      effect[colnames(DF_ifap3)[idx],'IFAP3'] <- ifap3_cliff
      cohen[colnames(DF_ifap3)[idx],'IFAP3'] <- ifap3_cohen
    }
    if('IFA' %in% performance_indicator_list){
      ifa_pvalue <- wilcox.test(data$ifa,DF_ifa[,colnames(DF_ifa)[idx]],paired = TRUE)$p.value
      ifa_cliff <- cliff.delta(data$ifa,DF_ifa[,colnames(DF_ifa)[idx]])$estimate
      ifa_cohen <- cohen.d(data$ifa,DF_ifa[,colnames(DF_ifa)[idx]],paired = TRUE)$estimate
      pvalue[colnames(DF_ifa)[idx],'IFA'] <- ifa_pvalue
      effect[colnames(DF_ifa)[idx],'IFA'] <- ifa_cliff
      cohen[colnames(DF_ifa)[idx],'IFA'] <- ifa_cohen
    }
    if('IFA_PII' %in% performance_indicator_list){
      ifa_pii_pvalue <- wilcox.test(data$ifa_pii,DF_ifa_pii[,colnames(DF_ifa_pii)[idx]],paired = TRUE)$p.value
      ifa_pii_cliff <- cliff.delta(data$ifa_pii,DF_ifa_pii[,colnames(DF_ifa_pii)[idx]])$estimate
      ifa_pii_cohen <- cohen.d(data$ifa_pii,DF_ifa_pii[,colnames(DF_ifa_pii)[idx]],paired = TRUE)$estimate
      pvalue[colnames(DF_ifa_pii)[idx],'IFA_PII'] <- ifa_pii_pvalue
      effect[colnames(DF_ifa_pii)[idx],'IFA_PII'] <- ifa_pii_cliff
      cohen[colnames(DF_ifa_pii)[idx],'IFA_PII'] <- ifa_pii_cohen
    }
    if('IFA_PCI' %in% performance_indicator_list){
      ifa_pci_pvalue <- wilcox.test(data$ifa_pci,DF_ifa_pci[,colnames(DF_ifa_pci)[idx]],paired = TRUE)$p.value
      ifa_pci_cliff <- cliff.delta(data$ifa_pci,DF_ifa_pci[,colnames(DF_ifa_pci)[idx]])$estimate
      ifa_pci_cohen <- cohen.d(data$ifa_pci,DF_ifa_pci[,colnames(DF_ifa_pci)[idx]],paired = TRUE)$estimate
      
      pvalue[colnames(DF_ifa_pci)[idx],'IFA_PCI'] <- ifa_pci_pvalue
      effect[colnames(DF_ifa_pci)[idx],'IFA_PCI'] <- ifa_pci_cliff
      cohen[colnames(DF_ifa_pci)[idx],'IFA_PCI'] <- ifa_pci_cohen
    }
    if('MDD' %in% performance_indicator_list){
      mdd_pvalue <- wilcox.test(data$mdd,DF_mdd[,colnames(DF_mdd)[idx]],paired = TRUE)$p.value
      mdd_cliff <- cliff.delta(data$mdd,DF_mdd[,colnames(DF_mdd)[idx]])$estimate
      mdd_cohen <- cohen.d(data$mdd,DF_mdd[,colnames(DF_mdd)[idx]],paired = TRUE)$estimate
      
      pvalue[colnames(DF_mdd)[idx],'MDD'] <- mdd_pvalue
      effect[colnames(DF_mdd)[idx],'MDD'] <- mdd_cliff
      cohen[colnames(DF_mdd)[idx],'MDD'] <- mdd_cohen
    }
  }

  other_baselines <- c('top-core','MSMDA','KSETE')
  other_baselines_paths <- c('C:/Users/Cecilia/Documents/Kcore/','C:/Users/Cecilia/Documents/MSMDA_v1/','C:/Users/Cecilia/Documents/KSETE-master-master/')

  for (idx in 1:length(other_baselines)){
    
    files <- list.files(paste(one_paths[idx+length(sub_baselines)],mode,'/',sep=''),pattern = '*.csv',full.names = TRUE)
    data <- read.csv(files[1])
    # data$roi3 <- data$recall / sqrt(data$pci * data$pii)
    
    model_data <- read.csv(paste(other_baselines_paths[idx],'total_result_',as.character(threshold),'.csv',sep=''))
    if (mode=='SSC'){
      model_data$roi = model_data$recall/model_data$pii
      data$roi = data$recall/data$pii
      
    }else if(mode=='SNM'){
      model_data$roi = model_data$recall/model_data$pci
      data$roi = data$recall/data$pci
    }
    model_data$roi2 = model_data$recall/(0.5*model_data$pii + 0.5*model_data$pci)
    model_data$roi3 = model_data$recall/sqrt(model_data$pii * model_data$pci)
    model_data$roi4 = model_data$recall/(model_data$pii + model_data$pci)
    data$roi2 = data$recall/(0.5*data$pii + 0.5*data$pci)
    data$roi3 = data$recall/sqrt(data$pii * data$pci)
    data$roi4 = data$recall/(data$pii + data$pci)
    data[is.na(data)] <- 0
    model_data[is.na(model_data)] <- 0
    if('ROI' %in% performance_indicator_list){
      roi_pvalue <- wilcox.test(data$roi,model_data$roi,paired = TRUE)$p.value
      roi_cliff <- cliff.delta(data$roi,model_data$roi)$estimate
      roi_cohen <- cohen.d(data$roi,model_data$roi,paired = TRUE)$estimate
      pvalue[other_baselines[idx],'ROI'] <- roi_pvalue
      effect[other_baselines[idx],'ROI'] <- roi_cliff  
      cohen[other_baselines[idx],'ROI'] <- roi_cohen
      
    }
    if('ROI2' %in% performance_indicator_list){
      roi2_pvalue <- wilcox.test(data$roi2,model_data$roi2,paired = TRUE)$p.value
      roi2_cliff <- cliff.delta(data$roi2,model_data$roi2)$estimate
      roi2_cohen <- cohen.d(data$roi2,model_data$roi2,paired = TRUE)$estimate
      pvalue[other_baselines[idx],'ROI2'] <- roi2_pvalue
      effect[other_baselines[idx],'ROI2'] <- roi2_cliff  
      cohen[other_baselines[idx],'ROI2'] <- roi2_cohen  
    }
    if('ROI3' %in% performance_indicator_list){
      roi3_pvalue <- wilcox.test(data$roi3,model_data$roi3,paired = TRUE)$p.value
      roi3_cliff <- cliff.delta(data$roi3,model_data$roi3)$estimate
      roi3_cohen <- cohen.d(data$roi3,model_data$roi3,paired = TRUE)$estimate
      pvalue[other_baselines[idx],'ROI3'] <- roi3_pvalue
      effect[other_baselines[idx],'ROI3'] <- roi3_cliff  
      cohen[other_baselines[idx],'ROI3'] <- roi3_cohen
    }
    if('ROI4' %in% performance_indicator_list){
      roi4_pvalue <- wilcox.test(data$roi4,model_data$roi4,paired = TRUE)$p.value
      roi4_cliff <- cliff.delta(data$roi4,model_data$roi4)$estimate
      roi4_cohen <- cohen.d(data$roi4,model_data$roi4,paired = TRUE)$estimate
      pvalue[other_baselines[idx],'ROI4'] <- roi4_pvalue
      effect[other_baselines[idx],'ROI4'] <- roi4_cliff  
      cohen[other_baselines[idx],'ROI4'] <- roi4_cohen
    }
    if('Recall' %in% performance_indicator_list){
      recall_pvalue <- wilcox.test(data$recall,model_data$recall,paired = TRUE)$p.value
      recall_cliff <- cliff.delta(data$recall,model_data$recall)$estimate
      recall_cohen <- cohen.d(data$recall,model_data$recall,paired = TRUE)$estimate
      
      pvalue[other_baselines[idx],'Recall'] <- recall_pvalue
      effect[other_baselines[idx],'Recall'] <- recall_cliff  
      cohen[other_baselines[idx],'Recall'] <- recall_cohen
      
    }
    if('IFAP' %in% performance_indicator_list){
      ifap_pvalue <- wilcox.test(data$ifap,model_data$ifap,paired = TRUE)$p.value
      ifap_cliff <- cliff.delta(data$ifap,model_data$ifap)$estimate
      ifap_cohen <- cohen.d(data$ifap,model_data$ifap,paired = TRUE)$estimate
      
      pvalue[other_baselines[idx],'IFAP'] <- ifap_pvalue
      effect[other_baselines[idx],'IFAP'] <- ifap_cliff  
      cohen[other_baselines[idx],'IFAP'] <- ifap_cohen  
    }
    if('IFAP2' %in% performance_indicator_list){
      ifap2_pvalue <- wilcox.test(data$ifap2,model_data$ifap2,paired = TRUE)$p.value
      ifap2_cliff <- cliff.delta(data$ifap2,model_data$ifap2)$estimate
      ifap2_cohen <- cohen.d(data$ifap2,model_data$ifap2,paired = TRUE)$estimate
      pvalue[other_baselines[idx],'IFAP2'] <- ifap2_pvalue
      effect[other_baselines[idx],'IFAP2'] <- ifap2_cliff  
      cohen[other_baselines[idx],'IFAP2'] <- ifap2_cohen 
    }
    if('IFAP3' %in% performance_indicator_list){
      ifap3_pvalue <- wilcox.test(data$ifap3,model_data$ifap3,paired = TRUE)$p.value
      ifap3_cliff <- cliff.delta(data$ifap3,model_data$ifap3)$estimate
      ifap3_cohen <- cohen.d(data$ifap3,model_data$ifap3,paired = TRUE)$estimate
      pvalue[other_baselines[idx],'IFAP3'] <- ifap3_pvalue
      effect[other_baselines[idx],'IFAP3'] <- ifap3_cliff  
      cohen[other_baselines[idx],'IFAP3'] <- ifap3_cohen 
    }
    if('IFA' %in% performance_indicator_list){
      ifa_pvalue <- wilcox.test(data$ifa,model_data$ifa,paired = TRUE)$p.value
      ifa_cliff <- cliff.delta(data$ifa,model_data$ifa)$estimate
      ifa_cohen <- cohen.d(data$ifa,model_data$ifa,paired = TRUE)$estimate
      pvalue[other_baselines[idx],'IFA'] <- ifa_pvalue
      effect[other_baselines[idx],'IFA'] <- ifa_cliff  
      cohen[other_baselines[idx],'IFA'] <- ifa_cohen 
    }
    if('IFA_PII' %in% performance_indicator_list){
      ifa_pii_pvalue <- wilcox.test(data$ifa_pii,model_data$ifa_pii,paired = TRUE)$p.value
      ifa_pii_cliff <- cliff.delta(data$ifa_pii,model_data$ifa_pii)$estimate
      ifa_pii_cohen <- cohen.d(data$ifa_pii,model_data$ifa_pii,paired = TRUE)$estimate
      pvalue[other_baselines[idx],'IFA_PII'] <- ifa_pii_pvalue
      effect[other_baselines[idx],'IFA_PII'] <- ifa_pii_cliff  
      cohen[other_baselines[idx],'IFA_PII'] <- ifa_pii_cohen
    }
    if('IFA_PCI' %in% performance_indicator_list){
      ifa_pci_pvalue <- wilcox.test(data$ifa_pci,model_data$ifa_pci,paired = TRUE)$p.value
      ifa_pci_cliff <- cliff.delta(data$ifa_pci,model_data$ifa_pci)$estimate
      ifa_pci_cohen <- cliff.delta(data$ifa_pci,model_data$ifa_pci,paired = TRUE)$estimate
      
      pvalue[other_baselines[idx],'IFA_PCI'] <- ifa_pci_pvalue
      effect[other_baselines[idx],'IFA_PCI'] <- ifa_pci_cliff  
      cohen[other_baselines[idx],'IFA_PCI'] <- ifa_pci_cohen
    }
    if('MDD' %in% performance_indicator_list){
      mdd_pvalue <- wilcox.test(data$mdd,model_data$mdd,paired = TRUE)$p.value
      mdd_cliff <- cliff.delta(data$mdd,model_data$mdd)$estimate
      mdd_cohen <- cohen.d(data$mdd,model_data$mdd,paired = TRUE)$estimate
      
      pvalue[other_baselines[idx],'MDD'] <- mdd_pvalue
      effect[other_baselines[idx],'MDD'] <- mdd_cliff  
      cohen[other_baselines[idx],'MDD'] <- mdd_cohen
    }
    
  }
  # arr <- c()
  # for(i in colnames(pvalue)){
  #   arr <- append(arr , pvalue[,i])
  # }
  # 
  # arr <- p.adjust(arr, method = "BH", n = length(arr))
  # for(i in 1:ncol(pvalue)){
  #   pvalue[,colnames(pvalue)[i]] <- arr[((i - 1)*nrow(pvalue) + 1) : (i*nrow(pvalue))]
  # 
  #   arr <- append(arr , pvalue[,i])
  # }

  write.csv(pvalue,paste('./result/rq2_pvalue',as.character(threshold),postfix,'.csv',sep=''),row.names = TRUE)
  write.csv(effect,paste('./result/rq2_effect',as.character(threshold),postfix,'.csv',sep=''),row.names = TRUE)
  write.csv(cohen,paste('./result/rq2_cohen',as.character(threshold),postfix,'.csv',sep=''),row.names = TRUE)
}

getwd()
# performance_indicator_list <- c('Recall','ROI','IFAP')
# performance_indicator_list <- c('Recall','ROI','IFAP','IFA','IFAP2','ROI2','ROI3','ROI4','IFA_PII','IFA_PCI')
performance_indicator_list <- c('Recall','ROI','IFAP2')
# rq1_run(20,one_root_path = '../detail_result/One',postfix='',performance_indicator_list)
# rq1_run(0.2,one_root_path = '../detail_result/One',postfix='',performance_indicator_list)
rq1_run(threshold =  20,one_root_path = '../detail_result/One2',postfix='_one2',performance_indicator_list)
rq1_run(threshold = 0.2,one_root_path = '../detail_result/One2',postfix='_one2',performance_indicator_list)

# rq1_run(20,one_root_path = '../detail_result/One2_E30',postfix='_one2_E30',performance_indicator_list)
# rq1_run(0.2,one_root_path = '../detail_result/One2_E30',postfix='_one2_E30',performance_indicator_list)

# one_paths <- c('../detail_result/One/ALLJURECZKO/',
#                '../detail_result/One/ALLJURECZKO/',
#                '../detail_result/One/ALLJURECZKO/',
#                '../detail_result/One/teraPROMISE/',
#                '../detail_result/One/MSMDA/',
#                '../detail_result/One/KSETE/')
# rq2_run(20,one_paths,postfix='',performance_indicator_list)
# rq2_run(0.2,one_paths,postfix='',performance_indicator_list)

one_paths <- c('../detail_result/One2/ALLJURECZKO/',
               '../detail_result/One2/ALLJURECZKO/',
               '../detail_result/One2/ALLJURECZKO/',
               '../detail_result/One2/teraPROMISE/',
               '../detail_result/One2/MSMDA/',
               '../detail_result/One2/KSETE/')
rq2_run(threshold=20,one_paths,postfix='_one2',performance_indicator_list)
rq2_run(0.2,one_paths,postfix='_one2',performance_indicator_list)

# one_paths <- c('../detail_result/One2_E30/ALLJURECZKO/',
#                '../detail_result/One2_E30/ALLJURECZKO/',
#                '../detail_result/One2_E30/ALLJURECZKO/',
#                '../detail_result/One2_E30/teraPROMISE/',
#                '../detail_result/One2_E30/MSMDA/',
#                '../detail_result/One2_E30/KSETE/')
# rq2_run(threshold=20,one_paths,postfix='_one2_E30',performance_indicator_list)
# rq2_run(0.2,one_paths,postfix='_one2_E30',performance_indicator_list)

