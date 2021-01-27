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

ogrInfo("C:\\Felipe\\Students Projects\\Mandy's Project\\2021\\CountyShapefiles\\tl_2019_us_county\\tl_2019_us_county.shp") ;

USCounties<-readOGR("C:\\Felipe\\Students Projects\\Mandy's Project\\2021\\CountyShapefiles\\tl_2019_us_county\\tl_2019_us_county.shp") ;


#plot(USCounties)



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


### Load the files with the simulation results


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



Mapping.Data<-list() ;



for (i in SMIULATIONS ){
  
  # i = SMIULATIONS[1] ; i
  
  Temporary.DataF<-data.frame(Res.YEAR,Res.CROP,Res.Data[,which(Res.SIM_CODE == i) ] ) ;
  
  names(Temporary.DataF)[seq(3,dim.data.frame(Temporary.DataF)[2])]<-Res.G_F_YIELD[which(Res.SIM_CODE == i)] ;
  
  
  Mapping.Data[[i]]<-Temporary.DataF  ;
  
  rm(Temporary.DataF)  ;
  
}

### Plot Maximum grain Yield across counties

Res.Max.Grain.1<-sapply(Mapping.Data, function(x) max(x[which(x$CROP == "MaizeRM90"),c("GRAINYIELD")])) ; 

Res.Max.Grain.2<-data.frame(names(Res.Max.Grain.1),unname(Res.Max.Grain.1 )) ;

names(Res.Max.Grain.2)<-c("SIM_CODE", "MAX_GRAIN_YIELD") ;


which(duplicated(Res.Max.Grain.2$SIM_CODE))

# there are duplicates generated in the CountyPTs_12_02_20@data$SIM_CODE

which(duplicated(CountyPTs_12_02_20@data$SIM_CODE))


Res.Max.Grain.3<-merge(CountyPTs_12_02_20@data[-which(duplicated(CountyPTs_12_02_20@data$SIM_CODE)),],Res.Max.Grain.2)[,c("GEOID","SIM_CODE", "MAX_GRAIN_YIELD")] ;


str(Res.Max.Grain.3)

#there are two GEOID duplicates


which(duplicated(Res.Max.Grain.3$GEOID))

# remove the duplicates

Res.Max.Grain.4<-Res.Max.Grain.3[-which(duplicated(Res.Max.Grain.3$GEOID)),] ;

str(Res.Max.Grain.4)

Res.Max.Grain.5<-sp::merge(USCounties[],Res.Max.Grain.4, by.x= "GEOID",by.y="GEOID", all.x=T );

str(Res.Max.Grain.5)

## Remove duplicates


writeOGR(Res.Max.Grain.5, "C:\\Felipe\\Students Projects\\Mandy's Project\\2021\\GeneratedMapsShapeFiles\\Max_Grain_4B.shp", layer="Max_Grain_4", driver="ESRI Shapefile" ) ;


### Plot Maximum Forage Yield across counties

Res.Max.Forage.1<-sapply(Mapping.Data, function(x) max(x[which(x$CROP == "MaizeRM90"),c("GRAINYIELD")] + x[which(x$CROP == "MaizeRM90"),c("FORAGEYIELD")])) ;  

Res.Max.Forage.2<-data.frame(names(Res.Max.Forage.1),unname(Res.Max.Forage.1)) ;

names(Res.Max.Forage.2)<-c("SIM_CODE", "MAX_FORAGE_YIELD") ;

# there are duplicates generated in the CountyPTs_12_02_20@data$SIM_CODE

which(duplicated(CountyPTs_12_02_20@data$SIM_CODE))

Res.Max.Forage.3<-merge(CountyPTs_12_02_20@data[-which(duplicated(CountyPTs_12_02_20@data$SIM_CODE)),],Res.Max.Forage.2) [,c("GEOID","SIM_CODE", "MAX_FORAGE_YIELD")] ;

str(Res.Max.Forage.3)

#there are two GEOID duplicates

which(duplicated(Res.Max.Forage.3$GEOID))

# remove the duplicates

Res.Max.Forage.4<-Res.Max.Forage.3[-which(duplicated(Res.Max.Forage.3$GEOID)),] ;

str(Res.Max.Forage.4)

Res.Max.Forage.5<-sp::merge(USCounties[],Res.Max.Forage.4, by.x= "GEOID",by.y="GEOID", all.x=T );

str(Res.Max.Forage.5)


writeOGR(Res.Max.Forage.5, "C:\\Felipe\\Students Projects\\Mandy's Project\\2021\\GeneratedMapsShapeFiles\\Max_FORAGE_4.shp", layer="Max_FORAGE", driver="ESRI Shapefile" ) ;


# Plot Yield across counties for year 2000
