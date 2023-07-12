setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
getwd()
source('../performance.r')
proba = 0.1
alpha = 0
path = '../baseline-result/Amasaki15-NB/MA-SZZ-2020/NB_flume-1.2.0.csv'
detail_result = read.csv(path) 
simulation_predict_label <- runif(nrow(detail_result)) > proba
detail_result$predictLabel <- simulation_predict_label
indicator_df <- calculateIndicator(detail_result,threshold = -1)
pci <- indicator_df['pci',]
pii <- indicator_df['pii',]
n <- indicator_df['tp',] + indicator_df['fn',]
# ci <- indicator_df['tp',] + indicator_df['fp',]
# ii <- indicator_df['pii',] * sum(detail_result$sloc)
  
ROI_prime <- tp / ( alpha * pci + (1-alpha) * pii + fc*n)
ROI <- tp / ( alpha * pci + (1-alpha) * pii )

