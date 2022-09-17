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

windowsFonts(Times_New_Roman = windowsFont("Times New Roman"))

draw_heatmap <-
  function(pairwise_effect_size,
           xlab_string = '',
           title = '',
           prefix) {
    # Give extreme colors:
    pairwise_effect_size2 = pairwise_effect_size
    temp_i = pairwise_effect_size2$i
    pairwise_effect_size2$i = pairwise_effect_size2$j
    pairwise_effect_size2$j = temp_i
    temp_ranki = pairwise_effect_size2$ranki
    pairwise_effect_size2$ranki = pairwise_effect_size2$rankj
    pairwise_effect_size2$rankj = temp_ranki
    data = rbind(pairwise_effect_size, pairwise_effect_size2)
    
   # data = data[data$i < data$j, ]
    colnames(data)[colnames(data) == 'mag'] = 'level'
    if (title == 'mcc') {
      title = 'MCC'
    } else if (title == 'roi_tp') {
      title = 'ROI'
    } else if (title == 'ifap2') {
      title = 'eIFA'
    }
    if (xlab_string == 'all dataset') {
      xlab_string = ''
    }
    font_size = 8
    x_label_angle = 60
    
    
    p = ggplot(data, aes(i, j, fill = level)) +
      geom_tile(color = "white") +
      facet_grid(~ranki,scales = 'free_x',space = 'free_x')+
      scale_fill_brewer(palette = "Greens", direction = -1) +
      theme(
        plot.title = element_text(size = font_size),
        axis.text.x = element_text(
          angle = x_label_angle,
          vjust = 0.95,
          hjust = 1,
          size = font_size
        ),
        axis.text.y = element_text(size = font_size),
        axis.title.y = element_text(hjust = 0.5),
        axis.title.x = element_text(hjust = 0.5),
        text = element_text(family = "Times_New_Roman", size = font_size),
        panel.spacing = unit(0.1, "lines"),
        plot.margin = unit(c(0.1, 0.1, 0.1, 0.1), "cm"),
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank()
      ) +
      xlab(xlab_string) + ylab('') +
      ggtitle(title)
    p
    
    return(p)
    
  }

library(ggpubr)
batch_plot <-
  function(prefix,
           thresholds,
           indicators,
           flag,
           res_folder,
           data_folder,
           parametric = 'np') {
    
    for (threshold in thresholds) {
      for (indicator in indicators) {
        cat(indicator, '\n')
        fileroot = data_folder
        filename = paste(paste(prefix, indicator, 'comparison', threshold, sep = '_'),
                         '.csv',
                         sep = '')
        cat(filename, '\n')
        all_df = read.csv(file.path(fileroot, filename), row.names = 1)
        all_df$ONE <- NULL
        arr = colnames(all_df)
        arr = gsub("\\.", "_", arr)
        colnames(all_df) = arr
        col_dataset = all_df$dataset
        all_df$dataset = NULL
        if (indicator == 'ifap2') {
          all_rank = as.data.frame(t(apply(all_df, 1, rank)))
        } else{
          all_rank = as.data.frame(t(apply(-all_df, 1, rank)))
        }
        # all_rank <- as.data.frame(t(apply(-all_df,1,rank)))
        all_df[1, ]
        all_rank[1, ]
        all_df$dataset = col_dataset
        all_rank$dataset = col_dataset
        datasets <- unique(all_df$dataset)
        
        df <- all_rank
        df$dataset <- NULL
        sk <- sk_esd(-df, version = parametric)
        
        pairwise_effect_size <-
          checkDifference(sk$groups, df)
        # draw heatMap
        pairwise_effect_size$i = factor(pairwise_effect_size$i,
                                        levels = sk$nms[sk$ord],
                                        ordered = TRUE)
        pairwise_effect_size$j = factor(pairwise_effect_size$j,
                                        levels = sk$nms[sk$ord],
                                        ordered = TRUE)
        pairwise_effect_size$mag = factor(
          pairwise_effect_size$mag,
          levels = c("large", "medium", "small", "negligible"),
          ordered = TRUE
        )
        
        p = draw_heatmap(pairwise_effect_size,
                         xlab_string = 'all dataset',
                         title = indicator,
                         prefix)
        if (threshold == '-1') {
          xlab_string = '(a) default threshold'
          p1 = p + xlab(xlab_string)
        } else if (threshold == '20') {
          xlab_string = '(b) SSC (PCI=20%)'
          p2 = p + xlab(xlab_string)
        } else if (threshold == '0.2') {
          xlab_string = '(c) SNM (PII=20%)'
          p3 = p + xlab(xlab_string)
        }
        
        # if (threshold != 0.2) {
        #   p = p + theme(legend.position = "none")
        #   
        # }
        
        
      }
    }
    res_p = ggarrange(p1, p2, p3,
              
              common.legend = TRUE,
              legend = "right",
              ncol = 3, nrow = 1)
    ggroot = res_folder
    ggname = paste( 'total_', indicator, '_all_', parametric, '.svg', sep =
                     '')
    cat('ggname:', ggname, '\n')
    
    ggsave(
      file.path(ggroot, ggname),
      plot = res_p,
      width = 6.06,
      height = 2.03,
      dpi = 1600,
      bg = "transparent"
    )
    
    
  }

# for rq1
# on all datasets
batch_plot(
  prefix = 'baseline',
  thresholds = c('-1', '0.2', '20'),
  indicators = c('mcc'),
  flag = 'all',
  res_folder = '../figure/new_rq/',
  data_folder = 'result/rq1',
  parametric = 'np'
)


