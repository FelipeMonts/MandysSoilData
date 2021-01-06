##############################################################################################################
# 
# 
# Program to analyze Mandy's Cycles soils database
# 
#    
# 
# 
#  Felipe Montes 2020/12/18
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

setwd("C:\\Felipe\\Students Projects\\Mandy's Project\\RCode\\MandysSoilData") ;   # 



###############################################################################################################
#                            Install the packages that are needed                       
###############################################################################################################




###############################################################################################################
#                           load the libraries that are neded   
###############################################################################################################





###############################################################################################################
#                           Program to start exploring the files 
###############################################################################################################

list.files("..\\20201216_polysil_correct_soils\\20201216_polysil_correct_soils\\soils\\CyclesSoilsFromSSURGO_20201208\\CyclesSoilsFromSSURGO_20201208") ;

file.info("..\\20201216_polysil_correct_soils\\20201216_polysil_correct_soils\\soils\\CyclesSoilsFromSSURGO_20201208\\CyclesSoilsFromSSURGO_20201208\\52279.soil") ;

file.size("..\\20201216_polysil_correct_soils\\20201216_polysil_correct_soils\\soils\\CyclesSoilsFromSSURGO_20201208\\CyclesSoilsFromSSURGO_20201208\\52279.soil") ;


##### Check the files with good soils ####

file.size("..\\20201216_polysil_correct_soils\\20201216_polysil_correct_soils\\soils\\CyclesSoilsFromSSURGO_20201208\\CyclesSoilsFromSSURGO_20201208\\52279.soil") ;

##### The file 52279.soil appears to be ok and the size is 569 bytes


# # Soils edited from GNATSGO soil
# CURVE_NUMBER 89
# SLOPE 20
# TOTAL_LAYERS 9
# LAYER	THICK	CLAY	SAND	ORGANIC	BD	FC	PWP	SON	NO3	NH4	BYP_H	BYP_V
# 1	0.05	15	44.3	0.75	1.4	-999	-999	-999	10	1	0	0
# 2	0.05	15	44.3	0.75	1.4	-999	-999	-999	10	1	0	0
# 3	0.1	15	44.3	0.75	1.4	-999	-999	-999	7	1	0	0
# 4	0.2	15	44.3	0.75	1.4	-999	-999	-999	4	1	0	0
# 5	0.2	15	44.3	0.75	1.4	-999	-999	-999	2	1	0	0
# 6	0.2	15	44.3	0.75	1.4	-999	-999	-999	1	1	0	0
# 7	0.2	15	44.3	0.75	1.4	-999	-999	-999	1	1	0	0
# 8	0.2	15	44.3	0.75	1.4	-999	-999	-999	1	1	0	0
# 9	0.2	15	44.3	0.75	1.4	-999	-999	-999	1	1	0	0



##### Check the files with bad soils or missing 

file.size("..\\20201216_polysil_correct_soils\\20201216_polysil_correct_soils\\soils\\12_15_20_Missing_Soils\\59076.soil") ;

##### The file 59076.soil is listed in the missing soils directory and the size is 1016 bytes


# # Soil profile description automatically formatted for Cycles input based on soil horizon descriptions in SQL Query of SSURGO database at https://sdmdataaccess.nrcs.usda.gov/Query.aspx
# # The description is based upon data for the soil component having the largest percentage area within the map unit.
# 
# # Map Unit Key:	59076
# # Map Unit Component Name:	Meriwhiticia
# # Component Area (% of map unit):	40
# 
# CURVE_NUMBER   	90        
# SLOPE          	9         
# TOTAL_LAYERS   	02
# LAYER          	THICK          	CLAY           	SAND           	ORGANIC        	BD             	FC             	PWP            	NO3            	NH4            	RockVol        
# 1              	0.05           	12.00          	71.30          	0.50           	-999           	-999           	-999           	1              	1              	0.45           
# 2              	0.05           	12.00          	71.30          	0.50           	-999           	-999           	-999           	1              	1              	0.45           
# 
# 
# 



#### this soil is clearly not ready for Cycles.


#### Lets try to see if the soils in the missing soils directory are still in the CyclesSoilsFromSSURGO_20201208, the "good soils". If they are, we need to get rid of those.


###### List the file names  in the CyclesSoilsFromSSURGO_20201208

CyclesSoilsFromSSURGO_20201208.files<-list.files("..\\20201216_polysil_correct_soils\\20201216_polysil_correct_soils\\soils\\CyclesSoilsFromSSURGO_20201208\\CyclesSoilsFromSSURGO_20201208") ;

### Check it 

View(CyclesSoilsFromSSURGO_20201208.files) ;


###### List the file names  in the 12_15_20_Missing_Soils directory

Missing_Soils_12_15_20.files<-list.files("..\\20201216_polysil_correct_soils\\20201216_polysil_correct_soils\\soils\\12_15_20_Missing_Soils") ;

