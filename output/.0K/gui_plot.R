
 library("colorRamps")

# +++ This script is just a working model. 
# +++ For some customization, the user should edit it.
# +++
# +++ Author: Emerson Damasceno de Oliveira
# +++ Last update: 18 January 2022 

 ############################################################################################################

 #save figure [require png package]
 png("output/gui_plot.png", width = 391, height = 520, type='cairo')

 #open data
 dinsol1=read.table("output/insolation.txt", header=T, dec=".", sep="") 
 names(dinsol1) 
 attach(dinsol1) 

 #open data
 dinsol3 = read.table("output/summary.txt", header= T, dec=".", sep="") 
 names(dinsol3) 
 attach(dinsol3)

 NX      = as.numeric(as.character(resume[3]))         # Longitudinal number points
 NY      = as.numeric(as.character(resume[4]))         # Latitudinal number points
 NT      = as.numeric(as.character(resume[5]))         # Time interval by day
 NDAYS   = as.numeric(as.character(resume[6]))         # Annual number days
 ORBITAL = as.numeric(as.character(resume[7]))         # Parameterization

if (ORBITAL == 1) {

  if (NDAYS == 365) {
      if (NY == 36)   dinsol2 = read.table("output/.0K/insolation_5dg_1_1.txt", header=T, dec=".", sep="") 
      if (NY == 45)   dinsol2 = read.table("output/.0K/insolation_4dg_1_1.txt", header=T, dec=".", sep="") 
      if (NY == 60)   dinsol2 = read.table("output/.0K/insolation_3dg_1_1.txt", header=T, dec=".", sep="") 
      if (NY == 90)   dinsol2 = read.table("output/.0K/insolation_2dg_1_1.txt", header=T, dec=".", sep="") 
      if (NY == 180)  dinsol2 = read.table("output/.0K/insolation_1dg_1_1.txt", header=T, dec=".", sep="") 
      if (NY == 360)  dinsol2 = read.table("output/.0K/insolation_0.5dg_1_1.txt", header=T, dec=".", sep="") 
  } else {
      if (NY == 36)   dinsol2 = read.table("output/.0K/insolation_5dg_2_1.txt", header=T, dec=".", sep="") 
      if (NY == 45)   dinsol2 = read.table("output/.0K/insolation_4dg_2_1.txt", header=T, dec=".", sep="") 
      if (NY == 60)   dinsol2 = read.table("output/.0K/insolation_3dg_2_1.txt", header=T, dec=".", sep="") 
      if (NY == 90)   dinsol2 = read.table("output/.0K/insolation_2dg_2_1.txt", header=T, dec=".", sep="") 
      if (NY == 180)  dinsol2 = read.table("output/.0K/insolation_1dg_2_1.txt", header=T, dec=".", sep="") 
      if (NY == 360)  dinsol2 = read.table("output/.0K/insolation_0.5dg_2_1.txt", header=T, dec=".", sep="") 
  } 

} else if (ORBITAL == 2) {

  if (NDAYS == 365) {
      if (NY == 36)   dinsol2 = read.table("output/.0K/insolation_5dg_1_2.txt", header=T, dec=".", sep="") 
      if (NY == 45)   dinsol2 = read.table("output/.0K/insolation_4dg_1_2.txt", header=T, dec=".", sep="") 
      if (NY == 60)   dinsol2 = read.table("output/.0K/insolation_3dg_1_2.txt", header=T, dec=".", sep="") 
      if (NY == 90)   dinsol2 = read.table("output/.0K/insolation_2dg_1_2.txt", header=T, dec=".", sep="") 
      if (NY == 180)  dinsol2 = read.table("output/.0K/insolation_1dg_1_2.txt", header=T, dec=".", sep="") 
      if (NY == 360)  dinsol2 = read.table("output/.0K/insolation_0.5dg_1_2.txt", header=T, dec=".", sep="") 
  } else {
      if (NY == 36)   dinsol2 = read.table("output/.0K/insolation_5dg_2_2.txt", header=T, dec=".", sep="") 
      if (NY == 45)   dinsol2 = read.table("output/.0K/insolation_4dg_2_2.txt", header=T, dec=".", sep="") 
      if (NY == 60)   dinsol2 = read.table("output/.0K/insolation_3dg_2_2.txt", header=T, dec=".", sep="") 
      if (NY == 90)   dinsol2 = read.table("output/.0K/insolation_2dg_2_2.txt", header=T, dec=".", sep="") 
      if (NY == 180)  dinsol2 = read.table("output/.0K/insolation_1dg_2_2.txt", header=T, dec=".", sep="") 
      if (NY == 360)  dinsol2 = read.table("output/.0K/insolation_0.5dg_2_2.txt", header=T, dec=".", sep="") 
  } 

} else if (ORBITAL == 3) {

  if (NDAYS == 365) {
      if (NY == 36)   dinsol2 = read.table("output/.0K/insolation_5dg_1_3.txt", header=T, dec=".", sep="") 
      if (NY == 45)   dinsol2 = read.table("output/.0K/insolation_4dg_1_3.txt", header=T, dec=".", sep="") 
      if (NY == 60)   dinsol2 = read.table("output/.0K/insolation_3dg_1_3.txt", header=T, dec=".", sep="") 
      if (NY == 90)   dinsol2 = read.table("output/.0K/insolation_2dg_1_3.txt", header=T, dec=".", sep="") 
      if (NY == 180)  dinsol2 = read.table("output/.0K/insolation_1dg_1_3.txt", header=T, dec=".", sep="") 
      if (NY == 360)  dinsol2 = read.table("output/.0K/insolation_0.5dg_1_3.txt", header=T, dec=".", sep="") 
  } else {
      if (NY == 36)   dinsol2 = read.table("output/.0K/insolation_5dg_2_3.txt", header=T, dec=".", sep="") 
      if (NY == 45)   dinsol2 = read.table("output/.0K/insolation_4dg_2_3.txt", header=T, dec=".", sep="") 
      if (NY == 60)   dinsol2 = read.table("output/.0K/insolation_3dg_2_3.txt", header=T, dec=".", sep="") 
      if (NY == 90)   dinsol2 = read.table("output/.0K/insolation_2dg_2_3.txt", header=T, dec=".", sep="") 
      if (NY == 180)  dinsol2 = read.table("output/.0K/insolation_1dg_2_3.txt", header=T, dec=".", sep="") 
      if (NY == 360)  dinsol2 = read.table("output/.0K/insolation_0.5dg_2_3.txt", header=T, dec=".", sep="") 
  } 

} else {

  if (NDAYS == 365) {
      if (NY == 36)   dinsol2 = read.table("output/.0K/insolation_5dg_1_1.txt", header=T, dec=".", sep="") 
      if (NY == 45)   dinsol2 = read.table("output/.0K/insolation_4dg_1_1.txt", header=T, dec=".", sep="") 
      if (NY == 60)   dinsol2 = read.table("output/.0K/insolation_3dg_1_1.txt", header=T, dec=".", sep="") 
      if (NY == 90)   dinsol2 = read.table("output/.0K/insolation_2dg_1_1.txt", header=T, dec=".", sep="") 
      if (NY == 180)  dinsol2 = read.table("output/.0K/insolation_1dg_1_1.txt", header=T, dec=".", sep="") 
      if (NY == 360)  dinsol2 = read.table("output/.0K/insolation_0.5dg_1_1.txt", header=T, dec=".", sep="") 
  } else {
      if (NY == 36)   dinsol2 = read.table("output/.0K/insolation_5dg_2_1.txt", header=T, dec=".", sep="") 
      if (NY == 45)   dinsol2 = read.table("output/.0K/insolation_4dg_2_1.txt", header=T, dec=".", sep="") 
      if (NY == 60)   dinsol2 = read.table("output/.0K/insolation_3dg_2_1.txt", header=T, dec=".", sep="") 
      if (NY == 90)   dinsol2 = read.table("output/.0K/insolation_2dg_2_1.txt", header=T, dec=".", sep="") 
      if (NY == 180)  dinsol2 = read.table("output/.0K/insolation_1dg_2_1.txt", header=T, dec=".", sep="") 
      if (NY == 360)  dinsol2 = read.table("output/.0K/insolation_0.5dg_2_1.txt", header=T, dec=".", sep="") 
  } 

}


 names(dinsol2) 
 attach(dinsol2) 

 # setting the dimensions
 res     = 180/NY
 ilat    = -90+res/2
 flat    = 90-res/2
 times   = (seq(1,NDAYS,length=NDAYS))
 lat     = (seq(ilat,flat,length=NY))

 ##########################################################################################################

 z1      = matrix(Insol,NY,NDAYS)                 # insolation[days,lat]
 z2      = matrix(Sunshine,NY,NDAYS)              # variation of earth-sun obliquity       
 NHH     = z2[1,]
 z3      = matrix(Decl,NY,NDAYS)                  # variation of earth-sun obliquity       
 eps     = z3[1,]
 z4      = matrix(Rho,NY,NDAYS)                   # variation of earth-sun distance
 esd     = z4[1,]
 ecc     = as.numeric(as.character(resume[8]))    # eccentricity
 tilt    = as.numeric(as.character(resume[9]))    # obliquity
 prcs    = as.numeric(as.character(resume[10]))   # general precession
 yr0     = as.numeric(as.character(resume[1]))    #
 w1      = matrix(Insol0,NY,NDAYS)                # insolation[days,lat]
 dif     = z1-w1                                  # insolation difference to current days
 w2      = matrix(Rho0,NY,NDAYS)                  # insolation[days,lat]


 yr0


 ################################## PLOT GRAPHS ###########################################

 pal.1   <- colorRampPalette(c("blue", "cyan", "yellow", "red"), bias=1)
 pal.2   <- colorRampPalette(c("mediumblue", "lightskyblue", "cyan"), bias=1)
 
 MyViridis<-colorRampPalette(c("#440154FF","#482173FF","#433E85FF","#38598CFF","#2D708EFF",
                               "#25858EFF","#1E9B8AFF","#2BB07FFF","#51C56AFF","#85D54AFF",
			      "#C2DF23FF","#FDE725FF"),bias=1)


 par(mfrow=c(3,2))

 par(mar=c(2, 1.5, 2, 1.5))

 ################## ECCENTRICITY ##############################
 plot(0, 0, asp = 1, type = "n", xlim = c(-1.5, 1.5), 
 ylim = c(-2.0, 2.0), main=expression(bolditalic("Eccentricity")), 
 ylab = "", xlab = "", cex.main=1.4, cex.axis=1.2, 
 cex.lab=1.2, axes=FALSE)

 rect(par("usr")[1],par("usr")[3],par("usr")[2],par("usr")[4],col = "gray95")

 abline(v = seq(-3.4, 3.4, 0.85), lty = 2, col = "gray50")
 abline(h = seq(-3.4, 3.4, 0.85), lty = 2, col = "gray50")
 
 t  = seq(0, 2*pi, length.out = 1000) 
 a  = 1.0000                            # major axis ~ 1AU
 c  = a*ecc                             # sun position
 b  = sqrt(a^2 - c^2)                   # minor axis < 1AU  

 text(-1.50, -2.0, labels=paste(" a = ", format(round(a, 4), nsmall = 4), " AU", sep=""),
 col="black",font=4, cex=1.2)
 text(1.45, -2.0, labels=paste(" b = ", format(round(b, 4),
 nsmall = 4), " AU", sep=""), col="black",font=4, cex=1.2)
 text(-1.45, 1.87, labels=paste(" e = ", format(round(c, 4),
 nsmall = 4), " AU", sep=""), col="black",font=4, cex=1.4)
  
 x=cos(t)*a
 y=sin(t)*b
 
 polygon(x*1.7, y*1.7, col = rgb(100, 230, 250, 100,
 maxColorValue = 255),lwd = 2, lty=3, border = "gray5")

 tax=seq(0, 1.7, by=0.1)
 A=tax*0
 lines(tax,A,lwd=1.9, col="black")        # length major axis "a"

 tax=seq(0, b*1.7, by=0.0001)
 B=tax*0
 lines(B,tax,lwd=1.9, col="black")        # length minor axis "b"

 text(0.85, -0.4, labels=paste(" a ", sep=""),
 col="black",font=4, cex=1.3)
 text(-0.2, b*1.7/2, labels=paste(" b ", sep=""), 
 col="black",font=4, cex=1.3)

 text(a+0.9, 0, labels=paste(" P ", sep=""), 
 col="black",font=4, cex=1.3)
 text(-a-0.9, 0, labels=paste(" A ", sep=""), 
 col="black",font=4, cex=1.3)

 xe=cos(pi/4)*a                 # set earth point in x 
 ye=sin(pi/4)*b                 # set earth point in y 

 points(1.7*c,0, type = "p", pch=19, col="darkgoldenrod2",lwd=18 )    # set focal point [sun]
 points(xe*1.7,ye*1.7, type = "p", pch=19, col="blue",lwd=8 )         # set earth on orbital trajectory 


 ################## DAILY INSOLATION ##########################
 image(times,lat,t(z1), col = MyViridis(100), ylab = "Latitude", 
 xlab = "", main=expression(bolditalic(paste(" Daily Insolation [W/",m^2 ,"]"))), cex.main=1.4,
 cex.axis=1.2, cex.lab=1.2)
 contour(times,lat,t(z1), col="black", add=TRUE, lwd=1, labcex=1.1)

 ##################### OBLIQUITY PLOT ###############################
 plot(0, 0, asp = 1, type = "n", xlim = c(-1.5, 2.5), ylim = c(-1.5, 2.5),
 main=expression(bolditalic("Obliquity")), ylab = "", xlab = "", cex.main=1.4, cex.axis=0.1,
 cex.lab=1.2, axes=FALSE)

 rect(par("usr")[1],par("usr")[3],par("usr")[2],par("usr")[4],col = "gray5")

 arrows(3.0, 1.0, x1 = 2, y1 = 1, length = 0.1, angle = 25,
        code = 2, col ="yellow", lty=1, lwd = 1.5) 
		
 arrows(3.0, 0.5, x1 = 2, y1 = 0.5, length = 0.1, angle = 25,
        code = 2, col ="yellow", lty=1, lwd = 1.5) 
		
 arrows(3.0, -0.5, x1 = 2, y1 = -0.5, length = 0.1, angle = 25,
        code = 2, col ="yellow", lty=1, lwd = 1.5) 
		
 arrows(3.0, -1, x1 = 2, y1 = -1, length = 0.1, angle = 25,
        code = 2, col ="yellow", lty=1, lwd = 1.5) 
		
 points(0,0, type = "p", pch=19, col =rgb(70, 160, 250, 240,
 maxColorValue = 255), lwd=100 )
  
 t  = seq(pi/2, 3*pi/2, length.out = 1000) 
 x=cos(t)*1.25
 y=sin(t)*1.25
 
 polygon(x, y, col = "black", border = "gray50", lwd = 1.5 )

 abline(v = 0, lty = 1, col = "green",lwd=3)
 abline(h = 0, lty = 1, col = "green",lwd=3)
  
 x  = seq(-1.45, 1.45, by=0.1)
 fx = tan(pi/2 - tilt*(pi/180))*x
 fy = tan(pi - tilt*(pi/180))*x

 pxn=sin((tilt)*pi/180)
 pyn=cos((tilt)*pi/180)
 pxs=sin((tilt+180)*pi/180)
 pys=cos((tilt+180)*pi/180)
 pxe=sin((tilt+90)*pi/180)
 pye=cos((tilt+90)*pi/180)
 pxw=sin((tilt+270)*pi/180)
 pyw=cos((tilt+270)*pi/180)

 arrows(1.6*pxs, 1.6*pys, x1 = 1.6*pxn, y1 = 1.6*pyn, length = 0.1,
       code = 2, col = "orange", lty = 1,
       lwd = 3)

 arrows(1.4*pxw, 1.4*pyw, x1 = 1.4*pxe, y1 = 1.4*pye, length = 0.1,
       code = 0, col = "orange", lty = 1,
       lwd = 3)

 text(1.9*pxn, 1.9*pyn, labels=paste("N", sep=""), col="white",font=4, cex=1.5)
 text(-1.5, 2.0, labels=paste("Ecliptic", sep=""),col="green",font=4, cex=1.1)
 text(-1.5, 2.4, labels=paste("Equator", sep=""),col="orange",font=4, cex=1.1)
 text(2.7, 1.4, labels=expression(bolditalic("S"[0])), col="yellow",font=4, cex=1.5) 
 text(1.6, 2.3, labels=expression(paste("",delta," = "),"", sep=""),
 col="white",font=4, cex=1.7)
 text(2.4, 2.3, labels=paste(format(round(tilt, 2),nsmall = 0),"", sep=""),
 col="white",font=4, cex=1.2)


 ###### DAILY INSOLATION - DIFFERENCE TO CURRENT DAYS #########
 image(times,lat,t(dif),col = MyViridis(100), ylab = "Latitude",
 xlab = "", main=expression(bolditalic(paste("Comparison to Current [W/",m^2 ,"]"))),
 cex.main=1.4, cex.axis=1.2, cex.lab=1.2 )
 contour(times,lat,t(dif), add=TRUE, labcex=1.1)

 ####################### PRECESSION ############################

 r    = 8                     # z limit for cone plot
 prcs = (prcs+180)%%(360)     # longitude of the perihelion

 # cone function
 cone <- function(x, y){
  ifelse( sqrt(x^2+y^2) > r,
      yes = NaN,
      no  = sqrt(x^2+y^2) 
        )
 }

 x <- y <- seq(-10, 10, length=700)  # input files f(x,y)
 z <- outer(x, y, cone)              # z values from cone function

 # perspective plot
 persp(x, y, z, main=expression(bolditalic("")),
 cex.main=1.4, zlab = "z", theta = 30,
 phi = 30, shade=0.2, col=rgb(5, 160, 250, 100,
 maxColorValue = 255), 
 border=NA, box=TRUE ) 

 arrows(0.05, 0.12, x1 = -0.05, y1 = 0.12, length = 0.1, angle = 25,
        code = 2, col ="black", lty = par("lty"),
        lwd = 2)

 text(-0.05, 0.50,  labels=expression(bolditalic(paste(" Precession of Equinoxes ", sep=""))), 
 col="black",font=4, cex=1.4, xpd=NA)
 text(-0.55, -0.38, labels=expression(paste(omega," = ", sep="")), col="black",font=4, cex=1.9, xpd=NA)
 text(-0.37, -0.38, labels=paste(format(round(prcs, 2), nsmall = 0), "", sep=""),
 col="black",font=4, cex=1.1, xpd=NA)

 px = sin((prcs+180)*pi/180)/4
 py = cos((prcs+180)*pi/180)/14 + 0.30

 text(px+0.01, py+0.025, labels=paste("North", sep=""), col="black",font=4, cex=1.3, xpd=NA)
 points(px,py-0.045, type = "p", pch=23, col="black",lwd=1 )                        

 px0=0
 py0=-0.26 

 text(px0, py0, labels=paste("South", sep=""), col="black",font=4, cex=1.3)
 points(px0,py0+0.045, type = "p", pch=23, col="black",lwd=1 )                      

 if (px > px0)  xa = seq(px0, px, by=0.001)
 if (px <=  px0)  xa = seq(px, px0, by=0.001)

 fx = xa*(py-0.13 - py0)/(px-px0) - 0.2  

 lines(xa,fx,col = "black", lty=2, lwd=1)

 
 ############### DAILY SUNNHINE LENGTH ########################
 image(times,lat,t(z2),col = MyViridis(100), ylab = "Latitude", 
 xlab = "", main=expression(bolditalic("Day length [Hours]")), cex.main=1.4, 
 cex.axis=1.2, cex.lab=1.2)
 contour(times,lat,t(z2), add=TRUE, labcex=1.1)

 ####################################################################################
 
 text(-373.0, -85,  labels=expression(paste(" DINSOL-v1.0 ", sep="")), col="gray30",font=4, cex=1.3, xpd=NA)
 text(-325, -100,  labels=expression(paste(" UNIVASF/LabMet - BR ", sep="")), col="gray30",font=4, cex=1.3, xpd=NA)           
