setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
getwd()
# install.packages("devtools")
# devtools::install_github("klainfo/ScottKnottESD", ref="development")
# install.packages('svglite')
library(ScottKnottESD)
library(tidyverse)
library(hrbrthemes)
library(viridis)
library(svglite)

windowsFonts(Times_New_Roman=windowsFont("Times New Roman"))

draw_boxplot <- function(data,xlab_string='',title='',prefix){
    
    
    if(title=='mcc'){
        title = 'MCC'
    }else if(title=='roi_tp'){
        title = 'ROI'
    }else if(title=='ifap2'){
        title = 'eIFA'
    }
    if(xlab_string=='all dataset'){
        xlab_string = ''
    }
    if(prefix=='baseline'){
        x_label_angle=45
        font_size = 10
    }else{
        x_label_angle=60
        font_size = 12
    }
    p = data %>%
        ggplot( aes(x=models, y=value, fill=models)) +
        geom_boxplot() +
        facet_grid(~rank,scales = 'free_x',space = 'free_x')+
        scale_fill_viridis(discrete = TRUE, alpha=0) +
        theme(
            legend.position="none",
            plot.title = element_text(size=font_size),
            axis.text.x = element_text(angle = x_label_angle,vjust = 0.95,hjust=1,size = font_size),
            axis.text.y = element_text(size = font_size),
            axis.title.y = element_text(hjust = 0.5),
            axis.title.x = element_text(hjust = 0.5),
            text=element_text(family="Times_New_Roman", size=font_size),
            panel.spacing = unit(0.5, "lines"),
        
        ) +
        xlab(xlab_string) +
        ylab("rank across target datasets")+
        # scale_y_continuous(breaks = round(seq(1, 9, by = 1),1)) +
        scale_y_reverse(breaks = round(seq(1, 9, by = 1),1)) +
        ggtitle(title)
    p
    if(prefix=='baseline'){
        p = p + theme(plot.margin = unit(c(0.1,0,0,0.1), "cm"))
    }else{
        p = p + theme(plot.margin = unit(c(0.1,0,0,0.9), "cm"))
    }
    
    
    return(p)
    
}



batch_plot <- function(prefix,thresholds,indicators,flag,res_folder,data_folder,parametric='np',level='two'){
    for (threshold in thresholds) {
        for (indicator in indicators) {
            cat(indicator,'\n')
            fileroot = data_folder
            filename = paste(paste(prefix,indicator,'comparison',threshold,sep = '_'),'.csv',sep='')
            cat(filename,'\n')
            all_df = read.csv(file.path(fileroot,filename),row.names = 1)
            arr = colnames(all_df)
            arr = gsub("\\.", "_", arr)
            colnames(all_df) = arr
            col_dataset = all_df$dataset
            all_df$dataset = NULL
            if(level=='one'){
              if(indicator=='ifap2'){
                all_rank = all_df
              }else{
                all_rank = -all_df
              }
            }else{
              if(indicator=='ifap2'){
                all_rank = as.data.frame(t(apply(all_df,1,rank)))
              }else{
                all_rank = as.data.frame(t(apply(-all_df,1,rank)))
              }
            }
            # all_rank <- as.data.frame(t(apply(-all_df,1,rank)))
            all_df[1,]
            all_rank[1,]
            all_df$dataset = col_dataset
            all_rank$dataset = col_dataset
            datasets <- unique(all_df$dataset)
            if(flag=='all'){
                df <- all_rank
                df$dataset <- NULL
                sk <- sk_esd(-df, version=parametric)
                cdname = paste('cd_',threshold,'_',indicator,'_all_',parametric,'_',level,'.png',sep='')
                png(filename =file.path(res_folder,cdname),width = 1600,height =800,res = 200)
                plot(sk)
                dev.off()
                
                
                pairwise_effect_size <- checkDifference(sk$groups, df)
                # draw sk boxplot
                df_reverse <- data.frame(matrix(nrow = nrow(df)*ncol(df),ncol = 0))
                df_reverse$models <- rep(sk$nms[sk$ord],each=nrow(df))
                df_reverse$models <- factor(df_reverse$models,levels = sk$nms[sk$ord],ordered = TRUE)
                for(model in unique(df_reverse$models)){
                    df_reverse[df_reverse$models==model,'value'] <- df[,model]
                    df_reverse[df_reverse$models==model,'rank'] <- as.numeric(sk$groups[model])
                }
                
                p = draw_boxplot(data=df_reverse,xlab_string = 'all dataset',title=indicator,prefix)
                ggroot = res_folder
                ggname = paste(threshold,'_',indicator,'_all_',parametric,'_',level,'.svg',sep='')
                cat('ggname:',ggname,'\n')
                if(prefix=='baseline'){
                    ggsave(file.path(ggroot,ggname),plot=p, width = 2, height = 4,dpi = 1600, bg = "transparent")
                }else if(prefix=='stateOfArt'){
                    ggsave(file.path(ggroot,ggname),plot=p, width = 1.6, height = 4,dpi = 1600, bg = "transparent")
                }
                
                
            }else{
                for(dataset in datasets){
                    
                    df = all_rank[all_rank$dataset==dataset,]
                    df$dataset = NULL
                    sk = sk_esd(-df, version=parametric)
                    
                    pairwise_effect_size <- checkDifference(sk$groups, df)
                    # draw sk boxplot
                    df_reverse <- data.frame(matrix(nrow = nrow(df)*ncol(df),ncol = 0))
                    df_reverse$models <- rep(sk$nms[sk$ord],each=nrow(df))
                    df_reverse$models <- factor(df_reverse$models,levels = sk$nms[sk$ord],ordered = TRUE)
                    for(model in unique(df_reverse$models)){
                        df_reverse[df_reverse$models==model,'value'] <- df[,model]
                        df_reverse[df_reverse$models==model,'rank'] <- as.numeric(sk$groups[model])
                    }
                    p = draw_boxplot(df_reverse,xlab_string = dataset,title=indicator,prefix)
                    
                    ggroot = res_folder
                    
                    ggname = paste(threshold,'_',indicator,'_',dataset,'_',parametric,'_',level,'.svg',sep='')
                    if(prefix=='baseline'){
                        ggsave(file.path(ggroot,ggname),plot=p, width = 2.1, height = 4,dpi = 1600, bg = "transparent")
                    }else if(prefix=='stateOfArt'){
                        ggsave(file.path(ggroot,ggname),plot=p, width = 1.7, height = 4,dpi = 1600, bg = "transparent")
                    }
                }
            }
            
        }
    }
    
}

