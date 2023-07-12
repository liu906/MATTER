#for rq indicator
library(ggplot2)
library(svglite)

indicators <-  c('mcc','recall','precision','f1','g1','pf')

threshold = '0.2'
threshold = '20'
flag_first_column = TRUE
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
getwd()
root <- 'result/rq1'
res_root <- '../figure/new_rq_indicator/'
for(indicator in indicators){
  file_name = list.files(root,pattern = paste(indicator,'.*',threshold,'.csv',sep=''))
  data <- read.csv(file.path(root,file_name),row.names = 1)
  data$dataset = NULL
  my_array <- array(data = unlist(data),
                    dim = nrow(data)*ncol(data))
  if(flag_first_column){
    flag_first_column = FALSE
    res_df = data.frame(matrix(nrow = length(my_array),ncol=0))
  }
  res_df[,indicator] = my_array
}

df_corr = data.frame(matrix(nrow = length(indicators),ncol  = length(indicators)))
colnames(df_corr) = indicators
rownames(df_corr) = indicators

for(indicator_x in indicators){
  for(indicator_y in indicators){
    if(indicator_y == indicator_x){
      next
    }
    p <- ggplot(res_df, 
                aes(x=res_df[,indicator_x], y=res_df[,indicator_y])
               ) + 
      geom_point(color='#2980B9', size = 4) + 
      geom_smooth(method=lm, se=FALSE, fullrange=TRUE, color='#2C3E50')+
      xlab(indicator_x)+ylab(indicator_y)+
      theme(axis.text=element_text(size=22),
            axis.title=element_text(size=24,face="bold"))
    
    ggsave(file.path(res_root, paste(indicator_x,'_',indicator_y,'_',threshold,'.svg',sep='')),plot = p,width = 10,height = 10,dpi = 1600)
    
    corr <- cor.test(x=res_df[,indicator_x], y=res_df[,indicator_y], method = 'spearman')
    df_corr[indicator_x,indicator_y] = paste(round(corr$p.value,4),round(corr$estimate,4))
  }
}

write.csv(df_corr,paste('result/rq_indicator/spearman_corrlation',threshold,'.csv',sep=''))



##### MCC > 0 vs. Recall #####
sub_res_df <- res_df[res_df$mcc > 0,]
p <- ggplot(sub_res_df, aes(x=mcc, y=recall)) + 
  geom_point(color='#2980B9', size = 4) + 
  geom_smooth(method=lm, se=FALSE, fullrange=TRUE, color='#2C3E50')+
  
  theme(axis.text=element_text(size=22),
        axis.title=element_text(size=24,face="bold"))

ggsave(file.path(res_root, paste('mcc_larger0_recall_',threshold,'.svg',sep='')),plot = p,width = 10,height = 10,dpi = 1600)
p
corr <- cor.test(x=sub_res_df$mcc, y=sub_res_df$recall, method = 'spearman')
round(corr$p.value,5)
corr$estimate


p <- ggplot(sub_res_df, aes(x=mcc, y=pf)) + 
  geom_point(color='#2980B9', size = 4) + 
  geom_smooth(method=lm, se=FALSE, fullrange=TRUE, color='#2C3E50')+
  theme(axis.text=element_text(size=22),
        axis.title=element_text(size=24,face="bold"))

ggsave(file.path(res_root, paste('mcc_larger0_pf_',threshold,'.svg',sep='')),plot = p,width = 10,height = 10,dpi = 1600)

corr <- cor.test(x=sub_res_df$mcc, y=sub_res_df$pf, method = 'spearman')
round(corr$p.value,5)
corr$estimate



