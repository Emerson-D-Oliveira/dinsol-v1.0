
!  ###########################################################################################  
!  #                                                                                         #
!  #                         DAILY INSOLATION (DINSOL-v1.0) MODEL                            #
!  #                                                                                         #
!  #                  Universidade Federal do Vale do Sao Francisco - UNIVASF                #
!  #                         Laboratorio de Meteorologia - LabMet                            #
!  #                                                                                         #
!  #                                                                                         #
!  #    This program calculates the value of the earth's orbital parameters and the daily    #
!  #    insolation for a given year.                                                         #
!  #                                                                                         #
!  #    The user may to adopt: Berger 1978; Berger and Loutre 1991; Laskar et al 2004; 2011. #
!  #                                                                                         # 
!  #    With this program, it is also possible to define the orbital parameters arbitrarily. #
!  #    However, while respecting the intervals:                                             #
!  #                                                                                         #
!  #            ECCENTRICITY = [0,0.5] ; OBLIQUITY=[-90,90] ; PRECESSION=[0,360[             #
!  #                                                                                         #
!  #    The daily insolation is calculated according to Berger (1978).                       #
!  #                                                                                         #
!  #    Author: Emerson Damasceno de Oliveira                                                #
!  #    Last update: 17 January 2022                                                         #
!  #                                                                                         #
!  #    contact: emerson.oliveira@univasf.edu.br                                             #
!  #                                                                                         #
!  #  ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++   #
!  #                                                                                         #
!  #   Copyright (C) <2022>  <Emerson Damasceno de Oliveira>                                 #
!  #                                                                                         #
!  #   This program is free software: you can redistribute it and/or modify                  #
!  #   it under the terms of the GNU General Public License as published by                  #
!  #   the Free Software Foundation, either version 3 of the License, or                     #
!  #   (at your option) any later version.                                                   #
!  #                                                                                         #
!  #   This program is distributed in the hope that it will be useful,                       #
!  #   but WITHOUT ANY WARRANTY; without even the implied warranty of                        #
!  #   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the                         #
!  #   GNU General Public License for more details.                                          #
!  #                                                                                         #
!  #   You should have received a copy of the GNU General Public License                     #
!  #   along with this program.  If not, see <https://www.gnu.org/licenses/>.                #
!  #                                                                                         #
!  ###########################################################################################

  module variable_names

  ! -> CONFIGURE (e.g: Intel Fortran require "ireal=1", while the GNU Fortran require "ireal=4")  
  integer                          ::  ireal = 4    

  !Some variables that are adopted by different subroutines:
  integer                          ::  i, y, yr, t1, t2, ndays, cldr, pointP, pointT

  !Parameters used for read the input data and calculate the orbital parameters 
  integer, parameter               ::  B78_nt1=188, B78_nt4=76, B78_nt5=312, La_nt=270001  
  integer, parameter               ::  B90_nt1=4000, B90_nt4=320, B90_nt5=4000, yref=249001
  real, parameter                  ::  pi=3.1415927, e_star78=23.320556, e_star90=23.3334095 
  real, parameter                  ::  arcsec2rad=pi/(180.*3600.), deg2rad=pi/180., rad2deg=180./pi, twopi=2*pi  
  real, parameter                  ::  psibar78=(50.439273/60./60.)*deg2rad, psibar90=(50.41726176/60./60.)*deg2rad
  real, parameter                  ::  zeta78=3.392506*deg2rad, zeta90=1.60075265*deg2rad

  !Here are the tables data used in spectral analysis  (Be78 and Be90) and the time series of orbital parameters &
  !calculated by Laskar et al (2004; 2011).  
  real, dimension(B78_nt1)         ::  B78_Tb1
  real, dimension(B78_nt4)         ::  B78_Tb4
  real, dimension(B78_nt5)         ::  B78_Tb5
  real, dimension(B78_nt1/4)       ::  B78_Amp1, B78_Rate1, B78_Phase1, B78_Period1, B78_A, B78_ff, B78_Phi 
  real, dimension(B78_nt4/4)       ::  B78_Amp4, B78_Rate4, B78_Phase4, B78_Period4, B78_M, B78_g, B78_Beta
  real, dimension(B78_nt5/4)       ::  B78_Amp5, B78_Rate5, B78_Phase5, B78_Period5, B78_F, B78_fp, B78_Delta
  real, dimension(B90_nt1)         ::  B90_Tb1
  real, dimension(B90_nt4)         ::  B90_Tb4
  real, dimension(B90_nt5)         ::  B90_Tb5
  real, dimension(B90_nt1/4)       ::  B90_Amp1, B90_Rate1, B90_Phase1, B90_Period1, B90_A, B90_ff, B90_Phi 
  real, dimension(B90_nt4/4)       ::  B90_Amp4, B90_Rate4, B90_Phase4, B90_Period4, B90_M, B90_g, B90_Beta
  real, dimension(B90_nt5/4)       ::  B90_Amp5, B90_Rate5, B90_Phase5, B90_Period5, B90_F, B90_fp, B90_Delta
  real, dimension(La_nt)           ::  L_ecc, L_eps, L_varpi

  !Variables that are adopted to calculate seasons, perihelion, and aphelion dates.  
  character(len=3)                 ::  month, mon_peri, mon_aphel, mon_summer, mon_winter, mon_autumn, mon_spring
  real                             ::  summer, winter, autumn, spring   
  real                             ::  mday, peri, aphel, calendar_converter, vernal_point
  real, dimension(1)               ::  summerloc, autumnloc, winterloc
  real, dimension(:), allocatable  ::  truelong_seasons
  integer, parameter               ::  trunc=100
  
  !Variables used to calculate the orbital parameters, the daily insolation average on top of the atmosphere, the &
  !global irradiance on top of the atmosphere and the annual average of daily insolation on latitudes 23 N and 60 N.
  real                             ::  beta, psi, atanpi, eps, esinpi, ecospi, varpi, omega, hh, res_lat, res_lon
  real                             ::  j, ilat, lat, ilon, lon, nu, rho, H0, sindecl, cosdecl, cosH0, sinH0
  integer                          ::  ll, x, time, nt 
  character(len=4)                 ::  tdef 
  real, dimension(:), allocatable  ::  truelong
  real                             ::  lambd, lambd_m
  real, dimension(:), allocatable  ::  insol, NH0, irrad_avg, Hrad

  !All namelist variables are declared here
  integer                          ::  year      = 0
  integer                          ::  calendar  = 0
  real                             ::  S0        = 0    
  integer                          ::  ny        = 0
  integer                          ::  nx        = 0
  integer                          ::  ntime     = 0
  integer                          ::  orbital   = 0  
  real                             ::  ecc       = 0
  real                             ::  oblq      = 0  
  real                             ::  prcs      = 0

  namelist / inputs / year, S0, ny, nx, ntime, calendar, orbital, ecc, oblq, prcs

  end module variable_names

