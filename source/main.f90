  !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
  !                                                                                        !
  !                       DAILY INSOLATION (DINSOL-v1.0) MODEL                             !
  !                                                                                        !
  !                Universidade Federal do Vale do São Francisco - UNIVASF                 !
  !                       Laboratório de Meteorologia - LabMet                             !
  !                                                                                        !
  !   Author: Emerson Damasceno de Oliveira                                                !
  !   Last update: 17 January 2022                                                         !
  !                                                                                        !
  !   contact: emerson.oliveira@univasf.edu.br                                             !
  !                                                                                        !
  !  ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++  !
  !                                                                                        !
  !  Copyright (C) <2022>  <Emerson Damasceno de Oliveira>                                 !
  !                                                                                        !
  !  This program is free software: you can redistribute it and/or modify                  !
  !  it under the terms of the GNU General Public License as published by                  !
  !  the Free Software Foundation, either version 3 of the License, or                     !
  !  (at your option) any later version.                                                   !
  !                                                                                        !
  !  This program is distributed in the hope that it will be useful,                       !
  !  but WITHOUT ANY WARRANTY; without even the implied warranty of                        !
  !  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the                         !
  !  GNU General Public License for more details.                                          !
  !                                                                                        !
  !  You should have received a copy of the GNU General Public License                     !
  !  along with this program.  If not, see <https://www.gnu.org/licenses/>.                !
  !                                                                                        !
  !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

  program dinsol_main

  use variable_names
    
  !Opening and reading namelist data
  open(unit=10,file='namelist')
  read(10,inputs)

  if (year >= -249e6 .and. year <= 21e6) then 

  if (S0 > 0. .and. S0 < 1e8)  then

  if (NY >= 1 .or. NX >= 1) then

  if (NTIME == 1 .or. NTIME == 2 .or. NTIME == 3 .or. NTIME == 4 .or. NTIME == 5) then

  if (calendar == 1 .or. calendar == 2) then

  if (orbital == 1 .or. orbital == 2 .or. orbital == 3 .or. orbital == 4) then

  if (ecc >= 0. .and. ecc <= 0.5) then 

  if (oblq >= -90. .and. oblq <= 90.) then

  if (prcs >= 0. .and. prcs < 360.) then
  
     !Defining the time scale
     if ( ntime == 1 ) nt=4
     if ( ntime == 2 ) nt=8
     if ( ntime == 3 ) nt=24
     if ( ntime == 4 ) nt=48
     if ( ntime == 5 ) nt=96                                                      
                         
     !Opening data tables
     open(11,file='input/BERGER_1978/B78_Table1.bin', ACCESS='DIRECT',FORM='UNFORMATTED', RECL=ireal*B78_nt1)
     open(12,file='input/BERGER_1978/B78_Table4.bin', ACCESS='DIRECT',FORM='UNFORMATTED', RECL=ireal*B78_nt4)
     open(13,file='input/BERGER_1978/B78_Table5.bin', ACCESS='DIRECT',FORM='UNFORMATTED', RECL=ireal*B78_nt5)
     open(14,file='input/BERGER_1990/B90_Table1.bin', ACCESS='DIRECT',FORM='UNFORMATTED', RECL=ireal*B90_nt1)
     open(15,file='input/BERGER_1990/B90_Table4.bin', ACCESS='DIRECT',FORM='UNFORMATTED', RECL=ireal*B90_nt4)
     open(16,file='input/BERGER_1990/B90_Table5.bin', ACCESS='DIRECT',FORM='UNFORMATTED', RECL=ireal*B90_nt5)
     open(17,file='input/LASKAR_2004_2011/ecc.bin',   ACCESS='DIRECT',FORM='UNFORMATTED', RECL=ireal*La_nt)
     open(18,file='input/LASKAR_2004_2011/eps.bin',   ACCESS='DIRECT',FORM='UNFORMATTED', RECL=ireal*La_nt)
     open(19,file='input/LASKAR_2004_2011/varpi.bin', ACCESS='DIRECT',FORM='UNFORMATTED', RECL=ireal*La_nt)

     !Reading data table
     read(11, rec=1) B78_Tb1(:)
     read(12, rec=1) B78_Tb4(:)
     read(13, rec=1) B78_Tb5(:)
     read(14, rec=1) B90_Tb1(:)
     read(15, rec=1) B90_Tb4(:)
     read(16, rec=1) B90_Tb5(:)
     read(17, rec=1) L_ecc(:)
     read(18, rec=1) L_eps(:)
     read(19, rec=1) L_varpi(:)

     !Opening files to record results
     open(20,file='output/solar.radiation.ctl',form='formatted',action='write',status='unknown')
     open(21,file='output/insolation.txt',form='formatted',action='write',status='unknown')
     open(22,file='output/solar.radiation',access='direct',form='unformatted',recl=ireal*ny)
     open(23,file='output/summary.txt',form='formatted',action='write',status='unknown')
     open(24,file='output/radiation',access='direct',form='unformatted',recl=ireal*ny*nx*nt)
     open(25,file='output/radiation.ctl',form='formatted',action='write',status='unknown')

     !Berger 78 variable names
     B78_Amp1     =  B78_Tb1(1:47)
     B78_Rate1    =  B78_Tb1(48:94)
     B78_Phase1   =  B78_Tb1(95:141)
     B78_Period1  =  B78_Tb1(142:188)

     B78_Amp4     =  B78_Tb4(1:19)
     B78_Rate4    =  B78_Tb4(20:38)
     B78_Phase4   =  B78_Tb4(39:57)
     B78_Period4  =  B78_Tb4(58:76)

     B78_Amp5     =  B78_Tb5(1:78)
     B78_Rate5    =  B78_Tb5(79:156)
     B78_Phase5   =  B78_Tb5(157:234)
     B78_Period5  =  B78_Tb5(235:312)

     !Berger and Loutre 91 variable names
     B90_Amp1     =  B90_Tb1(1:1000)
     B90_Rate1    =  B90_Tb1(1001:2000)
     B90_Phase1   =  B90_Tb1(2001:3000)
     B90_Period1  =  B90_Tb1(3001:4000)

     B90_Amp4     =  B90_Tb4(1:80)
     B90_Rate4    =  B90_Tb4(81:160)
     B90_Phase4   =  B90_Tb4(161:240)
     B90_Period4  =  B90_Tb4(241:320)

     B90_Amp5     =  B90_Tb5(1:1000)
     B90_Rate5    =  B90_Tb5(1001:2000)
     B90_Phase5   =  B90_Tb5(2001:3000)
     B90_Period5  =  B90_Tb5(3001:4000)

     !Calling program that runs all subroutines
     call dinsol_model

  else

  print *,""
  print *,""
  print *," --> INVALID PRECESSION -- "
  print *,""
  print *," --> set [0:360[ degrees <--"
  print *,""
  print *,""

  end if

  else

  print *,""
  print *,""
  print *," --> INVALID OBLIQUITY -- "
  print *,""
  print *," --> set [-90:90] degrees <--"
  print *,""
  print *,""

  end if

  else

  print *,""
  print *,""
  print *," --> INVALID ECCENTRICITY -- "
  print *,""
  print *," --> set [0:0.5] <--"
  print *,""
  print *,""

  end if

  else

  print *,""
  print *,""
  print *," --> INVALID ORBITAL -- "
  print *,""
  print *," --> set [1;2;3;4] <--"
  print *,""
  print *,""

  end if

  else

  print *,""
  print *,""
  print *," --> INVALID CALENDAR -- "
  print *,""
  print *," --> set [1;2] <--"
  print *,""
  print *,""

  end if

  else

  print *,""
  print *,""
  print *," --> INVALID NTIME -- "
  print *,""
  print *," --> set [1;2;3;4;5] <--"
  print *,""
  print *,""

  end if

  else

  print *,""
  print *,""
  print *," --> INVALID NX OR NY -- "
  print *,""
  print *," --> set NX >= 1 and NY >= 1 <--"
  print *,""
  print *,""

  end if

  else

  print *,""
  print *,""
  print *," --> INVALID S0 -- "
  print *,""
  print *," --> set S0 > 0 and S0 < 10^8 [W/m^2] <--"
  print *,""
  print *,""

  end if

  else

  print *,""
  print *,""
  print *," --> INVALID YEAR -- "
  print *,""
  print *," --> set [-249:21] Myrs <--"
  print *,""
  print *,""

  end if

  end program dinsol_main
