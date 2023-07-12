source('function.R')
total_res=c()
for(i in 1:100){
  r1 = sample(1:10, 10, replace = T)
  r2 = sample(1:10, 10, replace = F)
  res = WS(cbind(r1,r2))
  if(res$r2<0){
    cat('r1 ',r1,'\n')
    cat('r2 ',r2,'\n\n')
  }
  total_res = append(total_res,res$r2)
  #cat("WS corr:",res$r2,'\t')
}
cat('\n min:',min(total_res),'\t max:',max(total_res))

