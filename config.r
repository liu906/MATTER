datasets <- data.frame()
datasets['AEEEM','root'] <- './dataset/AEEEM/'
datasets['AEEEM','res_root'] <- './ONE-result/AEEEM'
datasets['AEEEM','actualBugLabel'] <- 'bugs'
datasets['AEEEM','sloc'] <- 'numberOfLinesOfCode'

datasets['AEEEM_LDHHWCHU','root'] <- './dataset/AEEEM_LDHHWCHU/'
datasets['AEEEM_LDHHWCHU','res_root'] <- './ONE-result/AEEEM_LDHHWCHU'
datasets['AEEEM_LDHHWCHU','actualBugLabel'] <- 'bug'
datasets['AEEEM_LDHHWCHU','sloc'] <- 'numberOfLinesOfCode'

datasets['ALLJURECZKO','root'] <- './dataset/ALLJURECZKO/'
datasets['ALLJURECZKO','res_root'] <- './ONE-result/ALLJURECZKO'
datasets['ALLJURECZKO','actualBugLabel'] <- 'bug'
datasets['ALLJURECZKO','sloc'] <- 'loc'

datasets['IND-JLMIV+R-1Y','root'] <- './dataset/IND-JLMIV+R-1Y/'
datasets['IND-JLMIV+R-1Y','res_root'] <- './ONE-result/IND-JLMIV+R-1Y'
datasets['IND-JLMIV+R-1Y','actualBugLabel'] <- 'bug'
datasets['IND-JLMIV+R-1Y','sloc'] <- 'loc'

datasets['IND-JLMIV+R-1Y_change59','root'] <- './dataset/IND-JLMIV+R-1Y_change59/'
datasets['IND-JLMIV+R-1Y_change59','res_root'] <- './ONE-result/IND-JLMIV+R-1Y_change59'
datasets['IND-JLMIV+R-1Y_change59','actualBugLabel'] <- 'bug'
datasets['IND-JLMIV+R-1Y_change59','sloc'] <- 'loc'

datasets['MA-SZZ-2020','root'] <- './dataset/MA-SZZ-2020/'
datasets['MA-SZZ-2020','res_root'] <- './ONE-result/MA-SZZ-2020'
datasets['MA-SZZ-2020','actualBugLabel'] <- 'bug'
datasets['MA-SZZ-2020','sloc'] <- 'loc'

datasets['RELINK','root'] <- './dataset/RELINK/'
datasets['RELINK','res_root'] <- './ONE-result/RELINK'
datasets['RELINK','actualBugLabel'] <- 'isDefective'
datasets['RELINK','sloc'] <- 'CountLineCode'

datasets['NETGENE','root'] <- './dataset/NETGENE/'
datasets['NETGENE','res_root'] <- './ONE-result/NETGENE'
datasets['NETGENE','actualBugLabel'] <- 'bug'
datasets['NETGENE','sloc'] <- 'sloc'

datasets['MDP','root'] <- './dataset/MDP/'
datasets['MDP','res_root'] <- './ONE-result/MDP'
datasets['MDP','actualBugLabel'] <- 'bug'
datasets['MDP','sloc'] <- 'LOC_EXECUTABLE'

indicators <- c('auc','pf','recall','roi','ifap2')

baselines <- data.frame()
baselines['Bellwether','res_root'] <- file.path('baseline-result','Bellwether')
baselines['EASC_E','res_root'] <- file.path('baseline-result','EASC_E')
baselines['EASC_NE','res_root'] <- file.path('baseline-result','EASC_NE')
baselines['SC','res_root'] <- file.path('baseline-result','SC')
baselines['CLA','res_root'] <- file.path('baseline-result','CLA')
baselines['FCM','res_root'] <- file.path('baseline-result','FCM') 
baselines['ManualDown','res_root'] <- file.path('baseline-result','ManualDown') 
baselines['ManualUp','res_root'] <- file.path('baseline-result','ManualUp') 

models <- data.frame()
models['CamargoCruz09-NB','res_root'] <- file.path('baseline-result','CamargoCruz09-NB')
models['Amasaki15-NB','res_root'] <- file.path('baseline-result','Amasaki15-NB')
models['Peters15-NB','res_root'] <- file.path('baseline-result','Peters15-NB')
models['DSSDPP','res_root'] <- file.path('baseline-result','DSSDPP')
# models['KSETE','res_root'] <- file.path('baseline-result','KSETE')


#top-core暂时不用了 KSETE和MSMDA会out of memory 暂时也不用了


motivate_models <- data.frame()
motivate_models['CamargoCruz09-DT','res_root'] <- file.path('baseline-result','CamargoCruz09-DT')
motivate_models['Turhan09-DT','res_root'] <- file.path('baseline-result','Turhan09-DT')
motivate_models['Watanabe08-DT','res_root'] <- file.path('baseline-result','Watanabe08-DT')
motivate_models['ManualDown','res_root'] <- file.path('baseline-result','ManualDown')
motivate_models['ManualUp','res_root'] <- file.path('baseline-result','ManualUp')
motivate_models['EASC_E','res_root'] <- file.path('baseline-result','EASC_E')