!+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

  subroutine dinsol_model

  use variable_names
  
  !Defining data for the calendar type
  if (calendar == 1) then
      ndays   = 365  
      calendar_converter = 286              
      vernal_point = 80*trunc-1
  else 
      ndays   = 360
      calendar_converter = 280
      vernal_point = 81*trunc-1
  end if
                           
  !Allocating dimensions 
  allocate ( insol(ny) )
  allocate ( NH0(ny) )
  allocate ( irrad_avg(ny) )
  allocate ( Hrad(ny*nx*nt) )                           
  allocate ( truelong(ndays) )
  allocate ( truelong_seasons(trunc*ndays) )

  if (orbital == 1) then
      call orbital_berger1978            !Calling the subroutine that determines the orbital parameters from Berger (1978)
  else if (orbital == 2) then
      call orbital_berger1990            !Calling the subroutine that determines the orbital parameters from Berger and Loutre (1991)
  else if (orbital == 3) then
      call orbital_laskar                !Calling the subroutine that determines the orbital parameters from Laskar et al (2004;2011)
  else if (orbital == 4) then
      eps   = oblq*deg2rad               !User-defined orbital parameters 
      varpi = prcs*deg2rad  
      omega = amod(varpi+pi,twopi)
  end if

  beta     = sqrt(1-ecc**2)              !Beta parameter used in Berger (1978) and Berger and Loutre (1991)     
  res_lat  = 180./ny                     !Latitudinal resolution in degrees 
  ilat     = (-90.+(res_lat/2.))         !Initial latitude (Southern Hemisphere)
  res_lon  = 360./nx                     !Longitudinal resolution in degrees
  pointP   = nint(1.+(65.-ilat)/res_lat) !Determines the nearest point at 65°N (pole)
  pointT   = nint(1.+(23.-ilat)/res_lat) !Determines the nearest point at 23°N (tropic of Cancer)

  call seasons                           !Calling the subroutine that determines the date of the solstices and equinoxes
  call perigee_apogee                    !Calling the subroutine that determines the date of the perihelion and aphelion
  call solar_longitude                   !Calling the subroutine that determines the true solar longitude                          
  call days_loop                         !Calling the suroutine that invoke the daily insolation and instantaneous solar radiation

  spring=21.
  mon_spring="MAR"  

  if (oblq == 0) then
      spring=0.
      mon_spring="---"
      summer=0.
      mon_summer="---"
      autumn=0.
      mon_autumn="---"
      winter=0.
      mon_winter="---"
  end if

  if (ecc == 0) then
      peri=0.
      mon_peri="---"
      aphel=0.
      mon_aphel="---"
  end if

     
  print *,""
  print *," ---------------------------------------------------------------------"
  print *,"	             DAILY INSOLATION [DINSOL-v1.0] MODEL "            
  print *,""
  print *,"	     Universidade Federal do vale do Sao Francisco - UNIVASF"
  print *," 	             Laboratorio de Meteorologia - LabMet"
  print *," ---------------------------------------------------------------------"

  if (orbital==1) then
      print *,"             Parameterization    =    Berger (1978)"
  else if (orbital==2) then
      print *,"             Parameterization    =    Berger and Loutre (1991)"
  else if (orbital==3) then
      print *,"             Parameterization    =    Laskar et al (2004; 2011)"
  else if (orbital==4) then
      print *,"             Parameterization    =    User-defined values"
  end if

  print "(A,I12)","                      Calendar    =", ndays

  if (orbital == 1 .or. orbital == 2 .or. orbital == 3) then
      print "(A,I12)","                          Year    =", year
  else if (orbital == 4) then
      print "(A,A)","                          Year    =", "         ---"
  end if

  print "(A,f12.1,A)","                            S0    =", S0," W/m^2"

  print *," ---------------------------------------------------------------------"
  print *,"        ORBITAL PARAMETERS       |    SEASONS, PERIGEE and APOGEE    "
  print *," ---------------------------------------------------------------------"


  if (oblq >= 0) then
    
      print "(A,f12.6,A,f12.2,A,A)","   Eccentricity    = ", ecc," |  Spring       = "    &
            , spring,"/",mon_spring
      print "(A,f12.6,A,f12.2,A,A)","   Obliquity       = ", oblq," |  Summer       = "   &
            , summer,"/",mon_summer 
      print "(A,f12.6,A,f12.2,A,A)","   Precession      = ", prcs," |  Autumn       = "   &
            , autumn,"/",mon_autumn
      print "(A,f12.2,A,A)","  --------------------------------|  Winter       = "        &
            , winter,"/",mon_winter 

  else 

      print "(A,f12.6,A,f12.2,A,A)","   Eccentricity    = ", ecc," |  Autumn       = "    &
            , spring,"/",mon_spring
      print "(A,f12.6,A,f12.2,A,A)","   Obliquity       = ", oblq," |  Winter       = "   &
            , summer,"/",mon_summer 
      print "(A,f12.6,A,f12.2,A,A)","   Precession      = ", prcs," |  Spring       = "   &
            , autumn,"/",mon_autumn
      print "(A,f12.2,A,A)","  --------------------------------|  Summer       = "        &
            , winter,"/",mon_winter 

  end if

  print "(A,f10.1,A,A,F12.2,A,A)","   Insol[65N] = ",irrad_avg(pointP)/ndays,"  W/m^2", &
        " |  Perihelion   = ",peri,"/",mon_peri
  print "(A,f10.1,A,A,F12.2,A,A)","   Insol[23N] = ",irrad_avg(pointT)/ndays,"  W/m^2", &
        " |  Aphelion     = ",aphel,"/",mon_aphel
  print *," ---------------------------------------------------------------------"
  print *,"            GLOBAL POINTS        |             RESOLUTION    "
  print *," ---------------------------------------------------------------------"     
  print "(A,I7,A,F12.2,A)","   Points of Longitude = ",nx,"  |  Time Interval  = ",24./nt*1.," hr" 
  print "(A,I7,A,F12.2,A)","   Points of Latitude  = ",ny,"  |  Degree         = ",(res_lat+res_lon)/2.," dg"
  print *," ---------------------------------------------------------------------"
						   
  !Writing descriptor file for GrADS
  write(20,'(A21                      )')'DSET ^solar.radiation'
  write(20,'(A1                       )')'*'
  write(20,'(A13                      )')'*OPTIONS YREV'
  write(20,'(A1                       )')'*'
  write(20,'(A17                      )')'UNDEF -0.1000E+06' 
  write(20,'(A1                       )')'*'
  write(20,'(A42                      )')'TITLE DAILY INSOLATION (DINSOL-v1.0) MODEL'
  write(20,'(A1                       )')'*'
  write(20,'(A22                      )')'XDEF    1 LINEAR  1  1'
  write(20,'(A6,I6,A10,f12.5,A2,f12.5 )')'YDEF   ',ny,' LINEAR   ',ilat,'  ',res_lat
  write(20,'(A18                      )')'ZDEF    1 LEVELS 1'
  write(20,'(A5,I4, A23               )')'TDEF ',ndays,' LINEAR  1JAN1 1dy'
  write(20,'(A6                       )')'VARS 1'
  write(20,'(A35                      )')'rad  0 99 Daily Insolation [W/m^2]'
  write(20,'(A7                       )')'ENDVARS'
  close(20,status='keep')

  if ( ntime == 1 ) tdef='6hr'
  if ( ntime == 2 ) tdef='3hr'
  if ( ntime == 3 ) tdef='1hr'
  if ( ntime == 4 ) tdef='30mn'
  if ( ntime == 5 ) tdef='15mn'
                                                                                 
  !Writing descriptor file for GrADS
  write(25,'(A15                      )')'DSET ^radiation'
  write(25,'(A1                       )')'*'
  write(25,'(A13                      )')'*OPTIONS YREV'
  write(25,'(A1                       )')'*'
  write(25,'(A17                      )')'UNDEF -0.1000E+06' 
  write(25,'(A1                       )')'*'
  write(25,'(A42                      )')'TITLE DAILY INSOLATION (DINSOL-v1.0) MODEL'
  write(25,'(A1                       )')'*'
  write(25,'(A6,I6,A13,f12.5          )')'XDEF   ',nx,' LINEAR   0  ',res_lon
  write(25,'(A6,I6,A10,f12.5,A2,f12.5 )')'YDEF   ',ny,' LINEAR   ',ilat,'  ',res_lat
  write(25,'(A18                      )')'ZDEF    1 LEVELS 1'
  write(25,'(A5,I5, A19, A5           )')'TDEF ',ndays*nt,' LINEAR  1JAN1 ',tdef
  write(25,'(A6                       )')'VARS 1'
  write(25,'(A43                      )')'rad  0 99 Instantaneous irradiation [W/m^2]'
  write(25,'(A7                       )')'ENDVARS'
  close(25,status='keep')
  	  
  !Writing summary file
  write(23,'(A6)   ') "resume"  
  write(23,'(I12)  ') year 
  write(23,'(F12.2)') S0
  write(23,'(I12)  ') nx
  write(23,'(I12)  ') ny
  write(23,'(I12)  ') nt    
  write(23,'(I12)  ') ndays
  write(23,'(I12)  ') orbital
  write(23,'(F12.6)') ecc
  write(23,'(F12.6)') oblq
  write(23,'(F12.6)') prcs
  write(23,'(F12.2)') summer
  write(23,'(A3)   ') mon_summer
  write(23,'(F12.2)') autumn
  write(23,'(A3)   ') mon_autumn
  write(23,'(F12.2)') winter
  write(23,'(A3)   ') mon_winter
  write(23,'(F12.2)') peri
  write(23,'(A3)   ') mon_peri    
  write(23,'(F12.2)') aphel
  write(23,'(A3)   ') mon_aphel    
  write(23,'(F12.2)') irrad_avg(pointP)/ndays
  write(23,'(F12.2)') irrad_avg(pointT)/ndays
  
  end subroutine dinsol_model