### Check it 

View(Missing_Soils_12_15_20.files) ;

### Verify if any of the "Missing Soils" files is still in the Good Soils directory

Missing_Soils_12_15_20.files %in% CyclesSoilsFromSSURGO_20201208.files

### It appears that none of the soils in the "Missing Soils" files  are in the Good Soils directory.
### So we forget about the missing soils for now and focus on the good soils directory


### Lets check the size of the files of the good soils directory

### First we need to make the paths (the complete name with the directories in which the file is located) for each file in the list. For that we paste the name on the list to the directory

CyclesSoilsFromSSURGO_20201208.files.Paths<-paste0("..\\20201216_polysil_correct_soils\\20201216_polysil_correct_soils\\soils\\CyclesSoilsFromSSURGO_20201208\\CyclesSoilsFromSSURGO_20201208\\", CyclesSoilsFromSSURGO_20201208.files) ;

# check it

View(CyclesSoilsFromSSURGO_20201208.files.Paths) 

# Then get the file sizes of each and add it to the file list creating a dataframe

  
F.Size<-file.size(CyclesSoilsFromSSURGO_20201208.files.Paths) ;

Soils.F.Size<-data.frame(CyclesSoilsFromSSURGO_20201208.files, F.Size) ;



## Check it


View(Soils.F.Size) 

##plot the file sizes:

plot(Soils.F.Size$F.Size)

## ON the plot there are a few files with sizes above 700 bytes. Lets check them!

Soils.F.Size[Soils.F.Size$F.Size>700,]


#   Only Four !  



# Lets check them in note pad 

#  2401258.soil    857

# Soils edited from GNATSGO soil
# CURVE_NUMBER 89
# SLOPE 35
# TOTAL_LAYERS 9
# LAYER	THICK	CLAY	SAND	ORGANIC	BD	FC	PWP	SON	NO3	NH4	BYP_H	BYP_V
# 1	0.05	8.32	10.8	4.0557952	0.604	-999	-999	-999	10	1	0	0.02
# 2	0.05	20.8	27	3	1.36	-999	-999	-999	10	1	0	0.02
# 3	0.1	20.24	27	1.355	1.437	-999	-999	-999	7	1	0	0.02
# 4	0.2	20.7384615384615	25.1538461538462	0.4225	1.43307692307692	-999	-999	-999	4	1	0	0.02
# 5	0.2	20.7384615384615	25.1538461538462	0	1.43307692307692	-999	-999	-999	2	1	0.01	0.02
# 6	0.2	20.7384615384615	25.1538461538462	0.4225	1.43307692307692	-999	-999	-999	1	1	0.02	0.02
# 7	0.2	20.7384615384615	25.1538461538462	0.4225	1.43307692307692	-999	-999	-999	1	1	0.02	0.02
# 8	0.2	20.7384615384615	25.1538461538462	0.4225	1.43307692307692	-999	-999	-999	1	1	0	0.02
# 9	0.2	20.7384615384615	25.1538461538462	0.4225	1.43307692307692	-999	-999	-999	1	1	0	0.02

# seems to be ok!

#  516293.soil 862

# Soils edited from GNATSGO soil
# CURVE_NUMBER 89
# SLOPE 12
# TOTAL_LAYERS 9
# LAYER	THICK	CLAY	SAND	ORGANIC	BD	FC	PWP	SON	NO3	NH4	BYP_H	BYP_V
# 1	0.05	20.8	27	2.5	1.43	-999	-999	-999	10	1	0.01	0.04
# 2	0.05	20.8	27	2.5	1.43	-999	-999	-999	10	1	0.01	0.04
# 3	0.1	20.24	27	0.925	1.458	-999	-999	-999	7	1	0.01	0.04
# 4	0.2	20.7384615384615	25.1538461538462	0.1625	1.43307692307692	-999	-999	-999	4	1	0.01	0.04
# 5	0.2	20.7384615384615	25.1538461538462	0	1.43307692307692	-999	-999	-999	2	1	0.03	0.04
# 6	0.2	20.7384615384615	25.1538461538462	0.1625	1.43307692307692	-999	-999	-999	1	1	0.04	0.04
# 7	0.2	20.7384615384615	25.1538461538462	0.1625	1.43307692307692	-999	-999	-999	1	1	0.05	0.04
# 8	0.2	20.7384615384615	25.1538461538462	0.1625	1.43307692307692	-999	-999	-999	1	1	0	0.04
# 9	0.2	20.7384615384615	25.1538461538462	0.1625	1.43307692307692	-999	-999	-999	1	1	0	0.04
# 

# seems to be ok!

# 555993.soil    858 

