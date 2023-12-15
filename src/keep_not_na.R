library("optparse")

option_list = list(
  make_option(c("-i", "--input"), type="character", default=NULL, 
              help="Input csv file", metavar="character"),
  make_option(c("-o", "--out"), type="character", default="out.txt", 
              help="Output csv [default= %default]", metavar="character"),
  make_option(c("--fid"), type="character", default=NULL, 
                            help="Family ID field. If Family ID is not passed over the FID field will be set to 0", metavar="character"),
  make_option(c("--iid"), type="character", default=NULL, 
                            help="Individual ID field", metavar="character"),
  make_option(c("--cols"), type="character", default=NULL, 
                            help="Comma separated list of cols to check for NA values", metavar="character")
  
); 

opt_parser <- OptionParser(option_list=option_list);
opt <- parse_args(opt_parser);
cols <- unlist(strsplit(opt$cols, ","))
df <- read.csv(opt$input)
for (col in cols) {
  df <- df[!is.na(df[,col]),] 
}

if (is.null(opt$fid)) {
  df[,"FID"] <- 0
  fid_col <- "FID"
} else {
  fid_col <- opt$fid
}

df <- df[,c(fid_col,opt$iid)]
write.table(df, file=opt$out, row.names = FALSE, col.names = FALSE, quote=FALSE)