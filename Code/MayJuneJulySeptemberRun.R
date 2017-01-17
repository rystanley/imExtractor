#Load libraries
library(EBImage)
library(RCurl)


#Load the function from github ----------------
script <- getURL("https://raw.githubusercontent.com/rystanley/imExtractor/master/Code/ImageBatchProcess.R", ssl.verifypeer = FALSE)
eval(parse(text = script),envir=.GlobalEnv);rm(script)

script <- getURL("https://raw.githubusercontent.com/rystanley/imExtractor/master/Code/ImageProcess.R", ssl.verifypeer = FALSE)
eval(parse(text = script),envir=.GlobalEnv);rm(script)

#set up root directory 
rootdir <- "c:/Users/StanleyR/Documents/Gonad Analysis/" # directory where the montly folders (e.g. July which holds BCD .. ..)
setwd(rootdir)

#These are the folders which the loop will go through and process
Folders <- dir(rootdir)

# make sure the Folders listed are only the monthly folders which each contain sub-folders for monthly replicates (e.g. SAD and BCD).
# note: make sure the sub-folders of each folder only contain .tifs which is what the loop will process
Folders 

#Set up a dummy variable for copying
Output <- NULL

for(i in Folders){

  setwd(paste0(rootdir,i))
  
  subfolders <- dir()
  
      for(j in subfolders){
        
        #Strip out meta information from the sub-folder (Month,Year and Acronym)
        subfoldername <- unlist(strsplit(j[1]," "))[3]
        month <- unlist(strsplit(j[1]," "))[4]
        year <- unlist(strsplit(j[1]," "))[5]
        
        tempout <- ImageBatchProcess(folder=paste0(rootdir,i,"/",j),
                                     month=month,year=year,code=subfoldername) #Process the images. Note if you would like to change any parameter do it here. 
        
        write.csv(tempout,paste0(rootdir,i,"/",j,"Output.csv"),row.names = FALSE) #print a subset output for each sub-folder
        
        Output <- rbind(Output,tempout)
      } # end of j subfolders
    
} #end of i folders

save.image(paste0(rootdir,"ImageAnalysisOutput.RData")) # 

Output[Output$Month == "september","Month"] = "September" #some of the months lower and upper case names

#Save final output csv
write.csv(Output,paste0(rootdir,"ImageOutput_MayJuneJuly_September.csv"),row.names = F)
