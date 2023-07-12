
# df example
# ifap2 ifa ifa_pci ifa_pii
# EASC_NE        1   1       1       1
# ManualDown     1   2       2       2
# ONE            1   3       2       3
# CLA            1   3       2       3
# Bellwether     1   4       3       4
# FCM            2   4       3       4
# SC             2   4       3       4
# EASC_E         2   5       3       5
# ManualUp       3   5       3       5


WS <- function(df){
  # the first column in df as x, other columns as y
  N = nrow(df)
  res = data.frame(matrix(nrow = 1,ncol = ncol(df)-1))
  colnames(res) <- colnames(df)[2:ncol(df)]
  rownames(res) <- colnames(df)[1]
  
  for(y in 2:ncol(df)){
    total = 0
    for(i in 1:N){
      exp = 2^-df[i,1]
      abs_diff = abs(df[i,1] - df[i,y])
      denominator = max(abs(1-df[i,1]),abs(N-df[i,1]))
      temp = exp*abs_diff/denominator
      #cat('item: ',temp,'\n')
      total = total+temp
    }
    res[1,y-1] = 1 - total
  }
  return(res)
  
  # return example:
  #             ifa   ifa_pci   ifa_pii
  # ifap2 0.7916667 0.4196429 0.7916667
}
# example of call function
# res = WS(df)





