working_dir<-commandArgs(trailingOnly=TRUE)[1]
maf_freq <- read.table(paste(working_dir,"/MAF_check.frq",sep=""), header =TRUE, as.is=T)
pdf(paste(working_dir,"MAF_distribution.pdf",sep=""))
hist(maf_freq[,5],main = "MAF distribution", xlab = "MAF")
dev.off()
