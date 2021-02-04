##############################################################################################################
# 
# 
# Program to plot Cycles simulations by US county throughout the US
# 
#    
# 
# 
#  Felipe Montes 2021/01/23
# 
# 
# 
# 
############################################################################################################### 



###############################################################################################################
#                             Tell the program where the package libraries are stored                        
###############################################################################################################


#  Tell the program where the package libraries are  #####################

.libPaths("C:/Felipe/SotwareANDCoding/R_Library/library")  ;


###############################################################################################################
#                             Setting up working directory  Loading Packages and Setting up working directory                        
###############################################################################################################


#      set the working directory

# readClipboard()

setwd("C:\\Felipe\\Students Projects\\Mandy's Project\\2021") ;   # 



###############################################################################################################
#                            Install the packages that are needed                       
###############################################################################################################




###############################################################################################################
#                           load the libraries that are needed   
###############################################################################################################

library(openxlsx)

library(lattice)

library(rgdal)

library(raster)

library(sp)



###############################################################################################################
#                           load the files the will be needed  
###############################################################################################################

## Load US Counties Shape File

ogrInfo("C:\\Felipe\\Students Projects\\Mandy's Project\\2021\\CountyShapefiles\\tl_2019_us_countyONLYCONUS.shp") ;

USCounties<-readOGR("C:\\Felipe\\Students Projects\\Mandy's Project\\2021\\CountyShapefiles\\tl_2019_us_countyONLYCONUS.shp") ;


# plot(USCounties)



## load control file for the simulations US_corn_scenarions.txt


ControlFile<-read.table("C:\\Felipe\\Students Projects\\Mandy's Project\\2021\\20210119_Ch4_Cycles_simsfor_felipe\\20210119_Ch4_Cycles_sims\\input\\US_corn_scenarios.txt", header = T, sep= "\t", as.is=T) ;

str(ControlFile)

head(ControlFile$SIM_CODE)

## Extract the first part of the SIM_CODE without the PT

ControlFile$SIM_CODE_P1<-sapply(strsplit(sapply(strsplit(ControlFile$SIM_CODE,split="_"), function(x) x[1] ),split="T"),function(x) x[2]);

## Extract the second part of the SIM_CODE without the corn

ControlFile$SIM_CODE_P2<-sapply(strsplit(ControlFile$SIM_CODE,split="_"), function(x) x[2] ) ;




# Load shape file with counties points and soil information

CountyPTs_12_02_20<-readOGR("C:\\Felipe\\Students Projects\\Mandy's Project\\2021\\Point_Locations\\Point_Locations\\CountyPTs_12_02_20\\CountyPTs_12_02_20.shp")  ;

View(CountyPTs_12_02_20@data)

str(CountyPTs_12_02_20@data)

## form the SIM_CODE by combining  the SoilLarges and Mukey Mukeys 

CountyPTs_12_02_20@data$SIM_CODE<-paste0("PT", CountyPTs_12_02_20@data$SoilLarges ,"_", CountyPTs_12_02_20@data$MUKEY , "_Corn") ;

head(ControlFile$SIM_CODE)

## Compare with the SIM_CODE in the control files

ControlFile$SIM_CODE_KEY<-sapply(strsplit(ControlFile$SIM_CODE,split="_C"), function(x) x[1]) ;


ControlFile$SIM_CODE %in% CountyPTs_12_02_20@data$SIM_CODE 

## looks very good!!



###############################################################################################################
#                            Load the files with the simulation results for the Poly Culture
###############################################################################################################


read.xlsx("C:\\Felipe\\Students Projects\\Mandy's Project\\2021\\Re _Modeling_Outputs\\Poly_summary.xlsx", sheet="Poly_biomass", startRow = 1, colNames = F, rowNames = F, rows=c(seq(1,81)), cols=c(1,2)  )


RES.NAMES<-read.xlsx("C:\\Felipe\\Students Projects\\Mandy's Project\\2021\\Re _Modeling_Outputs\\Poly_summary.xlsx", sheet="Poly_biomass", startRow = 1, colNames = F, rowNames = F, rows= c(1,2,3)) ;

