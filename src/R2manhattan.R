library("fastman")
library("Cairo")
library("optparse")

option_list = list(
  make_option(c("-i", "--input"), type="character", default=NULL, 
              help="Association file", metavar="character"),
  make_option(c("-o", "--out"), type="character", default="r2_manhattan.png", 
              help="Path of the png file", metavar="character")
); 

opt_parser <- OptionParser(option_list=option_list);
opt <- parse_args(opt_parser);


df = read.table(opt$input,header=TRUE)

CairoPNG(opt$out, width=10, height=6, units="in", res=300)
fastman(df, p="R2", maxP=NULL, logp = FALSE, suggestiveline = 0.005, genomewideline = 0.01, annotatePval=1E-5, geneannotate = TRUE, build = 37)
dev.off()