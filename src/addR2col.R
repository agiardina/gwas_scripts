library("optparse")

option_list = list(
  make_option(c("-i","--input"), type="character", default=NULL,
              help="Association input file", metavar="character"),
  make_option(c("--ncovars"), type="integer", default=NULL, 
              help="Number of covars", metavar="number")
)

opt_parser <- OptionParser(option_list=option_list)
opt <- parse_args(opt_parser);

df <- read.table(opt$input,header=TRUE)
attach(df)

R2 <- STAT^2 / (STAT^2 + NMISS - opt$ncovars)
df$R2 <- R2
write.table(df,opt$input,row.names=FALSE,quote=FALSE)