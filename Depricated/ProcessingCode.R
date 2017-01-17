library(imager)
library(magick)
test=load.image("BCD1F1.png")
test=load.image("sad3M3.png")
testcrop=crop.borders(test,ny=35);plot(testcrop)

plot(isoblur(test2,5))


test2=grayscale(test)
test3=crop.borders(test2,ny=35)
plot(test3)


vignette("gettingstarted",package="imager")


test4=crop.borders(test,ny=35)
test5=grayscale(test4)
test6=isoblur(test5,5)
test7=threshold(test6,"70%")
plot(test7)
plot(test)

op=par()
par(mfrow=c(1,2)) 
plot(test7)
plot(test)


im <- test2
nhood <- expand.grid(dx=-2:2,dy=-2:2) #We want to include all pixels in a square 5x5 neighbourhood
nhood <- expand.grid(dx=-3:3,dy=-3:3) #We want to include all pixels in a square 5x5 neighbourhood

im.s <- alply(nhood,1,function(d) imshift(im,d$dx,d$dy))
max.filt <- do.call(pmax,im.s);plot(max.filt)
min.filt <- do.call(pmin,im.s);plot(min.filt)

test8=threshold(isoblur(min.filt,5),"70%")

df1=test8%>%as.data.frame
df2=test5%>%as.data.frame
df1$image="Processed"
df2$image="Raw"

df3=rbind(df1,df2)

ggplot(df3,aes(x=x,y=y))+geom_raster(aes(fill=value))+facet_grid(~image)

imdata=as.data.frame(test7)
imdata=data.frame(imdata)

(imdata[2,2]/sum(imdata[,2]))*100

library(EBImage)

