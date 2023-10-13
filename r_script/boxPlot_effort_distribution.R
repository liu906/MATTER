setwd('E:/MATTER/r_script/result/motivation/')
library(gridExtra)
library(ggplot2)
library(tidyr)
library(dplyr)
library(extrafont)

# Set the font to Times New Roman
loadfonts(device = "win")
theme_set(theme_minimal(base_family = "Times New Roman"))

get_median <- function(df){
  # 使用gather将数据整理成长格式
  
  selected_columns <- df[, 2:ncol(df)]
  
  # 计算每一行的中位数
  row_medians <- apply(selected_columns, 1, median)
  
  # 创建一个新的数据框，包含一个名为"Median"的列
  new_df <- data.frame(Median = row_medians)
  return(new_df)
}

draw_boxplot <- function(pii_df,pci_df){
  pii_df <- get_median(pii_df)
  pci_df <- get_median(pci_df)
  
  
  # pci_long <- pci_df %>%
  #   gather(key = "Variable", value = "Value", -dataset)
  # pii_long <- pii_df %>%
  #   gather(key = "Variable", value = "Value", -dataset)
  
  # pci_long$type = 'PCI'
  # pii_long$type = 'PII'
  pci_df$type = 'PCI'
  pii_df$type = 'PII'
  # combined_df <- rbind(pci_long,pii_long)
  combined_df <- rbind(pci_df,pii_df)
  # 合并表格
  # Combine columns
  
  
  y_limits <- c(0, 0.4)  # Adjust the range as needed
  
  # Define font size
  font_size <- 14  # Adjust the size as needed
  
  # Plot boxplots with adjusted y-axis limits, Times New Roman font, and increased font size
  p <- ggplot(combined_df, aes(x = type, y = Median, fill = type)) +
    geom_boxplot(outlier.shape = NA) +
    ylim(y_limits[1], y_limits[2]) +  # Set y-axis limits
    theme(axis.title.x = element_blank(),
          legend.position = "none",
          text = element_text(family = "serif", size = font_size)) 
  return(p)
}

pii_df <- read.csv('motivate_pii_comparison_20.csv',row.names = 1)
pci_df <- read.csv('motivate_pci_comparison_20.csv',row.names = 1)
p <- draw_boxplot(pii_df,pci_df)
# Save as EPS
#ggsave("effort_distribution_SSC20.eps", plot = p, device = "eps", units = "in", width = 1.5, height = 3)
# Save as SVG
ggsave("effort_distribution_SSC20.svg", plot = p, device = "svg", units = "in", width = 1.5, height = 3)


pii_df <- read.csv('motivate_pii_comparison_0.2.csv',row.names = 1)
pci_df <- read.csv('motivate_pci_comparison_0.2.csv',row.names = 1)
p <- draw_boxplot(pii_df,pci_df)
# Save as EPS
#ggsave("effort_distribution_SNM20.eps", plot = p, device = "eps", units = "in", width = 1.5, height = 3)
# Save as SVG
ggsave("effort_distribution_SNM20.svg", plot = p, device = "svg", units = "in", width = 1.5, height = 3)


pii_df <- read.csv('motivate_pii_comparison_-1.csv',row.names = 1)
pci_df <- read.csv('motivate_pci_comparison_-1.csv',row.names = 1)
p <- draw_boxplot(pii_df,pci_df)
# Save as EPS
# ggsave("effort_distribution_defaultThreshold.eps", plot = p, device = "eps", units = "in", width = 1.5, height = 3)
# Save as SVG
ggsave("effort_distribution_defaultThreshold.svg", plot = p, device = "svg", units = "in", width = 1.5, height = 3)

