#!/bin/bash

########################################################################################
#                                                                                      #
# This script run the resolutions for the current days at 365 and 360 days calendars.  #
# The data are save and load in each simulation from GUI mode.                         #
#                                                                                      #
# Author: Emerson D. Oliveira                                                          #
# Last update: 27/07/2021                                                              #  
#                                                                                      # 
######################################################################################## 

cd ../../

var="          Year0   Day0  TrueLong0  Rho0   Lat0  Decl0  Sunshine0  Insol0"

for k in 1 2 3; do

 for j in 1 2; do

  for i in 1 2 3 4 5 6; do

  if [ $i == 1 ]; then
       nx="72"
       ny="36"
       name="5dg"
  elif [ $i == 2 ]; then
       nx="90"
       ny="45"
       name="4dg"       
  elif [ $i == 3 ]; then
       nx="120"
       ny="60"
       name="3dg"
  elif [ $i == 4 ]; then
       nx="180"
       ny="90"
       name="2dg"
  elif [ $i == 5 ]; then
       nx="360"
       ny="180"
       name="1dg"       
  else 
       nx="720"
       ny="360" 
       name="0.5dg"
  fi


cat >namelist <<EOF


  !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
  !                                                           !
  !            DAILY INSOLATION (DINSOL-v1.0) MODEL           !
  !                                                           !
  !  Universidade Federal do Vale do Sao Francisco - UNIVASF  !
  !            Laboratorio de Meteorologia - LABMET           !
  !                                                           !
  !                        NAMELIST                           !
  !                                                           !
  !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

&inputs

 ! PRIMARY VARIABLES 

 YEAR       =    0       ,    ! Year for orbital parameters
 S0         =    1366    ,    ! Solar constant [W/m^2]
 NY         =    $ny      ,    ! Latitudinal number points
 NX         =    $nx      ,    ! Longitudinal number points

 NTIME      =    1       ,    ! NTIME = 1 -> 6  hours
                              ! NTIME = 2 -> 3  hours
                              ! NTIME = 3 -> 1  hours
                              ! NTIME = 4 -> 30 minutes
                              ! NTIME = 5 -> 15 minutes

 CALENDAR   =    $j       ,    ! CALENDAR = 1 -> 365 days
                              ! CALENDAR = 2 -> 360 days

 ! ORBITAL PARAMETERS - PARAMETERIZATIONS

 ORBITAL    =    $k       ,    ! ORBITAL = 1 -> Berger (1978)
                              ! ORBITAL = 2 -> Berger and Loutre (1991)
                              ! ORBITAL = 3 -> Laskar et al (2004; 2011)
                              ! ORBITAL = 4 -> User-defined value

 ! >>> IF ORBITAL = 4 THEN SET ECC, OBLQ AND PRCS <<< 

 ECC        =    0.0167  ,    ! Eccentricity
 OBLQ       =    23.446  ,    ! Obliquity [deg]
 PRCS       =    282.04  ,    ! Precession [deg]
/
EOF

    ./dinsol.exe

    mv output/insolation.txt output/.0K/insolation_$name''_$j''_$k.txt
    sed -i "1s/.*/$var/" output/.0K/insolation_$name''_$j''_$k.txt

  done

 done

done

rm output/solar.radiation.ctl output/solar.radiation output/radiation.ctl output/radiation output/summary.txt

  echo " THE END "
