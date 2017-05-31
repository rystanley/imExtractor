ImageProcess_single=function(path,pix=200,offset=0.01,sigma=3,crop=150){
  
  #path -- The full or relative file path for the target image.
  #pix -- Defines the number of pixels to be used in adaptive thresholding. Here a threshold is applied by a locally moving filter. 
  #offset -- Thresholding offset from the averaged pixel value . In this case each group of pixels an average will be used to define what is 'target' (e.g. tissue) and what is 'background' this offset will define how far off the average you want to make this delineation.
  #sigma -- This parameter repesentes the standard deviation of the Gaussian filter used for blurring.
  #crop -- Optional parameter defining the number of pixels to trim off the bottom of the image if required. This parameter is useful if a scalebar is added to the image.
  
  rootdir <- getwd() #save working directory
  
  im=suppressWarnings(readImage(x)) # hold the original image for comparison. Since the Tiffs have some missing compression encoding the readImage function will spit out a warning, which are harmless. 
  
  setwd(dirname(x)) #set functions directory to the parent directory of the image
  
  #Crop bottom
  if(is.numeric(crop)){
    im <- im[,1:(dim(im)[2]-crop),]
    }
  
  
  im2=im # make a copy of the original image for processing
  colorMode(im2) = Grayscale # convert to grayscale
  img=im2
  im2=gblur(im2,sigma=sigma)
  im3=thresh(im2, pix, pix, offset) # adaptive thresholding based on a pix and offset parametes. Note threshold is applied to each grayscale channel
  im4=im3 # create a copy of the thresholded image which can be assigned the color mode for image appending
  colorMode(im4) = Color # assign the color mode to match original 'im'
  
  #combine colour channels after the adaptive threshold
  Channel1=im3@.Data[,,1] # first grayscale channel
  Channel2=im3@.Data[,,2] # second grayscale channel
  Channel3=im3@.Data[,,3] # third grayscale channel
  stack <- Channel1+Channel2+Channel3 # add channels togegther
  
  #change to the summed stack  
  im4@.Data[,,1]=stack
  im4@.Data[,,2]=stack
  im4@.Data[,,3]=stack
  
  #calculate coverage
  Coverage <- sum(!stack)/length(stack)*100
  CoverageLab <- paste0(round(Coverage,1),"% coverage. ", x)
  
  #combined the images for the summary output
  xt=list(im,im4) # create a list of the images for the processing comparision
  xt=EBImage::combine(xt) # append images
  
  #save the images in an output folder where the images are listed from. If not there create it. 
  if(length(which(list.files(getwd())=="Processed images"))==0){dir.create(paste0(getwd(),"/Processed images"))} # if there isn't a 'images and Data' folder for output create one
  
  #save the image with processed
  ImType <- unlist(strsplit(x, ".", fixed = TRUE))[2]
  
  if(ImType == "tif"){png(paste0(getwd(),"/Processed images/",gsub(".tif","",gsub("/","",gsub(getwd(),"",x))),"_processed.png"),width=dim(im)[1],height = dim(im)[2],unit="px")}
  if(ImType == "jpg"){png(paste0(getwd(),"/Processed images/",gsub(".jpg","",gsub("/","",gsub(getwd(),"",x))),"_processed.png"),width=dim(im)[1],height = dim(im)[2],unit="px")}
  
    display(xt,all=T,method="raster") #display the images in raster format
    text(x=dim(xt)[1]*0.05,y=dim(xt)[2]*0.05,label = CoverageLab,adj = c(0,1),font=2)
    
  dev.off()
  
  return(data.frame(Image=x,Coverage=Coverage,stringsAsFactors = F)) # return the processed data.
  
  setwd(rootdir) # back to working directory
  
}
