setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
getwd()
source("../performance.r")
source('../config.r')
source('./run.r')

df_baselines = baselines
df_models = models


df_baselines['ONE','res_root'] <- 'One-result/cutoff0.2_exclude20'
run(baselines = row.names(df_baselines),
    baseline_paths = df_baselines$res_root,threshold = -1,
    profix = 'baseline',res_path = file.path('result','rq1'))


df_models['ONE','res_root'] <- 'One-result/cutoff0.2_exclude20'
run(baselines = row.names(df_models),
    baseline_paths = df_models$res_root,threshold = -1,
    profix = 'stateOfArt',res_path = file.path('result','rq2'))




df_baselines['ONE','res_root'] <- 'One-result/cutoff20_exclude20'

run(baselines = row.names(df_baselines),
    baseline_paths = df_baselines$res_root,threshold = 20,
    profix = 'baseline',res_path = file.path('result','rq1'))

df_baselines['ONE','res_root'] <- 'One-result/cutoff0.2_exclude20'
run(baselines = row.names(df_baselines),
    baseline_paths = df_baselines$res_root,threshold = 0.2,
    profix = 'baseline',res_path = file.path('result','rq1'))



df_models['ONE','res_root'] <- 'One-result/cutoff20_exclude20'
run(baselines = row.names(df_models),
    baseline_paths = df_models$res_root,threshold = 20,
    profix = 'stateOfArt',res_path = file.path('result','rq2'))

df_models['ONE','res_root'] <- 'One-result/cutoff0.2_exclude20'
run(baselines = row.names(df_models),
    baseline_paths = df_models$res_root,threshold = 0.2,
    profix = 'stateOfArt',res_path = file.path('result','rq2'))


# prepare tables for motivation section

run(baselines = row.names(motivate_models),
    baseline_paths = motivate_models$res_root,threshold = -1,
    profix = 'motivate',res_path = file.path('result','motivation'),
    datasets = c('AEEEM','MA-SZZ-2020','IND-JLMIV+R-1Y_change59','ALLJURECZKO'))


run(baselines = row.names(motivate_models),
    baseline_paths = motivate_models$res_root,threshold = 0.2,
    profix = 'motivate',res_path = file.path('result','motivation'),
    datasets = c('AEEEM','MA-SZZ-2020','IND-JLMIV+R-1Y_change59','ALLJURECZKO'))


run(baselines = row.names(motivate_models),
    baseline_paths = motivate_models$res_root,threshold = 20,
    profix = 'motivate',res_path = file.path('result','motivation'),
    datasets = c('AEEEM','MA-SZZ-2020','IND-JLMIV+R-1Y_change59','ALLJURECZKO'))

# AEEEM_LDHHWCHU

# df_baselines['ONE','res_root'] <- 'One-result/cutoff20_exclude20'
# 
# run(baselines = row.names(df_baselines),
#     baseline_paths = df_baselines$res_root,threshold = -1,
#     profix = 'baseline',res_path = file.path('result','AEEEM_LDHHWCHU'),
#     datasets = c('AEEEM_LDHHWCHU'))
# 
# run(baselines = row.names(df_baselines),
#     baseline_paths = df_baselines$res_root,threshold = 0.2,
#     profix = 'baseline',res_path = file.path('result','AEEEM_LDHHWCHU'),
#     datasets = c('AEEEM_LDHHWCHU'))
# 
# run(baselines = row.names(df_baselines),
#     baseline_paths = df_baselines$res_root,threshold = 20,
#     profix = 'baseline',res_path = file.path('result','AEEEM_LDHHWCHU'),
#     datasets = c('AEEEM_LDHHWCHU'))


