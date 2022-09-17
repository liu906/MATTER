setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
getwd()
root <- 'result/rq1'
indicators <- c('mcc','recall','precision','f1','g1','pf')
threshold = '0.2'
threshold = '20'
total_df <- data.frame()
first_indicator=TRUE
for(indicator in indicators){
  file_name = list.files(root,pattern = paste(indicator,'.*',threshold,'.csv',sep=''))
  data <- read.csv(file.path(root,file_name))
  colnames(data)[1] = 'target'
  flag <- TRUE
  for(model in colnames(data)[-c(1,2)]){
    if(flag){
      temp_df = data[,c('target',model)]
      colnames(temp_df)[2] <- indicator
      temp_df$model <- model
      flag = FALSE
    }else{
      new_temp = data[,c('target',model)]
      colnames(new_temp)[2] <- indicator
      new_temp$model <- model
      temp_df = rbind(temp_df,new_temp)
    }
  }
  if(first_indicator){
    first_indicator=FALSE
    res_df = temp_df
  }
  else{
    res_df[,indicator] = temp_df[,indicator]
  }
}
res_root <- 'result/rq_indicator/'
res_name <- paste('indicator_',threshold,'.csv',sep = '')
res_df = res_df[c(1,3,2,4,5,6,7,8)]
write.csv(res_df,file = file.path(res_root,res_name),row.names = FALSE)

targets = unique(res_df$target)
for(a_target in targets){
  split_df = res_df[res_df$target==a_target,]
  split_df$target = NULL
  row.names(split_df) <- split_df$model
  split_df$model <- NULL
  t_split_df = t(split_df)
  row.names(t_split_df) <- c('MCC','recall','precision','F1','G1','PF')
  write.csv(t_split_df,file = file.path(res_root,paste(a_target,'_',res_name,sep='')),quote = FALSE)
}