!+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

  subroutine orbital_berger1978

  !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
  !                            !
  !       BERGER 1978          !
  !                            ! 
  !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

  use variable_names

  !Converting data from tables
  B78_A      =  B78_Amp1/3600.            
  B78_ff     =  B78_Rate1*arcsec2rad         
  B78_Phi    =  B78_Phase1*deg2rad        
  B78_M      =  B78_Amp4                    
  B78_g      =  B78_Rate4*arcsec2rad        
  B78_Beta   =  B78_Phase4*deg2rad          
  B78_F      =  B78_Amp5*arcsec2rad         
  B78_fp     =  B78_Rate5*arcsec2rad        
  B78_Delta  =  B78_Phase5*deg2rad          

  !Spectral analysis 
  eps        =  e_star78 + sum(B78_A*cos(B78_ff*year+B78_Phi))                    !Obliquity 
  esinpi     =  sum(B78_M*sin(B78_g*year+B78_Beta))                               !Eccentricity
  ecospi     =  sum(B78_M*cos(B78_g*year+B78_Beta))                               !Eccentricity  
  psi        =  psibar78*year + zeta78 + sum(B78_F*sin(B78_fp*year+B78_Delta))    !General Precession

  if (ecospi <= 0) then
  atanpi     =  atan(esinpi/ecospi) + pi
  else
  atanpi     =  atan(esinpi/ecospi)
  end if

  !Orbital parameters
  eps        =  eps*deg2rad
  ecc        =  sqrt(esinpi**2 + ecospi**2)
  varpi      =  amod(atanpi+psi+pi,twopi)

  if (varpi < 0) varpi=varpi+twopi
  omega      =  amod(varpi+pi,twopi)

  !Converting to degree 
  oblq       =  eps*rad2deg
  prcs       =  varpi*rad2deg

  end subroutine orbital_berger1978

