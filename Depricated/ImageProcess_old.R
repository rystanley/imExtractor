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
