#install.package("png")

# +++ This script is just a working model. 
# +++ For some customization, the user should edit it.
# +++
# +++ Author: Emerson Damasceno Oliveira
# +++ Last update: 26 June 2021 

 ###############  EDIT THIS VALUES ###################

 setLat  = -23   # Chosen latitude [ "+" == "North" and "-" == "South" ]
 setDay  = 178   # Chosen day [1:365] or [1:360] 

 #####################################################

 # save figure [require png package]
 png("example_plot.png", width = 650, height = 550, type='cairo')

 # open data
 dinsol=read.table("insolation.txt", header=T, dec=".", sep="") 
 names(dinsol) 
 attach(dinsol) 

 setting=read.table("summary.txt", header=T, dec=".", sep="") 
 names(setting) 
 attach(setting)  

 NY = as.numeric(as.character(resume[4]))
 NDAYS = as.numeric(as.character(resume[6]))

 # setting the dimensions
 res=180/NY
 ilat=-90+res/2
 flat=90-res/2
 times=(seq(1,NDAYS,length=NDAYS))
 lat=(seq(ilat,flat,length=NY))

   # approximate index position for setLat
   if (setLat<=0) {
      latP=as.integer((setLat-ilat+2*res)/res)    
   } else { 
      latP=as.integer((setLat-ilat+res)/res)      
   }

 # z structure Insol data like array Lat x Day
 z=matrix(Insol,NY,NDAYS)
 z2=matrix(Sunshine,NY,NDAYS)
 

 # get_value  
 IS     = z[latP,setDay]              # IS is the daily insolation value for a specific date and latitude
 DL     = z2[latP,setDay]             # DL is the day length value for a specific date and latitude 

 print(paste0("" ))
 print(paste0(" DAILY INSOLATION (DINSOL) MODEL " ))
 print(paste0("" ))
 print(paste0(" [ Day = ",setDay," | Latitude = ",setLat," ]" ))                  # print latP value
 print(paste0(" [ Daily Insolation ~ ",IS ," W/m^2 ]" ))
 print(paste0(" [ Day length ~ ",DL ," Hours ]" ))
 print(paste0("" ))

 ##########################################################################################################

 Iss    = z[latP,]                    # Insolation day to day [fixed Lat]
 LatDay = z[,setDay]                  # Insolation for all latitudes [fixed Day]
 es=matrix(Rho,NY,NDAYS)              # Earth-Sun distance
 dist=es[latP,]
 eps=matrix(Decl,NY,NDAYS)            # Earth-sun obliquity       
 epss=eps[latP,]
 nh=matrix(Sunshine,NY,NDAYS)         # Earth-sun obliquity       
 NHH=eps[latP,]

 #################################### Basic graphs ########################################################
 
 par(mfrow=c(2,3)) 
 
 plot(times,Iss, type = "l", ylab = "W/m^2", xlab = "Days", main="Daily Insolation - Fixed latitude",
 lty = 5, las=1 , lwd=1, cex.main=1.6, cex.axis=1.2, cex.lab=1.6)
 
 text(NDAYS/2, (min(Iss)+max(Iss))/2, labels=paste(" Lat = ", setLat,""), col="black",font=4, cex=1.3)
 
 plot(lat,LatDay, type = "l", ylab = "W/m^2", xlab = "Latitude", main="Daily Insolation - Fixed day",
 lty = 5, las=1, lwd=1, cex.main=1.6, cex.axis=1.2, cex.lab=1.6)
 
 text(0, (min(LatDay)+max(LatDay))/2, labels=paste(" Day = ", setDay), col="black",font=4, cex=1.3)
 
 plot(times,epss, type = "l", ylab = "degree", xlab = "Days", main="Earth-sun obliquity",
 lty = 5, las=1, lwd=1,  cex.main=1.6, cex.axis=1.2, cex.lab=1.6)
 
 plot(times,dist, type = "l", ylab = "", xlab = "Days", main=expression(bold(paste("Earth-sun distance [",rho,"] - AU"))),
 lty = 5, las=1, lwd=1,  cex.main=1.6, cex.axis=1.2, cex.lab=1.6)
 
 contour(times,lat, t(z), ylab = "", xlab = "Days", main="Daily Insolation [W/m^2]",
 cex.main=1.6, cex.axis=1.2, cex.lab=1.6, labcex = 1.1)
 
 contour(times,lat, t(nh), ylab = "", xlab = "Days", main="Day lenght [hours]",
 cex.main=1.6, cex.axis=1.2, cex.lab=1.6, labcex = 1.1)


