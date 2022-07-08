# dinsol-v1.0

The Daily INSOLationi (DINSOL-v1.0) is a model that simulates the incoming solar radiation at the top of the atmosphere following the Milankovitch cycles. The program is ideal for preparing the boundary conditions of climate models, beyond to be a helpful tool for educational purposes. The program allows the user to design the solar radiation data using many options, such as setting the number of points of latitude and longitude, the solar constant, a calendar of 365 or 360 days, or choosing between the most famous parameterizations to the Earth orbital parameters (EOP): Be78, Be90, and Laskar. The users can also set the EOP freely, which allows simulating the solar radiation of hypothetical cases, such as exoplanets. Moreover, by adopting the graphical user interface (GUI), the users can run the tool intuitively and generate many windows containing the results individually. The most important advantage of adopting the DINSOL is to simulate the global solar radiation, which considers the effect of the Earth's rotation on incoming solar radiation by a realistic approach. Thus, the DINSOL is a good option for students, teachers, and researchers that needs to perform some scientific study or only want to teach about solar radiation for paleoclimatology, astronomy, mathematics, or any other geoscience area.

 ***************************************
 * INSTALLATION: EXTERNAL REQUIREMENTS 
 ***************************************

 The DINSOL model requires the following external libraries:

   - Make
   - Fortran 90 standard compiler
   - R-base (colorRamps and maps packages)
   - GrADS 2
   - Python 2.7
   - PyGTK 2
   - libcanberra-gtk-module
   - libpango
   - fonts-crosextra-carlito
   - Shell
   - Linux or Unix style system
  
 Note that only Make and Fortran 90 compiler installation, 
 already allow to running the DINSOL model without the 
 graphical interface.  

 ---------------------------------------------------------------------------- 
 ***********************************************
 * SUPPORTED COMPILERS AND OPERATIONAL SYSTEMS 
 ***********************************************

 We built DINSOL on different Fortran compilers (PGI, Intel, and GNU) 
 and Unix/Linux-type systems (Ubuntu and Manjaro). However, we also 
 built the source code on Windows systems, where GCC and  MSYS were 
 necessary. Although we did not have installed DINSOL on the macOS yet,
 the users should get a clean installation.

 ----------------------------------------------------------------------------
 ************** 
 * INPUT DATA 
 **************

 In the input directory are the data that enter the subroutines that 
 calculate the orbital parameters. These data were obtained and adapted
 for DINSOL from other programs. This data can be found from the links
 available below. Note that these data represent some distinguished 
 researchers' years of hard work. Therefore, cite these researchers' 
 work and the DINSOL developer.

    ----------------------------------------------------------
         Université catholique de Louvain (UCLouvain):

          André Berger, Michel Crucifix, Qiuzhen Yin.

        https://www.elic.ucl.ac.be/modx/index.php?id=83
   ----------------------------------------------------------

         Virtual Observatory (VO) Paris data center 
         Institut de Mécanique Céleste et de Calcul
         des Éphémérides "(IMCCE)

            Laskar, J; Robutel, P; Joutel, F; 
            Gastineau, M; Correia, ACM; Levrard, B.

     http://vo.imcce.fr/insola/earth/online/earth/earth.html
    ----------------------------------------------------------
    
 ---------------------------------------------------------------------------- 
 *********************** 
 * COMPILING THE MODEL 
 ***********************

 After installing the required libraries, the users must go into folder
 "source/" and type:

   make dinsol
 
 Then, It makes the binary file dinsol.exe. Now, the model is ready to
 run from command lines.
 
 ---------------------------------------------------------------------------- 
 *************** 
 * SIMULATIONS 
 ***************
 
 ***-> Command lines <-***
 
 In order to run the model, It only needs to type on the main directory:

   ./dinsol.exe

 and wait for the simulation to finish. Note that the command lines mode
 require only Make and Fortran compiler installation.


 ***-> Graphical User Interface (GUI) <-***
 
 If you installed all the libraries correctly, the model must run easily 
 from GUI mode. Note that the text format and layout can change on different 
 operational systems. However, it doesn't affect the simulations, and you
 can edit and format the text in the GUI.py file for adjustments. 
 
 Thus, for open GUI window, you must type on terminal:

 ./GUI.py

 Nevertheless, before executing the simulation, you need to run the Shell 
 script "replace.sh". This script builds some simulations and uses his result
 files on GUI mode. The script is located in the folder "output/.0K" and
 you must execute:

 ./replace.sh

 Note: you will need to wait some minutes until the finish.
 
 ----------------------------------------------------------------------------   
 *************** 
 *  NAMELIST   
 ***************
 
 YEAR  - The Year chosen by the user can be any integer number. Note: zero
         represents the present time, which is equivalent to the year 
         1950 CE in the Berger 78 parameterization. The user can adopt 
         any integer value for the variable Year, as long as it respects
         the range -249 through 21 [10^6 yr’s].

 S0    - Defines the value of the Solar Constant adopted in the simulation, 
         the default unit is [W/m^2]. Note: S0 must be within the range
         ]0:10^8[

 NY    - Determines the number of latitude points.
 NX    - Determines the number of longitude points. 

 NTIME - Determines the time interval within 1 day, given in hours or 
         minutes.

         1 – 6 hours [0h ; 6h ; 12h ; 18h]
         2 – 3 hours [0h ; 3h ; 6h ; 9h ; 12h; 15h ; 18h; 21h]
         3 – 1 hours [0h ; 1h ; 2h ; 3h ... 22h ; 23h]
         4 – 30 mn   [0h ; 0.5h ; 1.0h ; 1.5h ; 2.0h ... 23.0h ; 23.5h]
         5 – 15 mn   0h ; 0.25h ; 0.5h ; 0.75h; 1.0h ... 23.5h ; 23.75h]

 CALENDAR - Defines the number of days in the year:

         1 – 365 dias
         2 – 360 dias
         
 ORBITAL - Defines the method for calculating the orbital parameters:

         1 - Berger (1978) is defined; accuracy of +/- 1 x 10^6 yr's.
         
         2 - Berger e Loutre (1991) is defined; accuracy of +/- 3 x 10^6 yr's.

         3 - Laskar et al (2004; 2011) is defined; accuracy of -249 x 10^6
             through +21 x 10^6 yr's.
             
         4 - User-defined is defined; the user can freely choose the values 
             of the orbital parameters, having only to respect the valid 
             ranges for Eccentricity, Obliquity and General Precession.

   ECC  - User can choose any value in the range [0:0.5]

   OBLQ - User can choose any value in the range [-90:90], the unit of 
          measurement is given in degrees.

   PRCS - User can choose any value in the range [0:360[, the unit of 
          measurement is given in degrees.
           
 ----------------------------------------------------------------------------   
 ******************** 
 *  OUTPUT RESULTS  
 ********************

 The result files are made on output folder:
 
    -------------------------------------------------
       - solar.radiation / solar.radiation.ctl
       - radiation / radiation.ctl
       - insolation.txt
       - summary.txt
    -------------------------------------------------    

 Note that some scripts are available to assist the users in analyzing the
 result files.
 
    ---------------------------------
        - get_dinsol_value.R
        - plot_dinsol.R
        - plot_global.R
        - plot_dinsol.gs
        - plot_radiation.gs
    ---------------------------------
 
 You must edit these templates in concordance with your interests. Note that
 ".gs" files are simple GrADS scripts.
 
 ----------------------------------------------------------------------------   

 ********************************************* 
 *  GO AHEAD AND USE/SHARE THE DINSOL MODEL  
 *********************************************

 We hope you enjoy the DINSOL model, and if you have any questions, please 
 send an email: emerson.oliveira@univasf.edu.br

 Good Luck! / Boa Sorte!

 Best regards,

 Ph.D. Emerson D. Oliveira
 Climatologist, Laboratório de Meteorologia (LabMet)
 Federal University of São Francisco Valley - UNIVASF


