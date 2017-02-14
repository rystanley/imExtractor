ImageProcess_single=function(x,pix=200,offset=0.01,sigma=3,crop=150){
  
  
  im=suppressWarnings(readImage(x)) # hold the original image for comparison. Since the Tiffs have some missing compression encoding the readImage function will spit out a warning, which are harmless. 
  
  setwd(dirname(x))
  
  #Crop the scale bar off
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
  if(length(which(list.files(getwd())=="Processed figures"))==0){dir.create(paste0(getwd(),"/Processed figures"))} # if there isn't a 'Figures and Data' folder for output create one
  
  #save the image with processed
  ImType <- unlist(strsplit(x, ".", fixed = TRUE))[2]
  
  if(ImType == "tif"){png(paste0(getwd(),"/Processed figures/",gsub(".tif","",gsub("/","",gsub(getwd(),"",x))),"_processed.png"),width=dim(im)[1],height = dim(im)[2],unit="px")}
  if(ImType == "jpg"){png(paste0(getwd(),"/Processed figures/",gsub(".jpg","",gsub("/","",gsub(getwd(),"",x))),"_processed.png"),width=dim(im)[1],height = dim(im)[2],unit="px")}
  
    display(xt,all=T,method="raster") #display the images in raster format
    text(x=dim(xt)[1]*0.05,y=dim(xt)[2]*0.05,label = CoverageLab,adj = c(0,1),font=2)
    
  dev.off()
  
  return(data.frame(Image=x,Coverage=Coverage,stringsAsFactors = F)) # return the processed data.
  
}