# View(POLY_total__harvested_yields.1)

# str(POLY_total__harvested_yields.1)



Res.YEAR<-read.xlsx("C:\\Felipe\\Students Projects\\Mandy's Project\\2021\\Re _Modeling_Outputs\\Poly_summary.xlsx", sheet="Poly_biomass", startRow = 4, colNames = F, rowNames = F, cols=c(1)) ;

names(Res.YEAR)<-c("YEAR") ;



Res.CROP<-read.xlsx("C:\\Felipe\\Students Projects\\Mandy's Project\\2021\\Re _Modeling_Outputs\\Poly_summary.xlsx", sheet="Poly_biomass", startRow = 4, colNames = F, rowNames = F, cols=c(2)) ;

Res.CROP[,1]<-gsub(" ", "", Res.CROP[,1] ) ;

names(Res.CROP)<-c("CROP") ;


Res.G_F_YIELD<-gsub(" ", "", RES.NAMES[2,seq(from = 3, to = dim.data.frame(RES.NAMES)[2], by=1)]) ;

Res.SIM_CODE<-gsub(" ", "", RES.NAMES[1,seq(from = 3, to = dim.data.frame(RES.NAMES)[2], by=1)]);

Res.Data<-read.xlsx("C:\\Felipe\\Students Projects\\Mandy's Project\\2021\\Re _Modeling_Outputs\\Poly_summary.xlsx", sheet="Poly_biomass", startRow = 4, colNames = F, rowNames = F, cols=seq(from = 3, to = dim.data.frame(RES.NAMES)[2], by=1)) ;
  

SMIULATIONS<-unique(unlist(Res.SIM_CODE))

Res.Data[,which(Res.SIM_CODE == SMIULATIONS[1])]  ;



Mapping.Data.POLY<-list() ;



for (i in SMIULATIONS ){
  
  # i = SMIULATIONS[1] ; i
  
  Temporary.DataF<-data.frame(Res.YEAR,Res.CROP,Res.Data[,which(Res.SIM_CODE == i) ] ) ;
  
  names(Temporary.DataF)[seq(3,dim.data.frame(Temporary.DataF)[2])]<-Res.G_F_YIELD[which(Res.SIM_CODE == i)] ;
  
  Temporary.DataF.Maize<-Temporary.DataF[which(Temporary.DataF$CROP == "MaizeRM90"),] ;
  
  Temporary.DataF.Sorgh<-Temporary.DataF[which(Temporary.DataF$CROP == "SorghumRM90"),] ;
  
  Temporary.DataF.Maize_Sorgh<-merge(Temporary.DataF.Maize, Temporary.DataF.Sorgh, by="YEAR") ;
  
  Temporary.DataF.Maize_Sorgh$TOTAL<-Temporary.DataF.Maize_Sorgh[,c("GRAINYIELD.x")] + Temporary.DataF.Maize_Sorgh[,c("FORAGEYIELD.x")] + Temporary.DataF.Maize_Sorgh[,c("GRAINYIELD.y")] + Temporary.DataF.Maize_Sorgh[,c("FORAGEYIELD.y")] ;
  
  Mapping.Data.POLY[[i]]<-Temporary.DataF.Maize_Sorgh  ;
  
  rm(Temporary.DataF,Temporary.DataF.Maize,Temporary.DataF.Sorgh,Temporary.DataF.Maize_Sorgh  )  ;
  
}



### Plot Mean (average) Total Forage Yield(Grain + forage)  across counties

Res.avg.Forage.1<-sapply(Mapping.Data.POLY, function(x) mean(x[,c("TOTAL")])) ;

Res.avg.Forage.2<-data.frame(names(Res.avg.Forage.1),unname(Res.avg.Forage.1)) ;

names(Res.avg.Forage.2)<-c("SIM_CODE", "AVG_FORAGE_YIELD") ;

# there are duplicates generated in the CountyPTs_12_02_20@data$SIM_CODE

which(duplicated(CountyPTs_12_02_20@data$SIM_CODE))

