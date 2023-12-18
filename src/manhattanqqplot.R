library("optparse")
#install.packages("devtools")
#library(devtools)
#devtools::install_github('kaustubhad/fastman',build_vignettes = TRUE)
library(fastman)
#install.packages('Cairo')
library(Cairo)


option_list = list(
  make_option(c("-i","--input"), type="character", default=NULL,
              help="Association input file", metavar="character"),
  make_option(c("-o", "--out"), type="character", default=NULL, 
              help="Output prefix", metavar="character")
)

opt_parser <- OptionParser(option_list=option_list);
opt <- parse_args(opt_parser);

CairoPNG(sprintf("%s_manhattan.png",opt$out), width=10, height=6, units="in", res=300)
m<-read.table(opt$input,header=TRUE,stringsAsFactors=FALSE)
m<-na.omit(m)
head(m)
fastman(m,annotatePval=1E-5, geneannotate = TRUE, build = 37,annotateN = 10)
dev.off()

CairoPNG(sprintf("%s_qq.png",opt$out), width=10, height=6, units="in", res=300)
fastqq(m$P)
dev.off()
