library("optparse")
library("ggplot2")
library("ggforce")
library("concaveman")


option_list = list(
  make_option(c("-i","--input"), type="character", default=NULL,
              help="File with PCs. The PC columns must be named PC1, PC2, ..., PCN", metavar="character"),
  make_option(c("-o", "--out"), type="character", default=NULL, 
              help="Output folder", metavar="character"),
  make_option(c("--group"), type="character", default=NULL,
              help="Column name to color points", metavar="character"),
  make_option(c("-n", "--npcs"), type="integer", default=5,
              help="Number of principal component to plot", metavar="integer")
  
)

opt_parser <- OptionParser(option_list=option_list);
opt <- parse_args(opt_parser);

group_col <- opt$group
data <- read.csv(opt$input)
print(colnames(data))
for (i in seq(1,opt$npcs-1)) {
  pc_x <- paste("PC",i,sep="") 
  pc_y <- paste("PC",i+1,sep="")


  plt=ggplot(data,aes(x=!!sym(pc_x), y=!!sym(pc_y), colour=!!sym(group_col),fill=!!sym(group_col),shape=!!sym(group_col),label=!!sym(group_col))) + 
        geom_point(size=2,shape=20) + 
        geom_mark_hull(
          expand=0, 
          radius=0, 
          concavity=100, 
          alpha = 0.15, 
          con.cap = 0, 
          con.colour = "grey70", 
          label.fontsize = 8,
          label.fontface="plain", 
          label.colour = "grey40", 
          label.buffer = unit(0, "mm"), 
          label.margin = ggplot2::margin(1, 1, 1, 1, "mm")) +
        scale_shape_manual(values=47:58) +
        xlab(pc_x) + ylab(pc_y)+theme_light() +
        theme(
          panel.grid.major = element_blank(), 
          panel.grid.minor = element_blank()
          ) ; # also show group names within plot using ggforce
  png_file <- sprintf("%s/%s_%s_%s_hull.png", opt$out, pc_x, pc_y, group_col)
  print(png_file)
  ggsave(plt, filename = png_file, dpi = 300, width = 8, height = 7, units = 'in', type = 'cairo', bg='white');
}
