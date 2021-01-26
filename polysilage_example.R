#First you must set the working directory. To do this, go to Session > Set Working Dir > R folder (or whatever folder you want to use. )

#This line of code installs the Random Forest package. 
install.packages("randomForest")


#"f1" means file one. This is just a simple name for this program. Keep names simple and lower case because errors in repeating the correct name of case can lead to the program not running. 
#The sep = "" means that the data is seperated by spaces. 
f1<-read.table("polysoil.txt",sep = "", header = TRUE) 


#Here, we enter all of the headers that are read as "factors". Factors are ones that are not a continuous variable--they are descrete. It is similar to putting the $ in SAS. 
#If a variable is continuous, it does not need to be listed. R will assume it is continuous and read it as such. 
f1$year<-as.factor(f1$year)
f1$plot<-as.factor(f1$plot)
f1$block<-as.factor(f1$block)
f1$treat<-as.factor(f1$treat)
f1$horizon<-as.factor(f1$horizon)


## Data properties
names(f1)
summary(f1)
str(f1)


#These next four lines are from Armen's example. Does not pertain to me. 
#Fdepth=as.factor(RandomForestDemoData$Depth)
#Data=within(RandomForestDemoData, {
#  Latlong<-Longitude*Latitude
#})8


#The seed is like at what random number should the anlysis start. If you want to get the same output in each run of Random Forest, you MUST have the seed set to the same number. 
set.seed(300) 
library(randomForest)


#This line pertains to Armen's example--not for Polyculture analysis. 
#time	Year	DOY	FLOW	FLOW.p	FLOW.c	TEMP	DONconc	NO3conc	NO3conceP00	NO3conceP90	NH4conc	PONconc	SRPconc	DOPconc	POPconc	ASRPconc	DONmmol	NO3mmol	NH4mmol	LN_NO3mmol	NO3toNH4	PONmmol	SRPmmol	DOPmmol	POPmmol	ASRPmmol	PP	ET	RCHmm	GWFmm	OVFmm	GWT	SWm


#This is like the model statement. The variable before the ~ is the dependent variable. The variables that come after are the independent variables. 
#data is the data set it should use. We have been naming evrything f1 so here it is f1
#ntree is the number of trees to be made to predict outcome
#mtry is the number of variable tried at each split. It is usually the square root of n where n is the number of variable you are using. 
#RF1 means "show me the model".
RF1=randomForest(NO3 ~ year +  treat + depth + block + horizon ,
             data = f1, ntree = 300, mtry = 2, importance = T, proximity = T) 

#RF1 means "show me the model".
#plot means plot me the model of RF1
#The ourput to this will give you two graphs. 
#The %IncMSE shows you which variable is the most important. The most important variables will be on teh top and to the righ. Lease importnat variable will be on the left and closer to the bottom. 
#The IncNodePurity shows you how important a variable is to a particular node. The node is where the data splits. 
RF1
plot(RF1)
varImpPlot(RF1)


##Partial dependence plot
par(mfrow=c(2,2))
partialPlot(RF1,f1,year)
#partialPlot(RF1,f1,block)
partialPlot(RF1,f1,depth)
partialPlot(RF1,f1,treat)
partialPlot(RF1,f1,horizon)

##predict
#This code predicts a variable given the input of other variables. 
#Be sure to change the name of the table (here it is f2), so it is different from teh above analysis. 
f2<-read.table("polysoil_predict.txt",sep = "", header = TRUE)
str(f2)

f2$year<-as.factor(f2$year)
f2$plot<-as.factor(f2$plot)
f2$block<-as.factor(f2$block)
f2$treat<-as.factor(f2$treat)
f2$horizon<-as.factor(f2$horizon)

levels(f2$year) <- levels(f1$year)
levels(f2$plot) <- levels(f1$plot)
levels(f2$treat) <- levels(f1$treat)
levels(f2$depth) <- levels(f1$depth)
levels(f2$block) <- levels(f1$block)
levels(f2$horizon) <- levels(f1$horizon)

#You readlly only need this line to run the prediction in Random Forest. The above just re-read teh same table I'm improrted. 
f2.predict = predict(RF1,f2)
f2$NO3.predict <- f2.predict

#yflow6<-read.table("yflow6.txt",sep = "", header = TRUE)
#str(yflow6)
#y6.predict = predict(RF34,yflow6)


#Below is code from Armen's example, disregard for now
#str(y1.predict)
#y2.predict = predict(RF30, yflow2, type="response",
#                     norm.votes=TRUE, predict.all=TRUE, proximity=FALSE, nodes=FALSE)


##Export data
#This code creates a .csv file export. 
write.csv(f2, file = "NO3_predict.csv")

#These are remnants of Armen's code
#write.csv(y6.predict, file = "findmeplease6.csv")
#write.csv(y2.predict, file = "findmeplease2.csv")

