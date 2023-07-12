setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
getwd()
source("../performance.r")
source('../config.r')

run <- function(baselines,
                baseline_paths,
                threshold,
                profix,
                res_path,
                datasets = c('AEEEM',
                             'ALLJURECZKO',
                             'IND-JLMIV+R-1Y_change59',
                             'MA-SZZ-2020',
                             'RELINK')) {
  cat(datasets)
  setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
  getwd()
  setwd('../')
  # setwd('../CrossPare/')
  DF_tp <- data.frame()
  DF_fp <- data.frame()
  DF_pci <- data.frame()
  DF_pii <- data.frame()
  DF_f1 <- data.frame()
  DF_g1 <- data.frame()
  DF_pf <- data.frame()
  DF_recall <- data.frame()
  DF_mcc <- data.frame()
  DF_ifa <- data.frame()
  DF_ifap <- data.frame()
  DF_mdd <- data.frame()
  DF_ifap2 <- data.frame()
  DF_ifa_pii <- data.frame()
  DF_ifa_pci <- data.frame()
  DF_ifap3 <- data.frame()
  DF_auc_roc <- data.frame()
  DF_roi <- data.frame()
  DF_roi2 <- data.frame()
  DF_roi3 <- data.frame()
  DF_roi_tp <- data.frame()
  DF_precision <- data.frame()
  DF_ce <- data.frame()
  
  for (i in 1:length(baselines)) {
    cat(baselines[i])
    cat('\n')
    if (length(datasets)==1 && datasets== 0) {
      arr_dataset = 0
      files <-
        list.files(file.path('r_script/', baseline_paths[i]), full.names = TRUE)
      
    }else{
    
      dirs <- list.dirs(baseline_paths[i])
      files <- c()
      arr_dataset <- c()
      for (j in 2:length(dirs)) {
        if (basename(dirs[j]) %in% datasets) {
          files <- append(files, list.files(dirs[j], full.names = TRUE))
          arr_dataset <-
            append(arr_dataset, rep(basename(dirs[j]), length(
              list.files(dirs[j], full.names = TRUE)
            )))
        }
      }
    }
    
    
    arr_tp <- c()
    arr_fp <- c()
    arr_f1 <- c()
    arr_g1 <- c()
    arr_pii <- c()
    arr_pf <- c()
    arr_pci <- c()
    arr_recall <- c()
    arr_mcc <- c()
    arr_ifa <- c()
    arr_ifap <- c()
    arr_mdd <- c()
    arr_ifap2 <- c()
    arr_ifa_pci <- c()
    arr_ifa_pii <- c()
    arr_ifap3 <- c()
    arr_auc_roc <- c()
    arr_roi <- c()
    arr_roi2 <- c()
    arr_roi3 <- c()
    arr_roi_tp <- c()
    arr_precision <- c()
    arr_ce <- c()
    
    for (file in files) {
      detail_result <- read.csv(file)
      
      df_res <-
        calculateIndicator(detail_result = detail_result, threshold = threshold)
      
      tp <- df_res['tp', 'value']
      fp <- df_res['fp', 'value']
      fp <- df_res['fp', 'value']
      tn <- df_res['tn', 'value']
      fn <- df_res['fn', 'value']
      f1 <- df_res['f1', 'value']
      g1 <- df_res['g1', 'value']
      pf <- df_res['pf', 'value']
      pci <- df_res['pci', 'value']
      pii <- df_res['pii', 'value']
      recall <- df_res['recall', 'value']
      mcc <- df_res['mcc', 'value']
      ifa <- df_res['ifa', 'value']
      ifap <- df_res['ifap', 'value']
      mdd <- df_res['mdd', 'value']
      ifap2 <- df_res['ifap2', 'value']
      ifa_pii <- df_res['ifa_pii', 'value']
      ifa_pci <- df_res['ifa_pci', 'value']
      ifap3 <- df_res['ifap3', 'value']
      auc_roc <- df_res['auc_roc', 'value']
      roi <- df_res['roi', 'value']
      roi2 <- df_res['roi2', 'value']
      roi3 <- df_res['roi3', 'value']
      roi_tp <- df_res['roi_tp', 'value']
      precision <- df_res['precision', 'value']
      ce <- df_res['ce', 'value']
      
      arr_tp <- append(arr_tp, tp)
      arr_fp <- append(arr_fp, fp)
      arr_f1 <- append(arr_f1, f1)
      arr_g1 <- append(arr_g1, g1)
      arr_pf <- append(arr_pf, pf)
      arr_pci <- append(arr_pci, pci)
      arr_pii <- append(arr_pii, pii)
      arr_recall <- append(arr_recall, recall)
      arr_mcc <- append(arr_mcc, mcc)
      arr_ifa <- append(arr_ifa, ifa)
      arr_ifap <- append(arr_ifap, ifap)
      arr_mdd <- append(arr_mdd, mdd)
      arr_ifap2 <- append(arr_ifap2, ifap2)
      arr_ifa_pii <- append(arr_ifa_pii, ifa_pii)
      arr_ifa_pci <- append(arr_ifa_pci, ifa_pci)
      arr_ifap3 <- append(arr_ifap3, ifap3)
      arr_auc_roc <- append(arr_auc_roc, auc_roc)
      arr_roi <- append(arr_roi, roi)
      arr_roi2 <- append(arr_roi2, roi2)
      arr_roi3 <- append(arr_roi3, roi3)
      arr_roi_tp <- append(arr_roi_tp, roi_tp)
      arr_precision <- append(arr_precision, precision)
      arr_ce <- append(arr_ce, ce)
    }
    
    if (nrow(DF_pci) == 0) {
      DF_tp[basename(files), 'dataset'] <- arr_dataset
      DF_fp[basename(files), 'dataset'] <- arr_dataset
      DF_pci[basename(files), 'dataset'] <- arr_dataset
      DF_pii[basename(files), 'dataset'] <- arr_dataset
      DF_f1[basename(files), 'dataset'] <- arr_dataset
      DF_g1[basename(files), 'dataset'] <- arr_dataset
      DF_pf[basename(files), 'dataset'] <- arr_dataset
      DF_recall[basename(files), 'dataset'] <- arr_dataset
      DF_mcc[basename(files), 'dataset'] <- arr_dataset
      DF_ifa[basename(files), 'dataset'] <- arr_dataset
      DF_ifap[basename(files), 'dataset'] <- arr_dataset
      DF_mdd[basename(files), 'dataset'] <- arr_dataset
      DF_ifap2[basename(files), 'dataset'] <- arr_dataset
      DF_ifa_pii[basename(files), 'dataset'] <- arr_dataset
      DF_ifa_pci[basename(files), 'dataset'] <- arr_dataset
      DF_ifap3[basename(files), 'dataset'] <- arr_dataset
      DF_auc_roc[basename(files), 'dataset'] <- arr_dataset
      DF_roi[basename(files), 'dataset'] <- arr_dataset
      DF_roi2[basename(files), 'dataset'] <- arr_dataset
      DF_roi3[basename(files), 'dataset'] <- arr_dataset
      DF_roi_tp[basename(files), 'dataset'] <- arr_dataset
      DF_precision[basename(files), 'dataset'] <- arr_dataset
      DF_ce[basename(files), 'dataset'] <- arr_dataset
      
      DF_tp[basename(files), baselines[i]] <- arr_tp
      DF_fp[basename(files), baselines[i]] <- arr_fp
      DF_pci[basename(files), baselines[i]] <- arr_pci
      DF_pii[basename(files), baselines[i]] <- arr_pii
      DF_f1[basename(files), baselines[i]] <- arr_f1
      DF_g1[basename(files), baselines[i]] <- arr_g1
      DF_pf[basename(files), baselines[i]] <- arr_pf
      DF_recall[basename(files), baselines[i]] <- arr_recall
      DF_mcc[basename(files), baselines[i]] <- arr_mcc
      DF_ifa[basename(files), baselines[i]] <- arr_ifa
      DF_ifap[basename(files), baselines[i]] <- arr_ifap
      DF_mdd[basename(files), baselines[i]] <- arr_mdd
      DF_ifap2[basename(files), baselines[i]] <- arr_ifap2
      DF_ifa_pii[basename(files), baselines[i]] <- arr_ifa_pii
      DF_ifa_pci[basename(files), baselines[i]] <- arr_ifa_pci
      DF_ifap3[basename(files), baselines[i]] <- arr_ifap3
      DF_auc_roc[basename(files), baselines[i]] <- arr_auc_roc
      DF_roi[basename(files), baselines[i]] <- arr_roi
      DF_roi2[basename(files), baselines[i]] <- arr_roi2
      DF_roi3[basename(files), baselines[i]] <- arr_roi3
      DF_roi_tp[basename(files), baselines[i]] <- arr_roi_tp
      DF_precision[basename(files), baselines[i]] <- arr_precision
      DF_ce[basename(files), baselines[i]] <- arr_ce
      
    } else{
      DF_tp[, baselines[i]] <- arr_tp
      DF_fp[, baselines[i]] <- arr_fp
      DF_pci[, baselines[i]] <- arr_pci
      DF_pii[, baselines[i]] <- arr_pii
      DF_f1[, baselines[i]] <- arr_f1
      DF_g1[, baselines[i]] <- arr_g1
      DF_pf[, baselines[i]] <- arr_pf
      DF_recall[, baselines[i]] <- arr_recall
      DF_mcc[, baselines[i]] <- arr_mcc
      DF_ifa[, baselines[i]] <- arr_ifa
      DF_ifap[, baselines[i]] <- arr_ifap
      DF_mdd[, baselines[i]] <- arr_mdd
      DF_ifap2[, baselines[i]] <- arr_ifap2
      DF_ifa_pii[, baselines[i]] <- arr_ifa_pii
      DF_ifa_pci[, baselines[i]] <- arr_ifa_pci
      DF_ifap3[, baselines[i]] <- arr_ifap3
      DF_auc_roc[, baselines[i]] <- arr_auc_roc
      DF_roi[, baselines[i]] <- arr_roi
      DF_roi2[, baselines[i]] <- arr_roi2
      DF_roi3[, baselines[i]] <- arr_roi3
      DF_roi_tp[, baselines[i]] <- arr_roi_tp
      DF_precision[, baselines[i]] <- arr_precision
      DF_ce[, baselines[i]] <- arr_ce
    }
  }
  
  setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
  getwd()
  
  write.csv(DF_tp, file = file.path(
    res_path,
    paste(
      profix,
      '_tp_comparison_',
      as.character(threshold),
      '.csv',
      sep = ''
    )
  ))
  write.csv(DF_fp, file = file.path(
    res_path,
    paste(
      profix,
      '_fp_comparison_',
      as.character(threshold),
      '.csv',
      sep = ''
    )
  ))
  write.csv(DF_pci, file = file.path(
    res_path,
    paste(
      profix,
      '_pci_comparison_',
      as.character(threshold),
      '.csv',
      sep = ''
    )
  ))
  write.csv(DF_pii, file = file.path(
    res_path,
    paste(
      profix,
      '_pii_comparison_',
      as.character(threshold),
      '.csv',
      sep = ''
    )
  ))
  write.csv(DF_f1, file = file.path(
    res_path,
    paste(
      profix,
      '_f1_comparison_',
      as.character(threshold),
      '.csv',
      sep = ''
    )
  ))
  write.csv(DF_g1, file = file.path(
    res_path,
    paste(
      profix,
      '_g1_comparison_',
      as.character(threshold),
      '.csv',
      sep = ''
    )
  ))
  write.csv(DF_pf, file = file.path(
    res_path,
    paste(
      profix,
      '_pf_comparison_',
      as.character(threshold),
      '.csv',
      sep = ''
    )
  ))
  write.csv(DF_recall, file = file.path(
    res_path,
    paste(
      profix,
      '_recall_comparison_',
      as.character(threshold),
      '.csv',
      sep = ''
    )
  ))
  write.csv(DF_mcc, file = file.path(
    res_path,
    paste(
      profix,
      '_mcc_comparison_',
      as.character(threshold),
      '.csv',
      sep = ''
    )
  ))
  write.csv(DF_ifa, file = file.path(
    res_path,
    paste(
      profix,
      '_ifa_comparison_',
      as.character(threshold),
      '.csv',
      sep = ''
    )
  ))
  write.csv(DF_ifap, file = file.path(
    res_path,
    paste(
      profix,
      '_ifap_comparison_',
      as.character(threshold),
      '.csv',
      sep = ''
    )
  ))
  write.csv(DF_mdd, file = file.path(
    res_path,
    paste(
      profix,
      '_mdd_comparison_',
      as.character(threshold),
      '.csv',
      sep = ''
    )
  ))
  write.csv(DF_ifap2, file = file.path(
    res_path,
    paste(
      profix,
      '_ifap2_comparison_',
      as.character(threshold),
      '.csv',
      sep = ''
    )
  ))
  write.csv(DF_ifa_pii, file = file.path(
    res_path,
    paste(
      profix,
      '_ifa_pii_comparison_',
      as.character(threshold),
      '.csv',
      sep = ''
    )
  ))
  write.csv(DF_ifa_pci, file = file.path(
    res_path,
    paste(
      profix,
      '_ifa_pci_comparison_',
      as.character(threshold),
      '.csv',
      sep = ''
    )
  ))
  write.csv(DF_ifap3, file = file.path(
    res_path,
    paste(
      profix,
      '_ifap3_comparison_',
      as.character(threshold),
      '.csv',
      sep = ''
    )
  ))
  write.csv(DF_auc_roc, file = file.path(
    res_path,
    paste(
      profix,
      '_auc_roc_comparison_',
      as.character(threshold),
      '.csv',
      sep = ''
    )
  ))
  write.csv(DF_roi, file = file.path(
    res_path,
    paste(
      profix,
      '_roi_comparison_',
      as.character(threshold),
      '.csv',
      sep = ''
    )
  ))
  write.csv(DF_roi2, file = file.path(
    res_path,
    paste(
      profix,
      '_roi2_comparison_',
      as.character(threshold),
      '.csv',
      sep = ''
    )
  ))
  write.csv(DF_roi3, file = file.path(
    res_path,
    paste(
      profix,
      '_roi3_comparison_',
      as.character(threshold),
      '.csv',
      sep = ''
    )
  ))
  write.csv(DF_roi_tp, file = file.path(
    res_path,
    paste(
      profix,
      '_roi_tp_comparison_',
      as.character(threshold),
      '.csv',
      sep = ''
    )
  ))
  write.csv(DF_precision, file = file.path(
    res_path,
    paste(
      profix,
      '_precision_comparison_',
      as.character(threshold),
      '.csv',
      sep = ''
    )
  ))
  write.csv(DF_ce, file = file.path(
    res_path,
    paste(
      profix,
      '_ce_comparison_',
      as.character(threshold),
      '.csv',
      sep = ''
    )
  ))
}