# for rq1
# on all datasets
batch_plot(prefix = 'baseline',
           thresholds = c('0.2','20'),
           indicators = c('mcc','roi_tp','ifap2'),
           flag='all',
           res_folder='../figure/rq1',
           data_folder = 'result/rq1',
           parametric='np')

#for rq indicator
batch_plot(prefix = 'baseline',
           thresholds = c('20'),
           indicators = c('mcc','recall','precision','f1','g1','pf'),
           flag='all',
           res_folder='../figure/new_rq_indicator/',
           data_folder = 'result/rq1',
           parametric='np')

# batch_plot(prefix = 'baseline',
#            thresholds = c('0.2','20'),
#            indicators = c('mcc','roi_tp','ifap2'),
#            flag='all',
#            res_folder='../figure/rq1',
#            data_folder = 'result/rq1',
#            parametric='p')

# seperate dataset
batch_plot(prefix = 'baseline',
           thresholds = c('0.2','20'),
           indicators = c('mcc','roi_tp','ifap2'),
           flag='',
           res_folder='../figure/rq1',
           data_folder = 'result/rq1',
           parametric='np')
# for rq2
# on all datasets
batch_plot(prefix = 'stateOfArt',
           thresholds = c('-1','0.2','20'),
           indicators = c('mcc','roi_tp','ifap2'),
           flag='all',
           res_folder ='../figure/rq2',
           data_folder = 'result/rq2',
           parametric='np')


batch_plot(prefix = 'stateOfArt',
           thresholds = c('-1','0.2','20'),
           indicators = c('mcc','roi_tp','ifap2'),
           flag='all',
           res_folder ='../figure/rq2',
           data_folder = 'result/rq2',
           parametric='np',level = 'one')

# batch_plot(prefix = 'stateOfArt',
#            thresholds = c('-1','0.2','20'),
#            indicators = c('mcc','roi_tp','ifap2'),
#            flag='all',
#            res_folder ='../figure/rq2',
#            data_folder = 'result/rq2',
#            parametric='p')
# seperate dataset
batch_plot(prefix = 'stateOfArt',
           thresholds = c('-1','0.2','20'),
           indicators = c('mcc','roi_tp','ifap2'),
           flag='',
           res_folder='../figure/rq2',
           data_folder = 'result/rq2',
           parametric='np')