Res.avg.Forage.3<-merge(CountyPTs_12_02_20@data[-which(duplicated(CountyPTs_12_02_20@data$SIM_CODE)),],Res.avg.Forage.2) [,c("GEOID","SIM_CODE", "AVG_FORAGE_YIELD")] ;

str(Res.avg.Forage.3)

#there are two GEOID duplicates

which(duplicated(Res.avg.Forage.3$GEOID))

# remove the duplicates

Res.avg.Forage.4<-Res.avg.Forage.3[-which(duplicated(Res.avg.Forage.3$GEOID)),] ;

str(Res.avg.Forage.4)

Res.avg.Forage.5<-sp::merge(USCounties[],Res.avg.Forage.4, by.x= "GEOID",by.y="GEOID", all.x=T );

str(Res.avg.Forage.5)


writeOGR(Res.avg.Forage.5, "C:\\Felipe\\Students Projects\\Mandy's Project\\2021\\GeneratedMapsShapeFiles\\Poly_avg.shp", layer="Poly_avg", driver="ESRI Shapefile" ) ;



### Plot Standard Deviation of Total Forage Yield (grain + forage) across counties


Res.SD.Forage.1<-sapply(Mapping.Data.POLY, function(x) sd(x[,c("TOTAL")])) ;

Res.SD.Forage.2<-data.frame(names(Res.SD.Forage.1),unname(Res.SD.Forage.1)) ;

names(Res.SD.Forage.2)<-c("SIM_CODE", "SD_FORAGE_YIELD") ;


# there are duplicates generated in the CountyPTs_12_02_20@data$SIM_CODE

which(duplicated(CountyPTs_12_02_20@data$SIM_CODE))

Res.SD.Forage.3<-merge(CountyPTs_12_02_20@data[-which(duplicated(CountyPTs_12_02_20@data$SIM_CODE)),],Res.SD.Forage.2) [,c("GEOID","SIM_CODE", "SD_FORAGE_YIELD")] ;

str(Res.SD.Forage.3)

#there are two GEOID duplicates

which(duplicated(Res.SD.Forage.3$GEOID))

# remove the duplicates


Res.SD.Forage.4<-Res.SD.Forage.3[-which(duplicated(Res.SD.Forage.3$GEOID)),] ;

str(Res.SD.Forage.4)

Res.SD.Forage.5<-sp::merge(USCounties,Res.SD.Forage.4, by.x= "GEOID",by.y="GEOID", all.x=T );

str(Res.SD.Forage.5)


writeOGR(Res.SD.Forage.5, "C:\\Felipe\\Students Projects\\Mandy's Project\\2021\\GeneratedMapsShapeFiles\\Poly_std.shp", layer="Poly_std", driver="ESRI Shapefile" ) ;


### Plot Coefficient of variation of Total Forage Yield (grain + forage) across counties for the Poly culture simulations

str(Res.SD.Forage.2)

str(Res.avg.Forage.2)

Res.Poly.CV<-merge(Res.avg.Forage.2,Res.SD.Forage.2, by= "SIM_CODE")  ;

str(Res.Poly.CV)

Res.Poly.CV$CV.ForageYield<-Res.Poly.CV$SD_FORAGE_YIELD/Res.Poly.CV$AVG_FORAGE_YIELD  ;




Res.Poly.CV.1<-merge(CountyPTs_12_02_20@data[-which(duplicated(CountyPTs_12_02_20@data$SIM_CODE)),],Res.Poly.CV) [,c("GEOID","SIM_CODE","AVG_FORAGE_YIELD" ,"SD_FORAGE_YIELD",  "CV.ForageYield")] ;

str(Res.Poly.CV.1)

#there are two GEOID duplicates

which(duplicated(Res.Poly.CV.1$GEOID))

# remove the duplicates


Res.Poly.CV.2<-Res.Poly.CV.1[-which(duplicated(Res.Poly.CV.1$GEOID)),] ;

str(Res.Poly.CV.2)

Res.Poly.CV.3<-sp::merge(USCounties,Res.Poly.CV.2 ,  by.x= "GEOID",by.y="GEOID", all.x=T );

str(Res.Poly.CV.3)