!++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

  subroutine orbital_berger1990

  !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
  !                            !
  !    BERGER e LOUTRE 1991    !
  !                            ! 
  !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

  use variable_names

  !Converting data from tables
  B90_A      =  B90_Amp1/3600.
  B90_ff     =  B90_Rate1*arcsec2rad
  B90_Phi    =  B90_Phase1*deg2rad
  B90_M      =  B90_Amp4
  B90_g      =  B90_Rate4*arcsec2rad
  B90_Beta   =  B90_Phase4*deg2rad
  B90_F      =  B90_Amp5*arcsec2rad
  B90_fp     =  B90_Rate5*arcsec2rad
  B90_Delta  =  B90_Phase5*deg2rad  

  !Spectral analysis 
  eps        =  e_star90 + sum(B90_A*cos(B90_ff*year+B90_Phi))                    !Obliquity
  esinpi     =  sum(B90_M*sin(B90_g*year+B90_Beta))                               !Eccentricity
  ecospi     =  sum(B90_M*cos(B90_g*year+B90_Beta))                               !Eccentricity 
  psi        =  psibar90*year + zeta90 + sum(B90_F*sin(B90_fp*year+B90_Delta))    !General Precession

  if (ecospi <= 0) then
  atanpi     =  atan(esinpi/ecospi) + pi
  else
  atanpi     =  atan(esinpi/ecospi)
  end if

  !Orbital parameters
  eps        =  eps*deg2rad
  ecc        =  sqrt(esinpi**2 + ecospi**2)
  varpi      =  amod((atanpi+psi+pi),twopi)

  if (varpi < 0) varpi=varpi+twopi
  omega      =  amod(varpi+pi,twopi)

  !Converting to degree 
  oblq       =  eps*rad2deg
  prcs       =  varpi*rad2deg

  end subroutine orbital_berger1990

