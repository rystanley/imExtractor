
## Code to run the process

dir("c:/Users/StanleyR/Documents/Postdoc/DFO/Analysis Help/Renald/mussel reproduction images may 2016/")


setwd("TESTFOLDER/")
files <- (Sys.glob("*.jpg"))

Start=Sys.time()
tt <- lapply(files,FUN=ImageProcess)
Sys.time()-Start


##Process Males
setwd("f:/Gonads/mussel reproduction images july 2016/mussel mantle BCD july 2016/")
files <- (Sys.glob("*.tif")) # identify any 

females <- files[grep("F",files)]
males <- setdiff(files,females)

Output_Males=ImageBatchProcess(files=males,month="July",year=2016,code="BCD",
                         sex="Male",pix=300,sigma=8,crop=150,offset=0.04)

Output_Females=ImageBatchProcess(files=females,month="July",year=2016,code="BCD",
                               sex="Female",pix=200,sigma=10,crop=150,offset=0.02)

write.table(Output,"July_2016_BCD.csv",row.names = F)
















Output2=ImageBatchProcess(dir="c:/Users/StanleyR/Documents/Image Analysis/mussel reproduction images may 2016/mussel mantle BCD may 2016/",
                         month="May",year=2016,code="BCD")

write.table(Output2,"May_2016_BCD.csv",row.names = F)

Output3=ImageBatchProcess(dir="c:/Users/StanleyR/Documents/Image Analysis/mussel reproduction images june 2016/mussel mantle BCD june 2016/",
                         month="June",year=2016,code="BCD")

write.table(Output2,"June_2016_BCD.csv",row.names = F)

ComboData <- rbind(Output2,Output3,Output)

ComboData$Month=factor(ComboData$Month,levels=c("May","June","July"))

ggplot(ComboData,aes(x=Month,y=Coverage))+geom_jitter()+geom_boxplot(alpha=0.5)+theme_bw()+labs(x="Month",y="% Coverage")

library(dplyr)

SumData <- ComboData%>%group_by(Month)%>%summarise(MeanCov=mean(Coverage,na.rm=T),
                                        sdCov=sd(Coverage,na.rm=T),
                                        seCov=sd(Coverage,na.rm=T)/sqrt(sum(!is.na(Coverage))))%>%
  ungroup()%>%data.frame

ggplot(SumData,aes(x=Month,y=MeanCov,group="all"))+geom_point()+geom_line(stat="identity")+
  geom_errorbar(aes(ymin=MeanCov-seCov,ymax=MeanCov+seCov),width=0.2)+
  theme_bw()
