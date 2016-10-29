#library(imager)
library(EBImage)
library(dplyr)




ImageProcess=function(x,thresh="80%",saveIm=TRUE){
  
  require(imager)
  require(dplyr)
  

im=load.image(x)
crop.borders(im,ny=30,nx=200) # crop of edge effects and scale
im <- RGBtoHSL(im) # covert to Hue Saturation Lightness colourspace
channel(im,3) <- isoblur(channel(im,3),5,gaussian=T) # blur the "lightness' channel to attempt to correct for uneven lighting
im <- HSLtoRGB(im) # covert back to Red Green Blue colourspace
im <- isoblur(im,2) # apply a isotropic blur with a standard deviation of 2. 
im2 <- threshold(grayscale(im)) # threshold image

Coverage <- paste(im2%>%as.data.frame()%>%
                    summarise(precentcoverage=(1-(sum(value)/length(value)))*100)%>%
                    as.numeric()%>%round(.,1),"% coverage. Image:",x) #calculate the % coverage of gonadal tissue vs. background

imCoverage <- im2%>%as.data.frame()%>%
  summarise(precentcoverage=(1-(sum(value)/length(value)))*100)%>%
  as.numeric()%>%round(.,1)

#save image
if(saveIm){
par(oma=c(0,0,0,0),mar=c(1.2,0,0,0)) # set image margins

png(paste0(gsub(".jpg","",x),"_processed.png"),width = 800,height = 400)
  list(im,im2) %>% imappend("x") %>% plot(ylab="",xlab="",axes=FALSE,xaxs="i", yaxs="i")
  title(xlab=Coverage, line=0)
dev.off()

}

return(data.frame(Image=x,Coverage=imCoverage,stringsAsFactors = F)) # return the processed data.

}



ImageProcess=function(x,pix=200,offset=0.05,gblur=TRUE,sigma=7){
  im=readImage(x) # hold the original image for comparison
  im2=im # make a copy of the original image for processing
  colorMode(im2) = Grayscale # convert to grayscale
  #apply a bluring to get rid of some fine details which drive the threshold
  if(gblur){
  im2=gblur(im2,sigma=sigma)
  }
  im3=thresh(im2, pix, pix, offset) # adaptive thresholding based on a pix and offset parametes. Note threshold is applied to each grayscale channel
  im4=im3 # create a copy of the thresholded image which can be assigned the color mode for image appending
  colorMode(im4) = Color # assign the color mode to match original 'im'
  xt=list(im,im4) # create a list of the images for the processing comparision
  xt=combine(xt) # append images
  #display(xt,all=T,method="raster") #display the images in raster format
  
  
  #calculate coverage
  Channel1=im3@.Data[,,1] # first grayscale channel
  Channel2=im3@.Data[,,2] # second grayscale channel
  Channel3=im3@.Data[,,3] # third grayscale channel
  stack <- Channel1+Channel2+Channel3 # add channels togegther
  stack[stack>0]=1
  Coverage <- (1-(table(stack)[2]/sum(table(stack))))*100
  
  #Coverage=(1-mean(c(sum(Channel1),sum(Channel2),sum(Channel3)))/length(as.vector(Channel1)))*100
  CoverageLab <- paste0(round(Coverage,1),"% coverage. ", x)
  
  #save the image with processed
  png(paste0(gsub(".jpg","",x),"_processed.png"))
  display(xt,all=T,method="raster") #display the images in raster format
  text(x=dim(xt)[1]*0.05,y=dim(xt)[2]*0.05,label = CoverageLab,adj = c(0,1),font=2)
  dev.off()
  
  return(data.frame(Image=x,Coverage=Coverage,stringsAsFactors = F)) # return the processed data.
  
}


files <- (Sys.glob("*.jpg"))
#
tt <- lapply(files,FUN=ImageProcess)
mydf <- as.data.frame(do.call(rbind,tt),stringsAsFactors=F)


im=readImage("BCD1F1.jpg")
im2=im
colorMode(im2) = Grayscale
im3=thresh(im2, 50, 50, 0.05)
im4=im3
colorMode(im4) = Color
EBImage::display(im,method="raster")


xt=list(im,im4)
xt=combine(xt)

display(xt,all=T,method="raster")

Sys.time()-Start

im=load.image("sad3M3.png")
im2=grayscale(im)
im2[im2[,,,]<0.1]=0.3
list(im,im2) %>% imappend("x") %>% plot