# # Soils edited from GNATSGO soil
# CURVE_NUMBER 89
# SLOPE 30
# TOTAL_LAYERS 9
# LAYER	THICK	CLAY	SAND	ORGANIC	BD	FC	PWP	SON	NO3	NH4	BYP_H	BYP_V
# 1	0.05	20.8	27	2	1.36	-999	-999	-999	10	1	0.01	0.02
# 2	0.05	20.8	27	2	1.36	-999	-999	-999	10	1	0.01	0.02
# 3	0.1	20.24	27	0.775	1.437	-999	-999	-999	7	1	0.01	0.02
# 4	0.2	20.7384615384615	25.1538461538462	0.1625	1.43307692307692	-999	-999	-999	4	1	0.01	0.02
# 5	0.2	20.7384615384615	25.1538461538462	0	1.43307692307692	-999	-999	-999	2	1	0.02	0.02
# 6	0.2	20.7384615384615	25.1538461538462	0.1625	1.43307692307692	-999	-999	-999	1	1	0.02	0.02
# 7	0.2	20.7384615384615	25.1538461538462	0.1625	1.43307692307692	-999	-999	-999	1	1	0.03	0.02
# 8	0.2	20.7384615384615	25.1538461538462	0.1625	1.43307692307692	-999	-999	-999	1	1	0	0.02
# 9	0.2	20.7384615384615	25.1538461538462	0.1625	1.43307692307692	-999	-999	-999	1	1	0	0.02


# seems to be ok!



#  61041.soil    732

# # Soils edited from GNATSGO soil
# CURVE_NUMBER 89
# SLOPE 55
# TOTAL_LAYERS 9
# LAYER	THICK	CLAY	SAND	ORGANIC	BD	FC	PWP	SON	NO3	NH4	BYP_H	BYP_V
# 1	0.05	20	42.1	1.5	1.3	-999	-999	-999	10	1	0	0
# 2	0.05	22	40.66	1.2	1.32	-999	-999	-999	10	1	0	0
# 3	0.1	25	38.5	0.75	1.35	-999	-999	-999	7	1	0	0
# 4	0.2	26.6666666666667	36.2222222222222	0.75	1.35	-999	-999	-999	4	1	0	0
# 5	0.2	26.6666666666667	36.2222222222222	0.75	1.35	-999	-999	-999	2	1	0	0
# 6	0.2	26.6666666666667	36.2222222222222	0.75	1.35	-999	-999	-999	1	1	0	0
# 7	0.2	26.6666666666667	36.2222222222222	0.75	1.35	-999	-999	-999	1	1	0	0
# 8	0.2	26.6666666666667	36.2222222222222	0.75	1.35	-999	-999	-999	1	1	0	0
# 9	0.2	26.6666666666667	36.2222222222222	0.75	1.35	-999	-999	-999	1	1	0	0
# 

# seems to be ok!


###############################################################################################################################################
#
#                                    Changing to explore the cycles.pbs.o24178598.o24178598 files to determine which soils are missing
#
###############################################################################################################################################

str(Soils.F.Size)

# From the cycles.pbs.o24178598.o24178598 file the first error comes "Error opening ./input/soils/153024.soil."

# lets check if it is in the soil files directory

"153024.soil" %in% Soils.F.Size$CyclesSoilsFromSSURGO_20201208.files

#False... it is not there... Lets look into the US_corn_scenarios.txt file and see if we find more that are not in the soils files directory

#To do that we need to read the US_corn_scenarios.txt into a dataframe in  R


US_corn_scenarios<-read.table("..\\20201216_polysil_correct_soils\\20201216_polysil_correct_soils\\US_corn_scenarios.txt", header=T)

# check it

View(US_corn_scenarios)

str(US_corn_scenarios)

# Extract the information from the column SOIL_FILE using the strsplit function

strsplit(US_corn_scenarios$SOIL_FILE,"/")


# Use sapply to get the second element of each of the list elements of the output of  strsplit(US_corn_scenarios$SOIL_FILE,"/")

sapply(strsplit(US_corn_scenarios$SOIL_FILE,"/"),function(x) x[2] )

#Store the results in a new column on US_corn_scenarios

US_corn_scenarios$Soils<-sapply(strsplit(US_corn_scenarios$SOIL_FILE,"/"),function(x) x[2] ) ;

# Check which of the US_corn_scenarios$Soils are in the soils file list

US_corn_scenarios$Soils %in% Soils.F.Size$CyclesSoilsFromSSURGO_20201208.files

# It seems there are many that are in the list 
which(US_corn_scenarios$Soils %in% Soils.F.Size$CyclesSoilsFromSSURGO_20201208.files)

# how many ?

length(which(US_corn_scenarios$Soils %in% Soils.F.Size$CyclesSoilsFromSSURGO_20201208.files))

# [1] 402

# Which are not in the list

which(!US_corn_scenarios$Soils %in% Soils.F.Size$CyclesSoilsFromSSURGO_20201208.files)

