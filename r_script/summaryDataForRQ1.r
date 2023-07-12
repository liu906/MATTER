modes = c('SSC','SNM')
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
getwd()

for (mode in modes){
  if (mode=='SSC'){
    threshold = 20
  }else if(mode=='SNM'){
    threshold = 0.2
  }
  DF_pci = read.csv(paste('result/alignment_pci_comparison_',as.character(threshold),'.csv',sep=''),row.names = 1,)
  DF_pii = read.csv(paste('result/alignment_pii_comparison_',as.character(threshold),'.csv',sep=''),row.names = 1)
  DF_recall = read.csv(paste('result/alignment_recall_comparison_',as.character(threshold),'.csv',sep=''),row.names = 1)
  DF_ifap = read.csv(paste('result/alignment_ifap_comparison_',as.character(threshold),'.csv',sep=''),row.names = 1)
  DF_mdd = read.csv(paste('result/alignment_mdd_comparison_',as.character(threshold),'.csv',sep=''),row.names = 1)
  DF_ifap2 = read.csv(paste('result/alignment_ifap2_comparison_',as.character(threshold),'.csv',sep=''),row.names = 1)
  DF_ifa = read.csv(paste('result/alignment_ifa_comparison_',as.character(threshold),'.csv',sep=''),row.names = 1)
  DF_ifa_pii = read.csv(paste('result/alignment_ifa_pii_comparison_',as.character(threshold),'.csv',sep=''),row.names = 1)
  DF_ifa_pci = read.csv(paste('result/alignment_ifa_pci_comparison_',as.character(threshold),'.csv',sep=''),row.names = 1)
  DF_ifap3 = read.csv(paste('result/alignment_ifap3_comparison_',as.character(threshold),'.csv',sep=''),row.names = 1)
  if (mode=='SSC'){
    DF_roi = DF_recall/DF_pii
    
  }else if(mode=='SNM'){
    DF_roi = DF_recall/DF_pci
    
  }
  DF_roi2 = DF_recall/(0.5*DF_pii + 0.5*DF_pci)
  DF_roi3 = DF_recall/sqrt(DF_pii * DF_pci)
  
  write.csv(DF_roi,paste('result/alignment_ROI_comparison_',as.character(threshold),'.csv',sep=''))
  write.csv(DF_roi2,paste('result/alignment_ROI2_comparison_',as.character(threshold),'.csv',sep=''))
  write.csv(DF_roi3,paste('result/alignment_ROI3_comparison_',as.character(threshold),'.csv',sep=''))
  
  baselines_rq1 <- c('Bellwether','EASC_E','EASC_NE ','SC','CLA','FCM','ManualDown','ManualUp')
  # baselines_rq1 <- c('Bellwether','EASC_E','EASC_NE ')
  colnames(DF_roi)
  
  DF_roi_subset = DF_roi[,c('Bellwether','EASC_E','EASC_NE','SC','CLA','FCM','ManualDown','ManualUp')]
  for(baseline in baselines_rq1){
    write.csv(DF_roi_subset,paste('result/rq1_roi_',as.character(threshold),'.csv',sep=''))
  } 
  DF_roi2_subset = DF_roi2[,c('Bellwether','EASC_E','EASC_NE','SC','CLA','FCM','ManualDown','ManualUp')]
  for(baseline in baselines_rq1){
    write.csv(DF_roi2_subset,paste('result/rq1_roi2_',as.character(threshold),'.csv',sep=''))
  }
  DF_roi3_subset = DF_roi3[,c('Bellwether','EASC_E','EASC_NE','SC','CLA','FCM','ManualDown','ManualUp')]
  for(baseline in baselines_rq1){
    write.csv(DF_roi3_subset,paste('result/rq1_roi3_',as.character(threshold),'.csv',sep=''))
  }
  
  DF_ifap_subset = DF_ifap[,c('Bellwether','EASC_E','EASC_NE','SC','CLA','FCM','ManualDown','ManualUp')]
  for(baseline in baselines_rq1){
    write.csv(DF_ifap_subset,paste('result/rq1_ifap_',as.character(threshold),'.csv',sep=''))
  }  
  DF_ifap2_subset = DF_ifap2[,c('Bellwether','EASC_E','EASC_NE','SC','CLA','FCM','ManualDown','ManualUp')]
  for(baseline in baselines_rq1){
    write.csv(DF_ifap2_subset,paste('result/rq1_ifap2_',as.character(threshold),'.csv',sep=''))
  }  
  DF_ifap3_subset = DF_ifap3[,c('Bellwether','EASC_E','EASC_NE','SC','CLA','FCM','ManualDown','ManualUp')]
  for(baseline in baselines_rq1){
    write.csv(DF_ifap3_subset,paste('result/rq1_ifap3_',as.character(threshold),'.csv',sep=''))
  }
  DF_ifa_subset = DF_ifa[,c('Bellwether','EASC_E','EASC_NE','SC','CLA','FCM','ManualDown','ManualUp')]
  for(baseline in baselines_rq1){
    write.csv(DF_ifa_subset,paste('result/rq1_ifa_',as.character(threshold),'.csv',sep=''))
  }
  
  DF_ifa_pii_subset = DF_ifa_pii[,c('Bellwether','EASC_E','EASC_NE','SC','CLA','FCM','ManualDown','ManualUp')]
  for(baseline in baselines_rq1){
    write.csv(DF_ifa_pii_subset,paste('result/rq1_ifa_pii_',as.character(threshold),'.csv',sep=''))
  }
  
  DF_ifa_pci_subset = DF_ifa_pci[,c('Bellwether','EASC_E','EASC_NE','SC','CLA','FCM','ManualDown','ManualUp')]
  for(baseline in baselines_rq1){
    write.csv(DF_ifa_pci_subset,paste('result/rq1_ifa_pci_',as.character(threshold),'.csv',sep=''))
  }
  
  DF_recall_subset = DF_recall[,c('Bellwether','EASC_E','EASC_NE','SC','CLA','FCM','ManualDown','ManualUp')]
  for(baseline in baselines_rq1){
    write.csv(DF_recall_subset,paste('result/rq1_recall_',as.character(threshold),'.csv',sep=''))
  } 
  DF_mdd_subset = DF_mdd[,c('Bellwether','EASC_E','EASC_NE','SC','CLA','FCM','ManualDown','ManualUp')]
  for(baseline in baselines_rq1){
    write.csv(DF_mdd_subset,paste('result/rq1_mdd_',as.character(threshold),'.csv',sep=''))
  }
  cat('done\n')
}
