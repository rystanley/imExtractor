
ImageBatchProcess=function(path,pix=200,offset=0.01,sigma=3,crop=NA){
  
  #path -- The full or relative file path for the target folder containing the images.
  #pix -- Defines the number of pixels to be used in adaptive thresholding. Here a threshold is applied by a locally moving filter. 
  #offset -- Thresholding offset from the averaged pixel value . In this case each group of pixels an average will be used to define what is 'target' (e.g. tissue) and what is 'background' this offset will define how far off the average you want to make this delineation.
  #sigma -- This parameter repesentes the standard deviation of the Gaussian filter used for blurring.
  #crop -- Optional parameter defining the number of pixels to trim off the bottom of the image if required. This parameter is useful if a scalebar is added to the image.
  
  curdir <- getwd() #current working directory
  
  setwd(folder) # set working directory to folder

  files <- (Sys.glob("*.tif")) # identify any 
  
  Start=Sys.time() # timing funciton 
  
  ImageMetaData <- lapply(files,FUN=ImageProcess,pix=pix,offset=offset,sigma=sigma,crop=crop)

  #Set up timing parameters
  Timelog <- Sys.time()-Start
  Timelog <- round(as.numeric(Timelog,units="mins"),2)
  
  output <- as.data.frame(do.call(rbind,ImageMetaData),stringsAsFactors=F)
  
  print(paste("Elapsed time to process",nrow(output),"Images ~",Timelog,"minutes",sep=" "))
  
  setwd(curdir) #back to current working directory
  
  return(output)
  
}