writeOGR(Res.Poly.CV.3, "C:\\Felipe\\Students Projects\\Mandy's Project\\2021\\GeneratedMapsShapeFiles\\Poly_CV.shp", layer="Poly_CV", driver="ESRI Shapefile" ) ;

###############################################################################################################
#                            Load the files with the simulation results for the Sorghum
###############################################################################################################


read.xlsx("C:\\Felipe\\Students Projects\\Mandy's Project\\2021\\Re _Modeling_Outputs\\Sorghum_summary.xlsx", sheet="Sorghum_biomass", startRow = 1, colNames = F, rowNames = F, rows=c(seq(1,81)), cols=c(1,2)  )


RES.NAMES.SORG<-read.xlsx("C:\\Felipe\\Students Projects\\Mandy's Project\\2021\\Re _Modeling_Outputs\\Sorghum_summary.xlsx", sheet="Sorghum_biomass", startRow = 1, colNames = F, rowNames = F, rows= c(1,2,3)) ;

# View(POLY_total__harvested_yields.1)

# str(POLY_total__harvested_yields.1)



Res.YEAR.SORG<-read.xlsx("C:\\Felipe\\Students Projects\\Mandy's Project\\2021\\Re _Modeling_Outputs\\Sorghum_summary.xlsx", sheet="Sorghum_biomass", startRow = 4, colNames = F, rowNames = F, cols=c(1)) ;

names(Res.YEAR.SORG)<-c("YEAR") ;



Res.CROP.SORG<-read.xlsx("C:\\Felipe\\Students Projects\\Mandy's Project\\2021\\Re _Modeling_Outputs\\Sorghum_summary.xlsx", sheet="Sorghum_biomass", startRow = 4, colNames = F, rowNames = F, cols=c(2)) ;

Res.CROP.SORG[,1]<-gsub(" ", "", Res.CROP.SORG[,1] ) ;

names(Res.CROP.SORG)<-c("CROP") ;


Res.CROP.YIELD.SORG<-gsub(" ", "", RES.NAMES.SORG[2,seq(from = 3, to = dim.data.frame(RES.NAMES.SORG)[2], by=1)]) ;

Res.SIM_CODE.SORG<-gsub(" ", "", RES.NAMES.SORG[1,seq(from = 3, to = dim.data.frame(RES.NAMES.SORG)[2], by=1)]);

Res.Data.SORG<-read.xlsx("C:\\Felipe\\Students Projects\\Mandy's Project\\2021\\Re _Modeling_Outputs\\Sorghum_summary.xlsx", sheet="Sorghum_biomass", startRow = 4, colNames = F, rowNames = F, cols=seq(from = 3, to = dim.data.frame(RES.NAMES.SORG)[2], by=1)) ;


SMIULATIONS.SORG<-unique(unlist(Res.SIM_CODE.SORG))

Res.Data.SORG[,which(Res.SIM_CODE.SORG == SMIULATIONS.SORG[1])]  ;



Mapping.Data.SORG<-list() ;



for (i in SMIULATIONS.SORG ){
  
  # i = SMIULATIONS.SORG[1] ; i
  
  Temporary.DataF<-data.frame(Res.YEAR.SORG,Res.CROP.SORG,Res.Data.SORG[,which(Res.SIM_CODE.SORG == i) ] ) ;
  
  names(Temporary.DataF)[seq(3,dim.data.frame(Temporary.DataF)[2])]<-Res.CROP.YIELD.SORG[which(Res.SIM_CODE.SORG == i)] ;
  
  
  Mapping.Data.SORG[[i]]<-Temporary.DataF  ;
  
  rm(Temporary.DataF)  ;
  
}



### Plot Mean (average) Total Forage Yield(Grain + forage)  across counties

Res.avg.SORG.1<-sapply(Mapping.Data.SORG, function(x) mean(x[,c("GRAINYIELD")] + x[,c("FORAGEYIELD")])) ;  

Res.avg.SORG.2<-data.frame(names(Res.avg.SORG.1),unname(Res.avg.SORG.1)) ;

names(Res.avg.SORG.2)<-c("SIM_CODE", "AVG_FORAGE_YIELD") ;

# there are duplicates generated in the CountyPTs_12_02_20@data$SIM_CODE

