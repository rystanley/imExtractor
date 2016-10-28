library(imager)
library(dplyr)
library(gridExtra)
library(ggplot2)


library(tiff)
img <- readTIFF("BCD1F1.tif", native=TRUE)
writeJPEG(img, target = "Converted.jpeg", quality = 1)

test=load.image("BCD1F1.png")
test=load.image("sad3M3.png")


ImageProcess=function(x,thresh="70%"){
  
  
processed=crop.borders(x,ny=35)
processed1=grayscale(processed)
processed2=isoblur(processed1,5)
processed3=threshold(processed2,"70%")

df1 <- processed3%>%as.data.frame()
df2 <- processed1%>%as.data.frame()

list(processed1,processed2) %>% imappend("x") %>% plot

nhood <- expand.grid(dx=-2:2,dy=-2:2) #We want to include all pixels in a square 5x5 neighbourhood
im.s <- alply(nhood,1,function(d) imshift(x,d$dx,d$dy))
min.filt <- do.call(pmin,im.s)
tt <- threshold(isoblur(grayscale(min.filt),5),thresh)

df1 <- min.filt%>%as.data.frame()
df2 <- processed1%>%as.data.frame()

processed=ggplot(df1,aes(x=x,y=y))+geom_raster(aes(fill=value))+
  scale_fill_gradient(low="black",high="white")+
  scale_x_continuous(expand = c(0,0))+
  scale_y_continuous(expand = c(0,0))+
  theme_bw()+
  theme(legend.position="none",
        axis.title.x=element_blank(),
        axis.text.x=element_blank(),
        axis.ticks.x=element_blank(),
        axis.title.y=element_blank(),
        axis.text.y=element_blank(),
        axis.ticks.y=element_blank())

raw=ggplot(df2,aes(x=x,y=y))+geom_raster(aes(fill=value))+
  scale_fill_gradient(low="black",high="white")+
  scale_x_continuous(expand = c(0,0))+
  scale_y_continuous(expand = c(0,0))+
  theme_bw()+
  theme(legend.position="none",
        axis.title.x=element_blank(),
        axis.text.x=element_blank(),
        axis.ticks.x=element_blank(),
        axis.title.y=element_blank(),
        axis.text.y=element_blank(),
        axis.ticks.y=element_blank())

grid.arrange(raw,processed,nrow=1)



## find a way to add the image name and the precent cover. As well as threshold stats and 

im=load.image("sad3M3.png")
crop.borders(im,ny=35)
im <- RGBtoHSL(im)
channel(im,3) <- isoblur(channel(im,3),5,gaussian=T); 
im <- HSLtoRGB(im)
im <- isoblur(im,2)
im2 <- threshold(grayscale(im),"80%")
list(im,im2) %>% imappend("x") %>% plot()%>%text(0,0,"79%",adj = c(-1,1))
im2%>%as.data.frame()%>%summarise(precentcoverage=1-(sum(value)/length(value)))

Start=Sys.time()
im=load.image("BCD1F1.png")
crop.borders(im,ny=35)
im <- RGBtoHSL(im)
channel(im,3) <- isoblur(channel(im,3),5,gaussian=T); 
im <- HSLtoRGB(im)
im <- isoblur(im,2)
im2 <- threshold(grayscale(im),"80%")
Coverage <- paste(im2%>%as.data.frame()%>%
                    summarise(precentcoverage=(1-(sum(value)/length(value)))*100)%>%
                    as.numeric()%>%round(.,1),"% coverage. Image:",i)


par(oma=c(0,0,0,0),mar=c(1.2,0,0,0))
png("Test.png",width = 800,height = 400)
list(im,im2) %>% imappend("x") %>% plot(ylab="",xlab="",axes=FALSE,xaxs="i", yaxs="i")
title(xlab=Coverage, line=0)
dev.off()


Sys.time()-Start

im=load.image("sad3M3.png")
im2=grayscale(im)
im2[im2[,,,]<0.1]=0.3
list(im,im2) %>% imappend("x") %>% plot