!++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

  subroutine orbital_laskar

  !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
  !                                  !
  !     LASKAR et al. (2004; 2011)   !
  !                                  ! 
  !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

  use variable_names

  yr=year/1000               !Referential year
   
  if ( mod(year,1000) == 0 ) then

     !Orbital parameters  
     ecc       =  L_ecc(yref+yr)
     eps       =  L_eps(yref+yr)
     varpi     =  L_varpi(yref+yr)
     omega     =  amod(varpi+pi,twopi)

     !Converting to degree 
     oblq      =  eps*rad2deg
     prcs      =  varpi*rad2deg
  
  else 
  
     t1    = floor(year/1000.)
     t2    = ceiling(year/1000.)
  
     !Orbital parameters  
     ecc       =  (year-t1*1000.)*(L_ecc(yref+t2)-L_ecc(yref+t1))/1000. + L_ecc(yref+t1)
     eps       =  (year-t1*1000.)*(L_eps(yref+t2)-L_eps(yref+t1))/1000. + L_eps(yref+t1)
     varpi     =  (year-t1*1000.)*(L_varpi(yref+t2)-L_varpi(yref+t1))/1000. + L_varpi(yref+t1)
     omega     =  amod(varpi+pi,twopi)

     !Converting to degree 
     oblq      =  eps*rad2deg
     prcs      =  varpi*rad2deg

  end if  

  end subroutine orbital_laskar

