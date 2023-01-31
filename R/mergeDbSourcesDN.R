mergeDbSourcesDN <- function(x,remove.duplicated=TRUE){
  # hack bibliometrix::mergeDbSources to work with list object
  ###
  L <- x
  
  n=length(L)
  
  Tags=names(L[[1]])
  
  ## identification of common tags
  for (j in 2:n){
    Tags=intersect(Tags,names(L[[j]]))
  }
  #####
  M=data.frame(matrix(NA,1,length(Tags)))
  names(M)=Tags
  for (j in 1:n){
    L[[j]]=L[[j]][,Tags]
    
    M=rbind(M,L[[j]])
  }
  
  ## author data cleaning
  if ("AU" %in% Tags){
    M$AU=gsub(","," ",M$AU)
    AUlist=strsplit(M$AU,";")
    AU=lapply(AUlist,function(l){
      l=trim(l)
      name=strsplit(l," ")
      lastname=unlist(lapply(name,function(ln){ln[1]}))
      firstname=lapply(name,function(ln){
        f=paste(substr(ln[-1],1,1),collapse=" ")
      })
      AU=paste(lastname,unlist(firstname),sep=" ",collapse=";")
      return(AU)
    })
    M$AU=unlist(AU)
    
  }
  M=M[-1,]
  M$DB="ISI"
  
  if (isTRUE(remove.duplicated)){
    M$TI=gsub("[^[:alnum:] ]","",M$TI)
    M$TI=gsub("(?<=[\\s])\\s*|^\\s+|\\s+$", "", M$TI, perl=TRUE)
    d=duplicated(M$TI)
    cat("\n",sum(d),"duplicated documents have been removed\n")
    M=M[!d,]
  }
  class(M) <- c("bibliometrixDB", "data.frame")
  return(M)
}