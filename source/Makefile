  ##########################################################################################
  #                                                                                        #
  #                       DAILY INSOLATION (DINSOL-v1.0) MODEL                             #
  #                                                                                        #
  #                Universidade Federal do Vale do São Francisco - UNIVASF                 #
  #                       Laboratório de Meteorologia - LabMet                             #
  #                                                                                        #
  #   Author: Emerson Damasceno de Oliveira                                                #
  #   Last update: 17 January 2022                                                         #
  #                                                                                        #
  #   contact: emerson.oliveira@univasf.edu.br                                             #
  #                                                                                        #
  #  ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++  #
  #                                                                                        #
  #  Copyright (C) <2022>  <Emerson Damasceno de Oliveira>                                 #
  #                                                                                        #
  #  This program is free software: you can redistribute it and/or modify                  #
  #  it under the terms of the GNU General Public License as published by                  #
  #  the Free Software Foundation, either version 3 of the License, or                     #
  #  (at your option) any later version.                                                   #
  #                                                                                        #
  #  This program is distributed in the hope that it will be useful,                       #
  #  but WITHOUT ANY WARRANTY; without even the implied warranty of                        #
  #  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the                         #
  #  GNU General Public License for more details.                                          #
  #                                                                                        #
  #  You should have received a copy of the GNU General Public License                     #
  #  along with this program.  If not, see <https://www.gnu.org/licenses/>.                #
  #                                                                                        #
  ##########################################################################################


.SUFFIXES: .f90 .f95 .o .mod
.SHELL: /bin/sh
.PHONY : usage

usage:
	@echo ""
	@echo "    * USAGE * "
	@echo ""	  
	@echo " make dinsol  : source code compilation"
	@echo " make clean   : clean object files"
	@echo " make"																

 #set 1 for your fortran compiler and set blank for others                   
 ifort = 
 gfortran = 1
 pgfortran = 

 ifdef ifort
 	FC     = ifort
	LFLAGS = 
	DFLAGS = -O3
 else ifdef gfortran
	FC     = gfortran
	LFLAGS = 
	DFLAGS = -O3
 else ifdef pgfortran
 	FC     = pgf95
 	LFLAGS = 
 	DFLAGS = -O3       	
 endif

 EXEC=../dinsol.exe

 OBJ= \
	dinsol.o \
	main.o

dinsol: $(OBJ)
	$(FC) -o $(EXEC) $(OBJ)

dinsol.o : dinsol.f90
	$(FC) $(LFLAGS) -c $(DFLAGS) dinsol.f90

main.o : main.f90 dinsol.o
	$(FC) $(LFLAGS) -c $(DFLAGS) main.f90

clean:
	@echo ""	
	@echo " **** Clean object files .o .mod ****"
	@echo ""
	rm -f ../dinsol.exe *.o *.mod 
	@echo ""
	@echo " **** Finishing ****"
	@echo "" 
