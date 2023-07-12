# Libraries
library(ggplot2)
library(dplyr)
library(hrbrthemes)

setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
data <- read.csv('./result/indicatorsWithCodeSizePercentage.csv')
scenarios <- unique(data$scenario)
models <- unique(data$comparedModel)
indicators <- c('roi','ifap','recall')

for(this_scenario in scenarios){
  for(this_model in models){
    temp <- data[data$comparedModel == this_model,]
    df <- temp[temp$scenario==this_scenario,]
    for(indicator in indicators){
      # Plot
      p_indicator <- paste('pUCS',indicator,sep = '_')
      
      options(repr.plot.width = 5, repr.plot.height = 3.5)
      df %>%
        ggplot( aes(x=codeSizePercentage, y=df[,indicator])) +
        xlab("Excluded code size percentage") + ylab(toupper(indicator))+
        scale_x_continuous(breaks = pretty(df$codeSizePercentage, n = 6)) +
        geom_line(color="grey",size=1) +
        geom_point(shape=21, color="#387063", fill="#69b3a2", size=6) +
        theme_ipsum() +
        geom_hline(yintercept = df[1,p_indicator],colour='#263238',linetype=5,show.legend=TRUE) +
        ggtitle(paste(this_scenario,this_model,'pUCS'))+
        theme_bw() + 
        theme(axis.text = element_text( size = rel(1.3)),
              title = element_text( size = rel(1.3)))
      
      ggsave(paste('./result/excludedCodeSizePercentage/',this_model,'_',this_scenario,'_',indicator,'.svg',sep = ''))
      
    }
  }
}
