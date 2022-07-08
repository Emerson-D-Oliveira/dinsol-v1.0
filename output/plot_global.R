# +++ This script is just a example. 
# +++ For some customization you should edit this script.
# +++
# +++ Author: Emerson Damasceno Oliveira
# +++ Last update: 17 January 2022 

 suppressWarnings(suppressMessages( library("colorRamps") ))
 suppressWarnings(suppressMessages( library("maps") ))

 png("global_radiation.png", width = 700, height = 500, type="cairo")

 ######### EDIT THE VARIABLES ########################################################################

 day  = 1    #set the day [1:365] or [1:360] in agreement with the chosen calendar.
 hour = 1    #set the hour( e.g ., if NTIME=1 { 1=00h; 2=06h; 3=12h; 4=18h } )
             #            ( e.g ., if NTIME=2 { 1=00h; 2=03h; 3=6h; 4=9h; 5=12h ... } ) 

 #####################################################################################################

 #open data
 dinsol = read.table("summary.txt", header= T, dec=".", sep="") 
 names(dinsol) 
 attach(dinsol)

 NX      = as.numeric(as.character(resume[3]))      # Longitudinal number points
 NY      = as.numeric(as.character(resume[4]))      # Latitudinal number points
 NT      = as.numeric(as.character(resume[5]))      # Time interval by day
 NDAYS   = as.numeric(as.character(resume[6]))      # Annual number days

 #open global binary file
 to.read=file("radiation", "rb")
 total=NDAYS*NT*NX*NY
 global_rad=readBin(to.read, numeric(), n=total, size=4)

 XYdim=NX*NY
 time_step=NT*(day-1)+hour
 p_i = time_step*XYdim - XYdim + 1
 p_f = time_step*XYdim

 rad=global_rad[p_i:p_f]

 res=180/NY
 ilat=-90+res/2
 flat=90-res/2
 lon=(seq(0,360,length=NX))
 lat=(seq(ilat,flat,length=NY))

 z=t(matrix(rad,NX,NY))

 dinsol.blue<-colorRampPalette(c("black","midnightblue","cornflowerblue","skyblue"),bias=1)

 image(lon,lat,t(z), col = dinsol.blue(100))	
 map("world",add=T, wrap = c(0,360), col=0)
 contour(lon,lat,t(z), add=TRUE, labcex=1.1)

 if (NDAYS == 365) {

    if (day > 0 && day <= 31) {
      day=day
      month="January"    
    } else if (day > 31 && day <= 59) {
      day=day-31
      month="February"
    } else if (day > 59 && day <= 90) {    
      day=day-59
      month="March" 
    } else if (day > 90 && day <= 120) {    
      day=day-90 
      month="April"
    } else if (day > 120 && day <= 151) {    
      day=day-120
      month="May" 
    } else if (day > 151 && day <= 181) {    
      day=day-151
      month="June" 
    } else if (day > 181 && day <= 212) {    
      day=day-181
      month="July" 
    } else if (day > 212 && day <= 243) {    
      day=day-212
      month="August" 
    } else if (day > 243 && day <= 273) {    
      day=day-243 
      month="September"
    } else if (day > 273 && day <= 304) {    
      day=day-273
      month="Octuber" 
    } else if (day > 304 && day <= 334) {    
      day=day-304
      month="November" 
    } else if (day > 334 && day <= 365) {    
      day=day-334
      month="December" 
    }

 } else if (NDAYS == 360) {

    if (day > 0 && day <= 30) {
      day=day
      month="January"    
    } else if (day > 30 && day <= 60) {
      day=day-30
      month="February"
    } else if (day > 60 && day <= 90) {    
      day=day-60
      month="March" 
    } else if (day > 90 && day <= 120) {    
      day=day-90 
      month="April"
    } else if (day > 120 && day <= 150) {    
      day=day-120
      month="May" 
    } else if (day > 150 && day <= 180) {    
      day=day-150
      month="June" 
    } else if (day > 180 && day <= 210) {    
      day=day-180
      month="July" 
    } else if (day > 210 && day <= 240) {    
      day=day-210
      month="August" 
    } else if (day > 240 && day <= 270) {    
      day=day-240 
      month="September"
    } else if (day > 270 && day <= 300) {    
      day=day-270
      month="Octuber" 
    } else if (day > 300 && day <= 330) {    
      day=day-300
      month="November" 
    } else if (day > 330 && day <= 360) {    
      day=day-330
      month="December" 
    } 
 }

 day
 month
 Hr = hour*(24/NT)-(24/NT)

 text(38, 95,  labels=paste("Global Irradiance [", sep=""), col="black",font=2, cex=1.2, lwd=2, xpd=NA)
 text(90, 95,  labels=expression(bold(W/m^"2")), col="black",font=1, cex=1.2, lwd=2, xpd=NA)
 text(105, 95, labels=paste("]", sep=""), col="black",font=2, cex=1.2, lwd=2, xpd=NA)
 text(310, 95, labels=paste(day," ", month," ",Hr,"hr", sep=""), col="black",font=1, cex=1.2, lwd=1, xpd=NA)
