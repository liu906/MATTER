setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
getwd()
rank_df <- read.csv('../figure/new_rq_threshold/baseline-total_sk_esd_rank.csv',row.names = 1)
ranks <- c(1,2,3)

#pf
x_range = c(-4,-3,-2,-1,0,1)
flag_first = TRUE
total_df <- NULL
for(rank in ranks){
  models <- rank_df[rank_df$X.1.pf==rank,c(1,3,5)]
  default_ssc <- models[,1]-models[,3]
  frequency_number <- as.data.frame(table(default_ssc))
  
  temp_df <- data.frame(matrix(nrow = length(x_range),ncol = 0))
  temp_df$x <- x_range
  temp_df$frequency <- 0
  rownames(temp_df) <- x_range
  temp_df[as.character(frequency_number$default_ssc),'frequency'] <- frequency_number$Freq
  temp_df$indicator <- 'pf'
  temp_df$compare <- 'Default->SSC'
  temp_df$rank <- rank
  
  if(flag_first){
    flag_first = FALSE
    total_df <- temp_df
  }else{
    total_df <- rbind(total_df,temp_df)
  }
  
  
  default_snm <- models[,1]-models[,2]
  frequency_number <- as.data.frame(table(default_snm))
  
  temp_df <- data.frame(matrix(nrow = length(x_range),ncol = 0))
  temp_df$x <- x_range
  temp_df$frequency <- 0
  rownames(temp_df) <- x_range
  temp_df[as.character(frequency_number$default_snm),'frequency'] <- frequency_number$Freq
  temp_df$indicator <- 'pf'
  temp_df$compare <- 'Default->SNM'
  temp_df$rank <- rank
  
  if(flag_first){
    flag_first = FALSE
    total_df <- temp_df
  }else{
    total_df <- rbind(total_df,temp_df)
  }
  
}


for(rank in ranks){
  models <- rank_df[rank_df$X.1.mcc==rank,c(2,4,6)]
  default_ssc <- models[,1]-models[,3]
  frequency_number <- as.data.frame(table(default_ssc))
  
  temp_df <- data.frame(matrix(nrow = length(x_range),ncol = 0))
  temp_df$x <- x_range
  temp_df$frequency <- 0
  rownames(temp_df) <- x_range
  temp_df[as.character(frequency_number$default_ssc),'frequency'] <- frequency_number$Freq
  temp_df$indicator <- 'mcc'
  temp_df$compare <- 'Default->SSC'
  temp_df$rank <- rank
  
  if(flag_first){
    flag_first = FALSE
    total_df <- temp_df
  }else{
    total_df <- rbind(total_df,temp_df)
  }
  
  
  default_snm <- models[,1]-models[,2]
  frequency_number <- as.data.frame(table(default_snm))
  
  temp_df <- data.frame(matrix(nrow = length(x_range),ncol = 0))
  temp_df$x <- x_range
  temp_df$frequency <- 0
  rownames(temp_df) <- x_range
  temp_df[as.character(frequency_number$default_snm),'frequency'] <- frequency_number$Freq
  temp_df$indicator <- 'mcc'
  temp_df$compare <- 'Default->SNM'
  temp_df$rank <- rank
  
  if(flag_first){
    flag_first = FALSE
    total_df <- temp_df
  }else{
    total_df <- rbind(total_df,temp_df)
  }
}



# library
library(ggplot2)
library(svglite)
windowsFonts(Times_New_Roman = windowsFont("Times New Roman"))
total_df$rank <- paste('Ranked',total_df$rank )
total_df <- total_df[total_df$frequency!=0,]
p <- ggplot(total_df, aes(fill=indicator, y=frequency, x=x)) + 
  geom_bar(stat="identity",position=position_dodge2(width = 0.9, preserve = "single"),color="black")+
  facet_grid(compare~rank)+
  labs(y = "frequency", x = "rank difference") +
  scale_fill_brewer(palette = "PuBu") +
  scale_x_continuous(breaks = round(seq(min(total_df$x), max(total_df$x), by = 1),1))+
  scale_y_continuous(breaks = c(0,1,2,3))+  theme_bw() +
  theme(text = element_text(family = "Times_New_Roman",size = 8))

p  
# ggsave(
#   file.path('../figure/new_rq_threshold/', 'total_rank_difference.svg'),
#   plot = p,
#   width = 5.92,
#   height = 2.19,
#   dpi = 3200
# )
ggsave(
  file.path('../figure/new_rq_threshold/', 'total_rank_difference.eps'),
  plot = p,
  width = 5.92,
  height = 2.19,
  device='eps'
  
)







