setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
getwd()
# (1) compute performance indicators of studied models given threshold(-1 for unalignment, 20 for SSC, and 0.2 for SNM) 
source("computeIndicatorFromDetailResult.r")
# summary result in (1) to one table
source("summaryDataForRQ1.r")
# run One for rq1 and rq2
source("One_under_SSC20_SNM0.2_RQ1andRQ2.r")

source("C:/Users/Cecilia/Documents/getPerformanceForSSCSNM20.r")
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
source("summaryDataForRQ2.r")
source("statistic.r")

