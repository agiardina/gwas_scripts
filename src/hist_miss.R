working_dir<-commandArgs(trailingOnly=TRUE)[1]
indmiss<-read.table(file=paste(working_dir,"/plink.imiss",sep=""), header=TRUE)
snpmiss<-read.table(file=paste(working_dir,"/plink.lmiss",sep=""), header=TRUE)
# read data into R 

pdf(paste(working_dir,"/histimiss.pdf",sep="")) #indicates pdf format and gives title to file
hist(indmiss[,6],main="Histogram individual missingness") #selects column 6, names header of file

pdf(paste(working_dir,"/histlmiss.pdf",sep=""))
hist(snpmiss[,5],main="Histogram SNP missingness")  
dev.off() # shuts down the current device