!++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

  subroutine solar_longitude

  !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
  !                              !
  !     TRUE SOLAR LONGITUDE     !
  !                              ! 
  !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

  use variable_names
  
  lambd=0     !Initial solar longitude fixed in 21.0 March [Vernal equinox]
  
        !Mean solar longitude at the vernal equinox
        lambd_m   =  lambd - 2*(((1./2.)*ecc+(1./8.)*ecc**3.)*(1.+beta)*sin(lambd-varpi)       &
                     - (1./4.)*(ecc**2.)*((1./2.)+beta)*sin(2.*(lambd-varpi))                  &
                     + (1./8.)*(ecc**3.)*((1./3.)+beta)*sin(3.*(lambd-varpi)))

  !Days loop [true solar longitude]
  do i=1, ndays

        !True solar longitude
        truelong(i)  = lambd_m + (2.*ecc-(1./4.)*ecc**3)*sin(lambd_m-varpi)                    & 
                       + (5./4.)*(ecc**2)*sin(2.*(lambd_m-varpi))                              &
                       + (13./12.)*(ecc**3)*sin(3.*(lambd_m-varpi)) 

        lambd_m=lambd_m+(360./ndays)*deg2rad  !lambd_m increment

  end do

  end subroutine solar_longitude

!++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

  subroutine calendar_function(mday0)

  use variable_names
  
  real :: mday0

  if ( calendar == 1 ) then

    !Occurrence month for a calendar of 365 days 
    if (mday0 > 0. .and. mday0 <= 31.) then
      mday0=mday0
      month="JAN"
    else if (mday0 > 31. .and. mday0 <= 59.) then
      mday0=mday0-31.
      month="FEB"
    else if (mday0 > 59. .and. mday0 <= 90.) then    
      mday0=mday0-59.
      month="MAR" 
    else if (mday0 > 90. .and. mday0 <= 120.) then    
      mday0=mday0-90. 
      month="APR"
    else if (mday0 > 120. .and. mday0 <= 151.) then    
      mday0=mday0-120.
      month="MAY" 
    else if (mday0 > 151. .and. mday0 <= 181.) then    
      mday0=mday0-151.
      month="JUN" 
    else if (mday0 > 181. .and. mday0 <= 212.) then    
      mday0=mday0-181.
      month="JUL" 
    else if (mday0 > 212. .and. mday0 <= 243.) then    
      mday0=mday0-212.
      month="AUG" 
    else if (mday0 > 243. .and. mday0 <= 273.) then    
      mday0=mday0-243. 
      month="SEP"
    else if (mday0 > 273. .and. mday0 <= 304.) then    
      mday0=mday0-273.
      month="OCT" 
    else if (mday0 > 304. .and. mday0 <= 334.) then    
      mday0=mday0-304.
      month="NOV" 
    else if (mday0 > 334. .and. mday0 <= 365.) then    
      mday0=mday0-334.
      month="DEC" 
    end if

  else 

    !Occurrence month for a calendar of 360 days 
    if (mday0 > 0. .and. mday0 <= 30.) then
      mday0=mday0
      month="JAN"
    else if (mday0 > 30. .and. mday0 <= 60.) then
      mday0=mday0-30.
      month="FEB"
    else if (mday0 > 60. .and. mday0 <= 90.) then    
      mday0=mday0-60.
      month="MAR" 
    else if (mday0 > 90. .and. mday0 <= 120.) then    
      mday0=mday0-90. 
      month="APR"
    else if (mday0 > 120. .and. mday0 <= 150.) then    
      mday0=mday0-120.
      month="MAY" 
    else if (mday0 > 150. .and. mday0 <= 180.) then    
      mday0=mday0-150.
      month="JUN" 
    else if (mday0 > 180. .and. mday0 <= 210.) then    
      mday0=mday0-180.
      month="JUL" 
    else if (mday0 > 210. .and. mday0 <= 240.) then    
      mday0=mday0-210.
      month="AUG" 
    else if (mday0 > 240. .and. mday0 <= 270.) then    
      mday0=mday0-240. 
      month="SEP"
    else if (mday0 > 270. .and. mday0 <= 300.) then    
      mday0=mday0-300.
      month="OCT" 
    else if (mday0 > 300. .and. mday0 <= 330.) then    
      mday0=mday0-300.
      month="NOV" 
    else if (mday0 > 330. .and. mday0 <= 360.) then    
      mday0=mday0-330.
      month="DEC" 
    end if

  end if
  
  mday  = mday0

  end subroutine calendar_function