which(duplicated(CountyPTs_12_02_20@data$SIM_CODE))

Res.avg.SORG.3<-merge(CountyPTs_12_02_20@data[-which(duplicated(CountyPTs_12_02_20@data$SIM_CODE)),],Res.avg.SORG.2) [,c("GEOID","SIM_CODE", "AVG_FORAGE_YIELD")] ;

str(Res.avg.SORG.3)

#there are two GEOID duplicates

which(duplicated(Res.avg.SORG.3$GEOID))

# remove the duplicates

Res.avg.SORG.4<-Res.avg.SORG.3[-which(duplicated(Res.avg.SORG.3$GEOID)),] ;

str(Res.avg.SORG.4)

Res.avg.SORG.5<-sp::merge(USCounties[],Res.avg.SORG.4, by.x= "GEOID",by.y="GEOID", all.x=T );

str(Res.avg.SORG.5)


writeOGR(Res.avg.SORG.5, "C:\\Felipe\\Students Projects\\Mandy's Project\\2021\\GeneratedMapsShapeFiles\\SORGHUM_avg.shp", layer="SORGHUM_avg", driver="ESRI Shapefile" ) ;



### Plot Standard Deviation of Total Forage Yield (grain + forage) across counties


Res.SD.SORG.1<-sapply(Mapping.Data.SORG, function(x) sd(x[,c("GRAINYIELD")] + x[,c("FORAGEYIELD")])) ;

Res.SD.SORG.2<-data.frame(names(Res.SD.SORG.1),unname(Res.SD.SORG.1)) ;

names(Res.SD.SORG.2)<-c("SIM_CODE", "SD_FORAGE_YIELD") ;


# there are duplicates generated in the CountyPTs_12_02_20@data$SIM_CODE

which(duplicated(CountyPTs_12_02_20@data$SIM_CODE))

Res.SD.SORG.3<-merge(CountyPTs_12_02_20@data[-which(duplicated(CountyPTs_12_02_20@data$SIM_CODE)),],Res.SD.SORG.2) [,c("GEOID","SIM_CODE", "SD_FORAGE_YIELD")] ;

str(Res.SD.SORG.3)

#there are two GEOID duplicates

which(duplicated(Res.SD.SORG.3$GEOID))

# remove the duplicates


Res.SD.SORG.4<-Res.SD.SORG.3[-which(duplicated(Res.SD.SORG.3$GEOID)),] ;

str(Res.SD.SORG.4)

Res.SD.SORG.5<-sp::merge(USCounties[],Res.SD.SORG.4, by.x= "GEOID",by.y="GEOID", all.x=T );

str(Res.SD.SORG.5)


writeOGR(Res.SD.SORG.5, "C:\\Felipe\\Students Projects\\Mandy's Project\\2021\\GeneratedMapsShapeFiles\\SORGHUM_std.shp", layer="SORGHUM_std", driver="ESRI Shapefile" ) ;


### Plot Coefficient of variation of Total Forage Yield (grain + forage) across counties for the Sorghum simulations

str(Res.SD.SORG.2)

str(Res.avg.SORG.2)

Res.SORG.CV<-merge(Res.avg.SORG.2,Res.SD.SORG.2, by= "SIM_CODE")  ;

str(Res.SORG.CV)

Res.SORG.CV$CV.ForageYield<-Res.SORG.CV$SD_FORAGE_YIELD/Res.SORG.CV$AVG_FORAGE_YIELD  ;



Res.SORG.CV.1<-merge(CountyPTs_12_02_20@data[-which(duplicated(CountyPTs_12_02_20@data$SIM_CODE)),],Res.SORG.CV) [,c("GEOID","SIM_CODE","AVG_FORAGE_YIELD" ,"SD_FORAGE_YIELD",  "CV.ForageYield")] ;

str(Res.SORG.CV.1)

#there are two GEOID duplicates

which(duplicated(Res.SORG.CV.1$GEOID))

# remove the duplicates


Res.SORG.CV.2<-Res.SORG.CV.1[-which(duplicated(Res.SORG.CV.1$GEOID)),] ;

str(Res.SORG.CV.2)

