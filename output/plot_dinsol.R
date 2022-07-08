
# +++ This script is just a working model. 
# +++ For some customization, the user should edit it.
# +++
# +++ Author: Emerson Damasceno Oliveira
# +++ Last update: 17 January 2022 

 library("colorRamps")

 png("insol_R.png", width = 500, height = 550, type='cairo')

 dinsol=read.table("insolation.txt", header=T, dec=".", sep="") 
 names(dinsol) 
 attach(dinsol)
 
 setting=read.table("summary.txt", header=T, dec=".", sep="") 
 names(setting) 
 attach(setting)  

 NY = as.numeric(as.character(resume[4]))
 NDAYS = as.numeric(as.character(resume[6]))

 res=180/NY
 ilat=-90+res/2
 flat=90-res/2
 times=(seq(1,NDAYS,length=NDAYS))
 lat=(seq(ilat,flat,length=NY))

 z=matrix(Insol,NY,NDAYS)

 palete   <- colorRampPalette(c("blue", "cyan", "yellow", "red"))

 image(times,lat,t(z), col = palete(100), ylab = "Latitude", 
 xlab = "Days", main=expression(paste(" Daily Insolation [W/",m^2 ,"]")), cex.main=1.6, 
 cex.axis=1.3, cex.lab=1.6)
 contour(times,lat,t(z), add=TRUE, labcex=1.4)

 dev.off()
