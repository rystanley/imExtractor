ImageBatchProcess=function(dir,month=NULL,year=NULL,code=NULL){
  
  setwd(dir) # set working directory to dir
  
  files <- (Sys.glob("*.tif")) # identify any 
  
  Start=Sys.time() # timing funciton 
  
  ImageMetaData <- lapply(files,FUN=ImageProcess)
  
  Timelog <- Sys.time()-Start
  Timelog <- round(as.numeric(Timelog,units="mins"),2)
  
  output <- as.data.frame(do.call(rbind,ImageMetaData),stringsAsFactors=F)
  
  #Add image metadata to the output dataframe
  if(is.null(year)){year="Not specified"}
  if(is.null(month)){month="Not specified"}
  if(is.null(code)){code="Not specified"}
  
  
  imagedata <- data.frame(Year=rep(year,nrow(output)),
                             Month=rep(month,nrow(output)),
                             Code=rep(code,nrow(output)),stringsAsFactors=F)
  
  output=cbind(imagedata,output)
  
  print(paste("Elapsed time to process",nrow(output),"Images ~",Timelog,"minutes",sep=" "))
  
  return(output)
  
}
