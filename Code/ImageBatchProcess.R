ImageBatchProcess=function(folder,month=NULL,year=NULL,code=NULL,pix=200,offset=0.01,sigma=3,crop=150){
  
  setwd(folder) # set working directory to folder
  
  files <- (Sys.glob("*.tif")) # identify any 
  
  Start=Sys.time() # timing funciton 
  
  ImageMetaData <- lapply(files,FUN=ImageProcess,pix=pix,offset=offset,sigma=sigma,crop=crop)
  
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