Res.SORG.CV.3<-sp::merge(USCounties,Res.SORG.CV.2 ,  by.x= "GEOID",by.y="GEOID", all.x=T );

str(Res.SORG.CV.3)

writeOGR(Res.SORG.CV.3, "C:\\Felipe\\Students Projects\\Mandy's Project\\2021\\GeneratedMapsShapeFiles\\SORGHUM_CV.shp", layer="SORGHUM_CV", driver="ESRI Shapefile" ) ;





###############################################################################################################
#                            Load the files with the simulation results for the Maize
###############################################################################################################


read.xlsx("C:\\Felipe\\Students Projects\\Mandy's Project\\2021\\Re _Modeling_Outputs\\Maize_summary.xlsx", sheet="Maize_biomass", startRow = 1, colNames = F, rowNames = F, rows=c(seq(1,81)), cols=c(1,2)  )


RES.NAMES.MAIZE<-read.xlsx("C:\\Felipe\\Students Projects\\Mandy's Project\\2021\\Re _Modeling_Outputs\\Maize_summary.xlsx", sheet="Maize_biomass", startRow = 1, colNames = F, rowNames = F, rows= c(1,2,3)) ;

# View(POLY_total__harvested_yields.1)

# str(POLY_total__harvested_yields.1)



Res.YEAR.MAIZE<-read.xlsx("C:\\Felipe\\Students Projects\\Mandy's Project\\2021\\Re _Modeling_Outputs\\Maize_summary.xlsx", sheet="Maize_biomass", startRow = 4, colNames = F, rowNames = F, cols=c(1)) ;

names(Res.YEAR.MAIZE)<-c("YEAR") ;



Res.CROP.MAIZE<-read.xlsx("C:\\Felipe\\Students Projects\\Mandy's Project\\2021\\Re _Modeling_Outputs\\Maize_summary.xlsx", sheet="Maize_biomass", startRow = 4, colNames = F, rowNames = F, cols=c(2)) ;

Res.CROP.MAIZE[,1]<-gsub(" ", "", Res.CROP[,1] ) ;

names(Res.CROP.MAIZE)<-c("CROP") ;


Res.CROP.YIELD.MAIZE<-gsub(" ", "", RES.NAMES.MAIZE[2,seq(from = 3, to = dim.data.frame(RES.NAMES.MAIZE)[2], by=1)]) ;

Res.SIM_CODE.MAIZE<-gsub(" ", "", RES.NAMES.MAIZE[1,seq(from = 3, to = dim.data.frame(RES.NAMES.MAIZE)[2], by=1)]);

Res.Data.MAIZE<-read.xlsx("C:\\Felipe\\Students Projects\\Mandy's Project\\2021\\Re _Modeling_Outputs\\Maize_summary.xlsx", sheet="Maize_biomass", startRow = 4, colNames = F, rowNames = F, cols=seq(from = 3, to = dim.data.frame(RES.NAMES.MAIZE)[2], by=1)) ;


SMIULATIONS.MAIZE<-unique(unlist(Res.SIM_CODE.MAIZE))

Res.Data.MAIZE[,which(Res.SIM_CODE.MAIZE == SMIULATIONS.MAIZE[1])]  ;



Mapping.Data.MAIZE<-list() ;



for (i in SMIULATIONS.MAIZE ){
  
  # i = SMIULATIONS.SORG[1] ; i
  
  Temporary.DataF<-data.frame(Res.YEAR.MAIZE,Res.CROP.MAIZE,Res.Data.MAIZE[,which(Res.SIM_CODE.MAIZE == i) ] ) ;
  
  names(Temporary.DataF)[seq(3,dim.data.frame(Temporary.DataF)[2])]<-Res.CROP.YIELD.MAIZE[which(Res.SIM_CODE.MAIZE == i)] ;
  
  
  Mapping.Data.MAIZE[[i]]<-Temporary.DataF  ;
  
  rm(Temporary.DataF)  ;
  
}



### Plot Mean (average) Total Forage Yield(Grain + forage)  across counties