!++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

  subroutine perigee_apogee

  !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
  !                                     !
  !     PERIHELION AND APHELION DAY     !
  !                                     ! 
  !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

  use variable_names 
 
  !Perihelion day
  peri =  -varpi - 2*(((1./2.)*ecc+(1./8.)*ecc**3.)*(1.+beta)*sin(-varpi)   &
                   - (1./4.)*(ecc**2.)*((1./2.)+beta)*sin(2.*(-varpi))      &
                   + (1./8.)*(ecc**3.)*((1./3.)+beta)*sin(3.*(-varpi)))

  if ( calendar == 1 ) then    
    peri  = amod(80.*deg2rad + abs(peri)*(ndays/360.), ndays*deg2rad)*rad2deg   !Perihelion date to a 365 days calendar   
    aphel = amod(peri+ndays/2., 365.)                                           !Aphelion date to a 365 days calendar
  else   
    peri  = amod(81.*deg2rad + abs(peri)*(ndays/360.), ndays*deg2rad)*rad2deg   !Perihelion date to a 360 days calendar    
    aphel = amod(peri+ndays/2., 360.)                                           !Aphelion date to a 360 days calendar  
  end if 

  !Calculate month and day for perihelion
  call calendar_function(peri)
  peri     = mday
  mon_peri = month

  !Calculate month and day for aphelion
  call calendar_function(aphel)
  aphel     = mday
  mon_aphel = month
	
  end subroutine perigee_apogee

!++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

  subroutine seasons

  !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
  !                                               !
  !     OCCURRENCE OF SOLSTICES AND EQUINOXES     !
  !                                               ! 
  !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

  use variable_names

  lambd=0       !Initial solar longitude fixed in 21.0 March [Vernal equinox]

        !Mean solar longitude at the vernal equinox	
        lambd_m   =  lambd - 2*(((1./2.)*ecc+(1./8.)*ecc**3.)*(1.+beta)*sin(lambd-varpi)   &
            - (1./4.)*(ecc**2.)*((1./2.)+beta)*sin(2.*(lambd-varpi))       &
            + (1./8.)*(ecc**3.)*((1./3.)+beta)*sin(3.*(lambd-varpi)))

  !Days loop [True solar longitude]
  do i=1, ndays*trunc
 
        !True solar longitude 
        truelong_seasons(i)  = lambd_m + (2.*ecc-(1./4.)*ecc**3)*sin((lambd_m-varpi))    & 
            +  (5./4.)*(ecc**2)*sin(2.*(lambd_m-varpi))      &
            +  (13./12.)*(ecc**3)*sin(3.*(lambd_m-varpi)) 

        lambd_m=lambd_m+(360./(ndays*trunc))*deg2rad    !lambd_m increment

  end do

  !Seasons days
  summerloc = minloc(abs(truelong_seasons - pi/2.), 1)
  summer    = (summerloc(1) + vernal_point)/trunc

  autumnloc = minloc(abs(truelong_seasons - pi), 1)
  autumn    = (autumnloc(1) + vernal_point)/trunc

  winterloc = minloc(abs(truelong_seasons - (3./2.)*pi), 1)
  winter    = (winterloc(1) + vernal_point)/trunc

  if (summer > ndays) summer = summer-ndays
  if (winter > ndays) winter = winter-ndays
  if (autumn > ndays) autumn = autumn-ndays

  !Calculate month and day for summer
  call calendar_function(summer)
  summer     = mday
  mon_summer = month

  !Calculate month and day for winter
  call calendar_function(winter)
  winter     = mday
  mon_winter = month

  !Calculate month and day for autumn
  call calendar_function(autumn)
  autumn     = mday
  mon_autumn = month

  end subroutine seasons

!++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

  subroutine days_loop

  use variable_names

  write(21,'(A65)') ' Year   Day  TrueLong  Rho   Lat  Decl  Sunshine  Insol'

  irrad_avg = 0    !Daily insolation annual average - starter

  !Printing the values of insolation and daylength in the terminator
  print *,""
  print *," DINSOL SIMULATION"
  print *,""
  print *,"--------------------------------------------------------------" 
  print *,"|  Day |    Insol(65N)  -  Hours |    Insol(23N)  -  Hours   |"
  print *,"--------------------------------------------------------------" 
  
  !Days loop [true solar longitude]
  do i=1, ndays

     !True solar longitude calendar conversion 
     cldr = i + calendar_converter
     if (cldr > ndays) cldr=cldr-ndays

     call daily_insolation
     call instantaneous_irradiance
     call output_data(i, irrad_avg, insol, Hrad)

     print "(I7, A, F12.2, F12.2, A, F12.2, F12.2)", i, " |", insol(pointP), NH0(pointP), " |",insol(pointT), NH0(pointT)

  end do

  end subroutine days_loop

