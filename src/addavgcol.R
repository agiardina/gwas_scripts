library("optparse")
library("ggplot2")
library("ggforce")
library("concaveman")


option_list = list(
  make_option(c("-i","--input"), type="character", default=NULL,
              help="Input file", metavar="character"),    
  make_option(c("--cols"), type="character", default=NULL,
              help="Comma separated columns to calculate the average", metavar="character"),
  make_option(c("--name"), type="character", default=NULL, 
              help="Name of the new column to add", metavar="character")
)

opt_parser <- OptionParser(option_list=option_list);
opt <- parse_args(opt_parser);

cols <- unlist(strsplit(opt$cols, ","))
df <- read.table(opt$input,header=TRUE)
df[,opt$name] <- (df[,cols[1]] + df[,cols[2]])/2
write.table(df,opt$input,row.names=FALSE,quote=FALSE)