Res.avg.MAIZE.1<-sapply(Mapping.Data.MAIZE, function(x) mean(x[,c("GRAINYIELD")] + x[,c("FORAGEYIELD")])) ;  

Res.avg.MAIZE.2<-data.frame(names(Res.avg.MAIZE.1),unname(Res.avg.MAIZE.1)) ;

names(Res.avg.MAIZE.2)<-c("SIM_CODE", "AVG_FORAGE_YIELD") ;

# there are duplicates generated in the CountyPTs_12_02_20@data$SIM_CODE

which(duplicated(CountyPTs_12_02_20@data$SIM_CODE))

Res.avg.MAIZE.3<-merge(CountyPTs_12_02_20@data[-which(duplicated(CountyPTs_12_02_20@data$SIM_CODE)),],Res.avg.MAIZE.2) [,c("GEOID","SIM_CODE", "AVG_FORAGE_YIELD")] ;

str(Res.avg.MAIZE.3)

#there are two GEOID duplicates

which(duplicated(Res.avg.MAIZE.3$GEOID))

# remove the duplicates

Res.avg.MAIZE.4<-Res.avg.MAIZE.3[-which(duplicated(Res.avg.MAIZE.3$GEOID)),] ;

str(Res.avg.MAIZE.4)

Res.avg.MAIZE.5<-sp::merge(USCounties[],Res.avg.MAIZE.4, by.x= "GEOID",by.y="GEOID", all.x=T );

str(Res.avg.MAIZE.5)


writeOGR(Res.avg.MAIZE.5, "C:\\Felipe\\Students Projects\\Mandy's Project\\2021\\GeneratedMapsShapeFiles\\MAIZE_avg.shp", layer="MAIZE_avg", driver="ESRI Shapefile" ) ;



### Plot Standard Deviation of Total Forage Yield (grain + forage) across counties


Res.SD.MAIZE.1<-sapply(Mapping.Data.MAIZE, function(x) sd(x[,c("GRAINYIELD")] + x[,c("FORAGEYIELD")])) ;

Res.SD.MAIZE.2<-data.frame(names(Res.SD.MAIZE.1),unname(Res.SD.MAIZE.1)) ;

names(Res.SD.MAIZE.2)<-c("SIM_CODE", "SD_FORAGE_YIELD") ;


# there are duplicates generated in the CountyPTs_12_02_20@data$SIM_CODE

which(duplicated(CountyPTs_12_02_20@data$SIM_CODE))

Res.SD.MAIZE.3<-merge(CountyPTs_12_02_20@data[-which(duplicated(CountyPTs_12_02_20@data$SIM_CODE)),],Res.SD.MAIZE.2) [,c("GEOID","SIM_CODE", "SD_FORAGE_YIELD")] ;

str(Res.SD.MAIZE.3)

#there are two GEOID duplicates

which(duplicated(Res.SD.MAIZE.3$GEOID))

# remove the duplicates


Res.SD.MAIZE.4<-Res.SD.MAIZE.3[-which(duplicated(Res.SD.MAIZE.3$GEOID)),] ;

str(Res.SD.MAIZE.4)

Res.SD.MAIZE.5<-sp::merge(USCounties[],Res.SD.MAIZE.4, by.x= "GEOID",by.y="GEOID", all.x=T );

str(Res.SD.MAIZE.5)


writeOGR(Res.SD.MAIZE.5, "C:\\Felipe\\Students Projects\\Mandy's Project\\2021\\GeneratedMapsShapeFiles\\MAIZE_std.shp", layer="MAIZE_std", driver="ESRI Shapefile" ) ;




### Plot Coefficient of variation of Total Forage Yield (grain + forage) across counties for the Maize  simulations

str(Res.SD.MAIZE.2)

str(Res.avg.MAIZE.2)

Res.MAIZE.CV<-merge(Res.avg.MAIZE.2,Res.SD.MAIZE.2, by= "SIM_CODE")  ;

str(Res.MAIZE.CV)

Res.MAIZE.CV$CV.ForageYield<-Res.MAIZE.CV$SD_FORAGE_YIELD/Res.MAIZE.CV$AVG_FORAGE_YIELD  ;

