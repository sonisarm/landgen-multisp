library(gdistance)
library(PopGenReport)
library(raster)
library(ResistanceGA)
library(dplyr)

# Input data, specific to species:
print("Defining input data...") # specific per species
data_csv="coord.csv"
data_gen="gd.gdv"
n <- 150
r <-1


print("Loading data...")

load(paste0("bio1_r", r, ".rda"))
bio1 <- Slope_one

load(paste0("bio2_r", r, ".rda"))
bio2 <- Slope_one

load(paste0("bio12_r", r, ".rda"))
bio12 <- Slope_one

load(paste0("bio18_r", r, ".rda"))
bio18 <- Slope_one

load(paste0("slope_r", r, ".rda"))
slope <- Slope_one

load(paste0("profcurv_r", r, ".rda"))
profcurv <- Slope_one

load(paste0("enm_r", r, ".rda"))
enm <- Slope_one

load(paste0("wspeed_r", r, ".rda"))
wspeed <- Slope_one

load(paste0("wturb_r", r, ".rda"))
wturb <- Slope_one

print("loading coordinate and genetic data...")
gd <- as.matrix(read.table(data_gen, header=TRUE, sep="\t", row.names = 1))

pts<-read.csv(data_csv, sep=';')
pts<-pts[c("ID", "X", "Y")]

ids <- pts$ID
vids <- intersect(ids, rownames(gd))
gdi <- gd[vids, vids]

# If your matrix represents genetic similarity, convert it to a genetic distance matrix before analysis:
gdi <- 1-gdi

colnames(gdi)<-NULL
rownames(gdi)<-NULL
response<-gdi


mat.list <- c(bio1$cd, bio2$cd, bio12$cd, bio18$cd, slope$cd, profcurv$cd, enm$cd, wspeed$cd, wturb$cd, enm$cd)
k <- rbind(bio1$k, bio2$k, bio12$k, bio18$k, slope$k, profcurv$k, enm$k, wspeed$k, wturb$k, enm$k)


AIC.boot <- Resist.boot(mod.names = names(mat.list), dist.mat = mat.list,
                                 n.parameters = k[,2], 
                                 sample.prop = 0.75, 
                                 iters = 10000, 
                                 obs = n, genetic.mat = response)

save(AIC.boot, file = "AIC_run", r, ".rda")
print(AIC.boot)