# How many are not in the list? 

length(which(!US_corn_scenarios$Soils %in% Soils.F.Size$CyclesSoilsFromSSURGO_20201208.files))

#[1] 2680

# How many are in US_corn_scenarios$Soils?

length(US_corn_scenarios$Soils)

#[1] 3082


# How many soils there are in CyclesSoilsFromSSURGO_20201208.files ?

length(Soils.F.Size$CyclesSoilsFromSSURGO_20201208.files)

#[1] 2608  interesting, there are may soils in the CyclesSoilsFromSSURGO_20201208.files but only 402 of those are in the US_corn_scenarios.txt 
# very strange....

# There may be repetitions so lets find the same but without repetitions using the unique function


length(unique(Soils.F.Size$CyclesSoilsFromSSURGO_20201208.files))

# #[1] 2608  all of the soils in the CyclesSoilsFromSSURGO_20201208 are unique. That is very encouraging


# How about in the US_corn_scenarios.txt ?

length(unique(US_corn_scenarios$Soils))

# [1] 3069


# so we have [1] 461 that are not in the US_corn_scenarios. Those could be the soils in the Missing soils file, we can check this later.

# how many of the of the US_corn_scenarios soils are in the Missing soils?

which(Missing_Soils_12_15_20.files %in% US_corn_scenarios$Soils)

# lets check some of these

Missing_Soils_12_15_20.files[1] %in% US_corn_scenarios$Soils

Missing_Soils_12_15_20.files[10] %in% US_corn_scenarios$Soils

# Lets check why there are 2608 soils from the  US_corn_scenarios not in the CyclesSoilsFromSSURGO_20201208.files

which(!US_corn_scenarios$Soils %in% Soils.F.Size$CyclesSoilsFromSSURGO_20201208.files)


head(US_corn_scenarios$Soils, 10)

# [1] "344234.soil"  "1899741.soil" "158461.soil"  "343952.soil"  "348846.soil"  "146930.soil"  "345217.soil"  "2396841.soil" "348289.soil"  "3011838.soil"

#lets check a few of these

"344234.soil" %in% Soils.F.Size$CyclesSoilsFromSSURGO_20201208.files

# [1] FALSE

"1899741.soil" %in% Soils.F.Size$CyclesSoilsFromSSURGO_20201208.files

# [1] FALSE

# Lest check if the ones that are in are really in

which(US_corn_scenarios$Soils %in% Soils.F.Size$CyclesSoilsFromSSURGO_20201208.files)

# [1]   10   16   20   22   23   40   51   73   79   92

#lets check a few of these

US_corn_scenarios$Soils[c(10,   16 ,  20 ,  22 ,  23  , 40 ,  51  , 73  , 79 ,  92)]

# [1] "3011838.soil" "347753.soil"  "2587206.soil" "348278.soil"  "2567011.soil" "2799205.soil" "2566782.soil" "2579712.soil" "2521602.soil" "1713536.soil"

"3011838.soil" %in% Soils.F.Size$CyclesSoilsFromSSURGO_20201208.files

# [1] TRUE

"347753.soil" %in% Soils.F.Size$CyclesSoilsFromSSURGO_20201208.files

#[1] TRUE

"1713536.soil" %in% Soils.F.Size$CyclesSoilsFromSSURGO_20201208.files 

# [1] TRUE



#  we have 461 that are not in the US_corn_scenarios

# how many of the of the US_corn_scenarios soils are in the Missing soils?

which(Missing_Soils_12_15_20.files %in% US_corn_scenarios$Soils)

length(which(Missing_Soils_12_15_20.files %in% US_corn_scenarios$Soils))

# [1] 36

# lets check some of these

Missing_Soils_12_15_20.files[1] %in% US_corn_scenarios$Soils

Missing_Soils_12_15_20.files[10] %in% US_corn_scenarios$Soils

# There are many soils NOT in the soils file that are called by the US_corn_scenarios.txt 

# Lets start working with what we have. Let stick to the simulations in the  US_corn_scenarios.txt  for which we have the soils file


US_corn_scenarios.with.Soils<-US_corn_scenarios[which(US_corn_scenarios$Soils %in% Soils.F.Size$CyclesSoilsFromSSURGO_20201208.files),];

# Check it

View(US_corn_scenarios.with.Soils)

## Write it in the format the multi Cycles can read it

## remove the column Soils we created
within(US_corn_scenarios.with.Soils, rm("Soils"))

write.table(within(US_corn_scenarios.with.Soils, rm("Soils")), file="..\\20201216_polysil_correct_soils\\20201216_polysil_correct_soils\\US_corn_scenarios_with_Soils.txt", sep=c("\t\t" ),quote=F,row.names = F)
















###############################################################################################################################################
#
#                                 
#
###############################################################################################################################################




