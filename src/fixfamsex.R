library("optparse")

option_list = list(
  make_option(c("--phenotype"), type="character", default=NULL,
              help="Phenotype file", metavar="character"),
  make_option(c("--sex"), type="character", default=NULL,
              help="Sex column in the phenotype file", metavar="character"),
  make_option(c("--fam"), type="character", default=NULL,
              help="Fam file to fix", metavar="character")
)
opt_parser <- OptionParser(option_list=option_list);
opt <- parse_args(opt_parser);

df_fam<-read.table(opt$fam)
df_pheno<-read.table(opt$phenotype,header=TRUE)
sex_col <- opt$sex

n_rows <- dim(df_fam)[1]

for (i in 1:n_rows) {
  iid <- df_fam[i,"V2"] 
  sex <- toupper(df_pheno[df_pheno$IID == iid,sex_col])
  
  if (sex == "M") {
    df_fam[i,"V5"] <- 1
  } else if (sex == "F") {
      df_fam[i,"V5"] <- 2
  } else {
    df_fam[i,"V5"] <- 0
  }
}

write.table(df_fam,opt$fam,quote=FALSE,row.names=FALSE,col.names=FALSE)