Res.MAIZE.CV.1<-merge(CountyPTs_12_02_20@data[-which(duplicated(CountyPTs_12_02_20@data$SIM_CODE)),],Res.MAIZE.CV) [,c("GEOID","SIM_CODE","AVG_FORAGE_YIELD" ,"SD_FORAGE_YIELD",  "CV.ForageYield")] ;

str(Res.MAIZE.CV.1)

#there are two GEOID duplicates

which(duplicated(Res.MAIZE.CV.1$GEOID))

# remove the duplicates


Res.MAIZE.CV.2<-Res.MAIZE.CV.1[-which(duplicated(Res.MAIZE.CV.1$GEOID)),] ;

str(Res.MAIZE.CV.2)

Res.MAIZE.CV.3<-sp::merge(USCounties,Res.MAIZE.CV.2 ,  by.x= "GEOID",by.y="GEOID", all.x=T );

str(Res.MAIZE.CV.3)

writeOGR(Res.MAIZE.CV.3, "C:\\Felipe\\Students Projects\\Mandy's Project\\2021\\GeneratedMapsShapeFiles\\MAIZE_CV.shp", layer="MAIZE_CV", driver="ESRI Shapefile" ) ;









###############################################################################################################
#                           Calculate the ratio of POLY to MAIZE from the simulation results 
###############################################################################################################

str(Res.Poly.CV.2)

str(Res.SORG.CV.2)

str(Res.MAIZE.CV.2)




Res.POLY_MAIZE<-merge(Res.Poly.CV.2,Res.MAIZE.CV.2, by="SIM_CODE") ;

str(Res.POLY_MAIZE)

#are there "SIM_CODE" duplicates?

which(duplicated(Res.POLY_MAIZE$SIM_CODE))

#are there "GEOID" duplicates?

which(duplicated(Res.POLY_MAIZE$GEOID.x))

which(duplicated(Res.POLY_MAIZE$GEOID.y))


str(Res.POLY_MAIZE)

Res.POLY_MAIZE$R_POLY_MAIZE_CV<-Res.POLY_MAIZE$CV.ForageYield.x/Res.POLY_MAIZE$CV.ForageYield.y ;


Res.POLY_MAIZE.2<-sp::merge(USCounties[],Res.POLY_MAIZE, by.x= "GEOID",by.y="GEOID.x", all.x=T );


writeOGR(Res.POLY_MAIZE.2, "C:\\Felipe\\Students Projects\\Mandy's Project\\2021\\GeneratedMapsShapeFiles\\Ratio_POLY_MAIZE_CV.shp", layer="CV_Ratio_POLY_MAIZE", driver="ESRI Shapefile" ) ;


###############################################################################################################
#                           Calculate the ratio of SORGHUM to MAIZE from the simulation results 
###############################################################################################################


Res.SORG_MAIZE<-merge(Res.SORG.CV.2,Res.MAIZE.CV.2, by="SIM_CODE") ;

str(Res.SORG_MAIZE)

#are there "SIM_CODE" duplicates?

which(duplicated(Res.SORG_MAIZE$SIM_CODE))

#are there "GEOID" duplicates?

which(duplicated(Res.SORG_MAIZE$GEOID.x))

which(duplicated(Res.SORG_MAIZE$GEOID.y))


Res.SORG_MAIZE$R_SORG_MAIZE_CV<-Res.SORG_MAIZE$CV.ForageYield.x/Res.SORG_MAIZE$CV.ForageYield.y ;

Res.SORG_MAIZE$R_SORG_MAIZE_B<-Res.SORG_MAIZE$AVG_FORAGE_YIELD.x/Res.SORG_MAIZE$AVG_FORAGE_YIELD.y ;


Res.SORG_MAIZE.2<-sp::merge(USCounties[],Res.SORG_MAIZE, by.x= "GEOID",by.y="GEOID.x", all.x=T );


writeOGR(Res.SORG_MAIZE.2, "C:\\Felipe\\Students Projects\\Mandy's Project\\2021\\GeneratedMapsShapeFiles\\Ratio_SORG_MAIZE.shp", layer="CV_Ratio_SORG_MAIZE", driver="ESRI Shapefile" ) ;