!++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

  subroutine daily_insolation

  !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
  !                                             !
  !     DAILY INSOLATION FROM BERGER (1978)     !
  !                                             ! 
  !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

   use variable_names
      
  !Latitudinal daily insolation loop
  do y=1, ny

          j               =  ilat+res_lat*(y-1)                             !Latitudinal increment           			  
          lat             =  j*deg2rad                                      !Latitude conversion to radians                                 			  
          nu              =  truelong(cldr)-varpi                           !True anomaly  
          rho             =  (1.-ecc**2)/(1.+ecc*cos(nu))                   !Earth-sun distance
          sindecl         =  sin(eps)*sin(truelong(cldr))                   !Sine of solar declination
          cosdecl         =  sqrt(1.-sindecl**2)                            !Cosine of solar declination 
          cosH0           =  -(sin(lat)/cos(lat))*(sindecl/cosdecl)         !Cosine of hour angle  
   if (cosH0 < -1) cosH0  =  -1.                                            !Condition 1 for H0                                                              
   if (cosH0 >  1) cosH0  =  1.                                             !Condition 2 for H0  
          sinH0           =  sqrt(1-cosH0**2)                               !Sine of hour angle
          H0              =  acos(cosH0)                                    !Hour angle
          NH0(y)          =  2.*H0*rad2deg/15.                              !Sunshine duration
          insol(y)        =  (1./pi)*(S0*(1/rho**2))*(H0*sin(lat)*sindecl+  &   !Daily insolation
                             cos(lat)*cosdecl*sinH0)     
                    
    !Write informations and data to text file   
    write(21,'(I12, I5, F12.2, F12.6, F12.2, F12.2, F12.2, F12.2)') year, i, truelong(cldr)*rad2deg, &
                                                     rho, lat*rad2deg, asin(sindecl)*rad2deg, NH0(y), insol(y)

  end do

  end subroutine daily_insolation

!++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

  subroutine instantaneous_irradiance

  !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
  !                                             !
  !        INSTANTANEOUS IRRADIANCE             !
  !                                             ! 
  !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
  
  use variable_names
  
  !Time hours loop
  do time=1, nt

     !Latitudinal irradiance loop
     do y=1, ny

        j        =  ilat+res_lat*(y-1)                 !Latitudinal increment 
        lat      =  j*deg2rad                          !Latitude conversion to radians                       
        nu       =  truelong(cldr)-varpi               !True anomaly  
        rho      =  (1.-ecc**2)/(1.+ecc*cos(nu))       !Earth-sun distance
        sindecl  =  sin(eps)*sin(truelong(cldr))       !Sine of solar declination
        cosdecl  =  sqrt(1.-sindecl**2)                !Cosine of solar declination 
 
          !Longitudinal irradiance loop                              
          do x=1, nx   
            			                      
             hh          =  -pi+(2*pi/nt)*(time-1) + (2*pi/nx)*(x-1)     !Time and longitudinal increment             
             ll          =  (ny*nx)*(time-1) + nx*(y-1) + x              !Calculate the sequential position from loop
             Hrad(ll)    =  (S0/rho**2)*(sin(lat)*sindecl+  &            !Instantaneous irradiance 
                             cos(lat)*cosdecl*cos(abs(hh)))    
                                                               
          end do

      end do      

  end do 

  end subroutine instantaneous_irradiance

!++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

  subroutine output_data(i0, irrad_avg0, insol0, Hrad0)

  !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
  !                                             !
  !        WRITING DATA IN BINARY FILES         !
  !                                             ! 
  !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

  use variable_names

    integer                   ::   i0  
    real, dimension(ny)       ::   irrad_avg0, insol0
    real, dimension(nt*ny*nx) ::   Hrad0
   
    irrad_avg0=irrad_avg0+insol0   !Increment for annual average of the daily insolation  
    where (Hrad0 < 0.) Hrad0=0.

    write(22,rec=i0) insol0        !Writing daily insolation to a binary file
    write(24,rec=i0) Hrad0         !Writing global radiation to a binary file
     
  end subroutine output_data

