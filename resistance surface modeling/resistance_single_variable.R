library(gdistance)
library(PopGenReport)
library(raster)
library(ResistanceGA)
library(dplyr)

args <- commandArgs(trailingOnly = TRUE)
#commandArgs() is a base R function that retrieves the command-line arguments passed to the R session or R script.


workdir="/lustre/ssarmiento/resistance"
setwd(workdir)
# Input data, specific to species:
data_csv="coords.csv"
data_gen="gd.csv"
n <- 150 # number of individuals 

# input data, common for all species:
r <- 1  # run number
var <- args[1] # we used bio1, bio2, bio12, bio18, slope, profile curvature, wind speed and turbulence
print(paste("processed layer:", var))


print("loading_raster")
raster_dir=raster(paste0("/lustre/ssarmiento/resistance/", var, ".asc")) # bio1, bio2, bio12, bio18, slope, profcurv, wind speed, wind turbulence or enm

print("loading data")
# read genetic data
gdunf <- as.matrix(read.table(data_gen, header=TRUE, sep="\t", row.names = 1))
nrow(gdunf)
ncol(gdunf)

# read coordinates
pts<-read.csv(data_csv, sep=';')
pts<-pts[c("ID", "X", "Y")]
nrow(pts)
pts <- na.omit(pts)
pts$X <- as.numeric(as.character(pts$X))
pts$Y <- as.numeric(as.character(pts$Y))
nrow(pts)

# match ids between coords + genetic data
ids <- unique(pts$ID) 
vids <- intersect(ids, rownames(gdunf))
gd <- gdunf[vids, vids]  

pts<- pts %>% dplyr::filter(ID %in% rownames(gd))
pts <- unique(pts)
nrow(pts)

print("after filtration:")
nrow(gd)
ncol(gd)

# If your matrix represents genetic similarity, convert it to a genetic distance matrix before analysis:
gd <- 1-gd

pts<-SpatialPoints( pts[,2:3])
plot(pts)

print("creating working directory")
write.dir <- paste0("run", r, "_", var, "/") # r is defined above (run number; we ran the whole process twice)
if (!dir.exists(write.dir)) {
  dir.create(write.dir, recursive = TRUE)
}


GA.inputs<-GA.prep(method="AIC", ASCII.dir=raster_dir,Results.dir=write.dir, select.trans = list("A")) 
GA.inputs$parallel=20

print("continue processing layer:")
GA.inputs$layer.names

print("preparing_gdist")
gdist.inputs<-gdist.prep(n.Pops=length(pts), samples=pts, response=lower(gd), method="commuteDistance")

print("preparing_ss_optim")
Slope_one<-SS_optim(gdist.inputs=gdist.inputs, GA.inputs=GA.inputs)

print("saving_Slope_one")
save(Slope_one, file=paste0(var, "_one.rda"))

mat.list<-Slope_one$cd
k<-rbind(Slope_one$k)
k
colnames(gd)<-NULL
rownames(gd)<-NULL
response<-gd

print("generating_boots")
BOOTS.Slope_one<-Resist.boot(mod.names=names(mat.list), dist.mat=mat.list, n.parameters=k[,2], sample.prop = 0.75, iters = 10000, obs=n, genetic.mat=response)

print("saving_boots")
save(BOOTS.Slope_one, file=paste0("BOOTS.", var, "_one.rda"))
BOOTS.Slope_one



