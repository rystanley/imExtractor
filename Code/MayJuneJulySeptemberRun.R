#Load library
library(EBImage)

#Source functions
source("c:/Users/StanleyR/Documents/Github/imExtractor/Code/ImageProcess2.R")
source("c:/Users/StanleyR/Documents/Github/imExtractor/Code/ImageBatchProcess.R")

rootdir <- "c:/Users/StanleyR/Documents/Gonad Analysis/"
setwd(rootdir)

Folders <- dir(rootdir)
Folders <- Folders[grep("2016",Folders)]

Output <- NULL

for(i in Folders){

  setwd(paste0(rootdir,i))
  
  subfolders <- dir()
  
      for(j in subfolders){
        
        subfoldername <- unlist(strsplit(j[1]," "))[3]
        month <- unlist(strsplit(j[1]," "))[4]
        year <- unlist(strsplit(j[1]," "))[5]
        
        tempout <- ImageBatchProcess(folder=paste0(rootdir,i,"/",j),
                                     month=month,year=year,code=subfoldername)
        
        write.csv(tempout,paste0(rootdir,i,"/",j,"Output.csv"),row.names = FALSE)
        
        Output <- rbind(Output,tempout)
      } # end of j subfolders
    
} #end of i folders

save.image("c:/Users/StanleyR/Documents/Gonad Analysis/ImageAnalysisOutput.RData")

Output[Output$Month == "september","Month"] = "September"

write.csv(Output,"c:/Users/StanleyR/Documents/Gonad Analysis/ImageOutput_MayJuneJuly_September.csv",row.names = F)
