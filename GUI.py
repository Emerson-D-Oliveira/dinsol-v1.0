#!/usr/bin/python 

  ###########################################################################################  
  #                                                                                         #
  #                         DAILY INSOLATION (DINSOL-v1.0) MODEL                            #
  #                                                                                         #
  #                  Universidade Federal do Vale do Sao Francisco - UNIVASF                #
  #                         Laboratorio de Meteorologia - LabMet                            #
  #                                                                                         #
  #                            GRAPHICAL USER INTERFACE - GUI                               #
  #                                                                                         #
  #                                                                                         #
  #    This program calculates the value of the earth's orbital parameters and the daily    #
  #    insolation for a given year.                                                         #
  #                                                                                         #
  #    The user may to adopt: Berger 1978; Berger and Loutre 1991; Laskar et al 2004; 2011. #
  #                                                                                         # 
  #    With this program, it is also possible to define the orbital parameters arbitrarily. #
  #    However, while respecting the intervals:                                             #
  #                                                                                         #
  #            ECCENTRICITY = [0,0.5] ; OBLIQUITY=[-90,90] ; PRECESSION=[0,360[             #
  #                                                                                         #
  #    The daily insolation is calculated according to Berger (1978).                       #
  #                                                                                         #
  #    Author: Emerson Damasceno de Oliveira                                                #
  #    Last update: 17 January 2022                                                         #
  #                                                                                         #
  #    contact: emerson.oliveira@univasf.edu.br                                             #
  #                                                                                         #
  #  ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++   #
  #                                                                                         #
  #   Copyright (C) <2022>  <Emerson Damasceno de Oliveira>                                 #
  #                                                                                         #
  #   This program is free software: you can redistribute it and/or modify                  #
  #   it under the terms of the GNU General Public License as published by                  #
  #   the Free Software Foundation, either version 3 of the License, or                     #
  #   (at your option) any later version.                                                   #
  #                                                                                         #
  #   This program is distributed in the hope that it will be useful,                       #
  #   but WITHOUT ANY WARRANTY; without even the implied warranty of                        #
  #   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the                         #
  #   GNU General Public License for more details.                                          #
  #                                                                                         #
  #   You should have received a copy of the GNU General Public License                     #
  #   along with this program.  If not, see <https://www.gnu.org/licenses/>.                #
  #                                                                                         #
  ###########################################################################################


import pygtk
pygtk.require('2.0')
import gtk
import pango
import os

class PyApp(gtk.Window):
   def __init__(self):
      super(PyApp, self).__init__()
      self.set_title("Daily Insolation Model ")

      self.set_default_size(313,675)
      self.set_position(gtk.WIN_POS_NONE)

      self.eccentricity = 0.0167
      self.obliquity    = 23.446
      self.precession   = 282.04

      self.logo = gtk.gdk.pixbuf_new_from_file(".icons/logo_name_gui.png")
      self.gear = gtk.gdk.pixbuf_new_from_file(".icons/gear_new.png")

      image1 = gtk.Image()
      image1.set_from_pixbuf(self.logo)

      image2 = gtk.Image()
      image2.set_from_pixbuf(self.gear)

      combobox1 = gtk.ComboBox()
      store1 = gtk.ListStore(str)
      cell1 = gtk.CellRendererText()
      combobox1.pack_start(cell1)
      combobox1.add_attribute(cell1, 'text', 0)

      combobox2 = gtk.ComboBox()
      store2 = gtk.ListStore(str)
      cell2 = gtk.CellRendererText()
      combobox2.pack_start(cell2)
      combobox2.add_attribute(cell2, 'text', 0)

      combobox3 = gtk.ComboBox()
      store3 = gtk.ListStore(str)
      cell3 = gtk.CellRendererText()
      combobox3.pack_start(cell3)
      combobox3.add_attribute(cell3, 'text', 0)

      combobox4 = gtk.ComboBox()
      store4 = gtk.ListStore(str)
      cell4 = gtk.CellRendererText()
      combobox4.pack_start(cell4)
      combobox4.add_attribute(cell4, 'text', 0)
      
      adj1 = gtk.Adjustment(0.016, 0.0, 0.6, 0.001, 0.1, 0.1)
  
      scale1 = gtk.HScale(adj1)
      scale1.set_update_policy(gtk.UPDATE_CONTINUOUS)
      scale1.set_digits(3)
      scale1.set_size_request(190, 45)
      scale1.connect("value-changed", self.on_changed5)

      adj2 = gtk.Adjustment(23.44, -90.0, 91.0, 0.1, 1, 1)

      scale2 = gtk.HScale(adj2)
      scale2.set_update_policy(gtk.UPDATE_CONTINUOUS)
      scale2.set_digits(2)
      scale2.set_size_request(190, 45)
      scale2.connect("value-changed", self.on_changed6)

      adj3 = gtk.Adjustment(282.04, 0.0, 360.0, 0.1, 1, 1)

      scale3 = gtk.HScale(adj3)
      scale3.set_update_policy(gtk.UPDATE_CONTINUOUS)
      scale3.set_digits(2)
      scale3.set_size_request(190, 45)
      scale3.connect("value-changed", self.on_changed7)

      self.year        = gtk.Label("Year:  ")
      self.year_input  = gtk.Entry()
      self.solar       = gtk.Label("S0:  ")
      self.strwm2      = gtk.Label("[W/m^2]")
      self.solar_input = gtk.Entry()
      self.spatial_res = gtk.Label("Spatial Resolution:")
      self.time_inter  = gtk.Label("Time Interval:")
      self.calendar    = gtk.Label("Calendar:")
      self.lbd1        = gtk.Label("Orbital:")
      self.dfvalue     = gtk.Label("------------------- User-define Value -----------------")
      self.eccentri    = gtk.Label("Eccentricity:")
      self.obliquit    = gtk.Label("Obliquity:")
      self.precessi    = gtk.Label("Precession:")
      self.endfvalue   = gtk.Label("--------------------------------------------------------------------")
      self.inst1       = gtk.Label("UNIVASF/LabMet  -  BR") 
      self.inst2       = gtk.Label("DINSOL-v1.0") 

      fontdesc  = pango.FontDescription("Carlito 9")
      self.inst1.modify_font(fontdesc)
      self.inst2.modify_font(fontdesc)

      fixed = gtk.Fixed()
      fixed.put(image1, 60, 15)
      fixed.put(self.year, 20,82)
      fixed.put(self.year_input, 60,75)
      fixed.put(self.solar, 20,135)
      fixed.put(self.solar_input, 60,125)
      fixed.put(self.strwm2, 240, 135)
      fixed.put(self.spatial_res, 20,180)
      fixed.put(self.time_inter, 20,225)
      fixed.put(self.calendar, 20,270)
      fixed.put(self.lbd1, 20,315)
      fixed.put(self.dfvalue, 20, 355)
      fixed.put(self.eccentri, 20,400)
      fixed.put(self.obliquit, 20,450)
      fixed.put(self.precessi, 20,500)
      fixed.put(self.endfvalue, 20,525)

      fixed.put(combobox1, 210, 175)
      fixed.put(combobox2, 205, 220)
      fixed.put(combobox3, 190, 265)
      fixed.put(combobox4, 80, 310)
      fixed.put(scale1, 105, 380)
      fixed.put(scale2, 105, 430)
      fixed.put(scale3, 105, 480)

      self.btn = gtk.Button("       Execute")
      self.btn.connect("clicked",self.hello)
      fixed.put(self.btn,80,560)
      fixed.put(image2, 95,577)
      fixed.put(self.inst1, 10, 660)  
      fixed.put(self.inst2, 10, 650)

      self.btn2 = gtk.Button("License")
      self.btn2.connect("clicked",self.msg)
      fixed.put(self.btn2, 215,635)  
 
      self.btn.set_property("width-request", 130)
      self.btn.set_property("height-request", 60)
      
      self.btn2.set_property("width-request",  90)
      self.btn2.set_property("height-request", 35)      

	
      self.add(fixed)

      store1.append (["5   dg"])
      store1.append (["4   dg"])
      store1.append (["3   dg"])
      store1.append (["2   dg"])
      store1.append (["1   dg"])
      store1.append (["0.5 dg"])

      store2.append (["6   hr"])
      store2.append (["3   hr"])
      store2.append (["1   hr"])
      store2.append (["30  mn"])
      store2.append (["15  mn"])

      store3.append (["365 days"])
      store3.append (["360 days"])

      store4.append (["Berger (1978)"])
      store4.append (["Berger and Loutre (1991)"])
      store4.append (["Laskar et al (2004; 2011)"])
      store4.append (["User-define value"])


      combobox1.set_model(store1)
      combobox1.connect('changed', self.on_changed1)
      combobox1.set_active(0)

      combobox2.set_model(store2)
      combobox2.connect('changed', self.on_changed2)
      combobox2.set_active(0)
     
      combobox3.set_model(store3)
      combobox3.connect('changed', self.on_changed3)
      combobox3.set_active(0)

      combobox4.set_model(store4)
      combobox4.connect('changed', self.on_changed4)
      combobox4.set_active(0)

      self.connect("destroy", gtk.main_quit)
      self.show_all()

      return    

   def on_changed1(self, widget):
      self.resolution = widget.get_active()+1

      if (self.resolution == 1): 
          self.nx = 72
          self.ny = 36 
      elif (self.resolution == 2): 
          self.nx = 90
          self.ny = 45 
      elif (self.resolution == 3): 
          self.nx = 120
          self.ny = 60 
      elif (self.resolution == 4): 
          self.nx = 180
          self.ny = 90 
      elif (self.resolution == 5): 
          self.nx = 360
          self.ny = 180 
      elif (self.resolution == 6): 
          self.nx = 720
          self.ny = 360 
      return

   def on_changed2(self, widget):
      self.ntime = widget.get_active()+1
      return

   def on_changed3(self, widget):
      self.ndays = widget.get_active()+1
      return

   def on_changed4(self, widget):
      self.orbit = widget.get_active()+1
      return

   def on_changed5(self, widget):
      self.eccentricity = widget.get_value()
      return

   def on_changed6(self, widget):
      self.obliquity = widget.get_value()
      return

   def on_changed7(self, widget):
      self.precession = widget.get_value()
      return

   def msg(self, widget):

    class PyApp(gtk.Window):

      def __init__(self):
          super(PyApp, self).__init__()

          self.set_title("License")
          self.set_default_size(350,350) 
          self.set_position(gtk.WIN_POS_CENTER)
          self.set_border_width(2)
           
          self.license = gtk.Label("                          DAILY INSOLATION (DINSOL-v1.0) MODEL\
                                   \n  \
                                   \n          Universidade Federal do Vale do Sao Francisco - UNIVASF\
                                   \n                             Laboratorio de Meteorologia - LabMet\
                                   \n  \
                                   \n  Copyright (C) <2022>  <Emerson Damasceno de Oliveira>\
                                   \n  \
                                   \n  This program is free software: you can redistribute it and/or modify\
                                   \n  it under the terms of the GNU General Public License as published by\
                                   \n  the Free Software Foundation, either version 3 of the License, or\
                                   \n  (at your option) any later version.\
                                   \n  \
                                   \n  This program is distributed in the hope that it will be useful,\
                                   \n  but WITHOUT ANY WARRANTY; without even the implied warranty of\
                                   \n  but WITHOUT ANY WARRANTY; without even the implied warranty of\
                                   \n  GNU General Public License for more details.\
                                   \n  \
                                   \n  You should have received a copy of the GNU General Public License\
                                   \n  along with this program.  If not, see <https://www.gnu.org/licenses/>.")

          fixed = gtk.Fixed()
          fixed.put(self.license, 20, 20)
          fontsumm = pango.FontDescription("Carlito 11")
          self.license.modify_font(fontsumm)

          self.add(fixed)

          self.connect("destroy", gtk.main_quit)
          self.show_all()

    PyApp()
    gtk.main()       

   def hello(self,widget):

    with open('namelist', 'w') as f:
      print >> f, ""
      print >> f, "  !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
      print >> f, "  !                                                           !"
      print >> f, "  !            DAILY INSOLATION (DINSOL-v1.0) MODEL           !"
      print >> f, "  !                                                           !"
      print >> f, "  !  Universidade Federal do Vale do Sao Francisco - UNIVASF  !"
      print >> f, "  !            Laboratorio de Meteorologia - LABMET           !"
      print >> f, "  !                                                           !"
      print >> f, "  !                        NAMELIST                           !"
      print >> f, "  !                                                           !"
      print >> f, "  !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
      print >> f, ""
      print >> f, "&inputs"
      print >> f, ""
      print >> f, " ! PRIMARY VARIABLES "
      print >> f, ""
      print >> f, " YEAR       =   ",self.year_input.get_text(),"      ,    ! Year for orbital parameters"
      print >> f, " S0         =   ",self.solar_input.get_text(),"   ,    ! Solar constant [W/m^2]"
      print >> f, " NY         =   ",self.ny,"     ,    ! Latitudinal number points"  
      print >> f, " NX         =   ",self.nx,"     ,    ! Longitudinal number points"  
      print >> f, ""
      print >> f, " NTIME      =   ",self.ntime,"      ,    ! NTIME = 1 -> 6  hours"
      print >> f, "                              ! NTIME = 2 -> 3  hours"
      print >> f, "                              ! NTIME = 3 -> 1  hours"
      print >> f, "                              ! NTIME = 4 -> 30 minutes"
      print >> f, "                              ! NTIME = 5 -> 15 minutes"  
      print >> f, ""  
      print >> f, " CALENDAR   =   ",self.ndays,"      ,    ! CALENDAR = 1 -> 365 days"  
      print >> f, "                              ! CALENDAR = 2 -> 360 days"
      print >> f, "" 
      print >> f, " ! ORBITAL PARAMETERS - PARAMETERIZATIONS"
      print >> f, ""
      print >> f, " ORBITAL    =   ",self.orbit,"      ,    ! ORBITAL = 1 -> Berger (1978)"
      print >> f, "                              ! ORBITAL = 2 -> Berger and Loutre (1991)"
      print >> f, "                              ! ORBITAL = 3 -> Laskar et al (2004; 2011)"
      print >> f, "                              ! ORBITAL = 4 -> User-defined value"
      print >> f, ""
      print >> f, " ! >>> IF ORBITAL = 4 THEN SET ECC, OBLQ AND PRCS <<< "
      print >> f, ""
      print >> f, " ECC        =   ",self.eccentricity," ,    ! Eccentricity"
      print >> f, " OBLQ       =   ",self.obliquity," ,    ! Obliquity [deg]"
      print >> f, " PRCS       =   ",self.precession," ,    ! Precession [deg]"
      print >> f, "/"

    os.system("rm output/gui_plot.png")
    os.system("rm output/summary.txt")
    os.system("rm output/insolation.txt")
    os.system("rm output/solar.radiation.ctl")
    os.system("rm output/solar.radiation")
    os.system("rm output/radiation")
    os.system("rm output/radiation.ctl")	
    os.system("./dinsol.exe")	
    os.system("Rscript output/.0K/gui_plot.R")

    class PyApp(gtk.Window):

      def __init__(self):
          super(PyApp, self).__init__()

          self.set_title("DINSOL-v1.0")
          self.set_default_size(545,420) 
          self.set_position(gtk.WIN_POS_CENTER)
          self.set_border_width(2)

          image3 = gtk.Image()
          image3.set_from_file("output/gui_plot.png")

          mylines = []         
          with open("output/summary.txt","rt") as myfile:
               for myline in myfile: 
                   mylines.append(myline)
           
          self.summ   = gtk.Label("SUMMARY")
          self.para   = gtk.Label("Parameterization")
          self.year   = gtk.Label("Year") 
          self.s0     = gtk.Label("Solar Constant")
          self.ny     = gtk.Label("Latitudinal points")
          self.cldn   = gtk.Label("Calendar")		  
          self.ecc    = gtk.Label("Eccentricity")
          self.oblq   = gtk.Label("Obliquity")
          self.prcs   = gtk.Label("Precession")

          tilt = mylines[9]
	
          if (float(tilt) >= 0): 		  
              self.spring = gtk.Label("Spring") 
              self.summer = gtk.Label("Summer")
              self.autumn = gtk.Label("Autumn")
              self.winter = gtk.Label("Winter") 
          else:
              self.spring = gtk.Label("Autumn") 
              self.summer = gtk.Label("Winter")
              self.autumn = gtk.Label("Spring")
              self.winter = gtk.Label("Summer") 

          self.peri   = gtk.Label("Perihelion")
          self.afel   = gtk.Label("Aphelion") 
          self.insol1 = gtk.Label("Insolation (65N)") 
          self.insol2 = gtk.Label("Insolation (23N)") 

          part = mylines[7]

          if (int(part) == 4): 
              self.year2  = gtk.Label("          ----")
          else:
              self.year2  = gtk.Label(mylines[1])
			  
          self.s02    = gtk.Label(mylines[2])
          self.ny2    = gtk.Label(mylines[4])
          self.cldn2  = gtk.Label(mylines[6])		  

          if (int(part) == 1): 
              self.para2 = gtk.Label("Berger (1978)")
          elif (int(part) == 2): 
              self.para2 = gtk.Label("Berger and Loutre (1991)")
          elif (int(part) == 3): 
              self.para2 = gtk.Label("Laskar et al (2004; 2011)")
          else:    
              self.para2 = gtk.Label("    User-define value")

          self.ecc2         = gtk.Label(mylines[8])
          self.oblq2        = gtk.Label(mylines[9])
          self.prcs2        = gtk.Label(mylines[10])

          self.seasons      = gtk.Label("Northern Hemisphere")

          if (float(tilt) == 0):		  
              self.spring2      = gtk.Label(" 0.00")
              self.spring2month = gtk.Label("/ ---") 
          else:
              self.spring2      = gtk.Label("21.00")
              self.spring2month = gtk.Label("/ MAR")               

          self.summer2      = gtk.Label(mylines[11])
          self.summer2bar   = gtk.Label("/")
          self.summer2month = gtk.Label(mylines[12])
          self.autumn2      = gtk.Label(mylines[13])
          self.autumn2bar   = gtk.Label("/")
          self.autumn2month = gtk.Label(mylines[14])
          self.winter2      = gtk.Label(mylines[15]) 
          self.winter2bar   = gtk.Label("/")
          self.winter2month = gtk.Label(mylines[16]) 
          self.peri2        = gtk.Label(mylines[17])
          self.peri2bar     = gtk.Label("/")
          self.peri2month   = gtk.Label(mylines[18])
          self.afel2        = gtk.Label(mylines[19])
          self.afel2bar     = gtk.Label("/")
          self.afel2month   = gtk.Label(mylines[20])

          self.insol12      = gtk.Label(mylines[21]) 
          self.insol22      = gtk.Label(mylines[22])
          self.degr0        = gtk.Label("[dg]")
          self.degr1        = gtk.Label("[dg]")		  
          self.watts0       = gtk.Label("[W/m^2]")
          self.watts1       = gtk.Label("[W/m^2]")
          self.watts2       = gtk.Label("[W/m^2]")
		  		  
          fixed = gtk.Fixed()
          fixed.put(image3,270,5)
          fixed.put(self.summ, 90, 40)
          fixed.put(self.year, 10, 110)
          fixed.put(self.s0, 10, 130)
          fixed.put(self.ny, 10, 150)
          fixed.put(self.cldn, 10, 170)	  
          fixed.put(self.para, 10, 200)
          fixed.put(self.ecc , 10, 230)
          fixed.put(self.oblq, 10, 250)
          fixed.put(self.prcs, 10, 270)
          fixed.put(self.spring, 10, 340)
          fixed.put(self.summer, 10, 360)
          fixed.put(self.autumn, 10, 380)
          fixed.put(self.winter, 10, 400)
          fixed.put(self.peri, 10, 430)
          fixed.put(self.afel, 10, 450)
          fixed.put(self.insol1, 10, 480)
          fixed.put(self.insol2, 10, 500)

          fixed.put(self.year2, 130, 110)
          fixed.put(self.s02, 135, 130)
          fixed.put(self.ny2, 130, 150)
          fixed.put(self.cldn2, 130, 170)

          if (int(part) == 1):
              fixed.put(self.para2, 150, 200)
          else: 
              fixed.put(self.para2, 125, 200)

          fixed.put(self.ecc2 , 135, 230)
          fixed.put(self.oblq2, 135, 250)
          fixed.put(self.prcs2, 135, 270)
          fixed.put(self.seasons, 50, 310)
          fixed.put(self.spring2, 142, 340)
          fixed.put(self.spring2month, 177, 340)         
          fixed.put(self.summer2, 120, 360)
          fixed.put(self.summer2bar, 177, 360)
          fixed.put(self.summer2month, 183, 360)
          fixed.put(self.autumn2, 120, 380)
          fixed.put(self.autumn2bar, 177, 380)
          fixed.put(self.autumn2month, 183, 380)
          fixed.put(self.winter2, 120, 400)
          fixed.put(self.winter2bar, 177, 400)
          fixed.put(self.winter2month, 183, 400)
          fixed.put(self.peri2, 120, 430)
          fixed.put(self.peri2bar, 177, 430)
          fixed.put(self.peri2month, 185, 430)
          fixed.put(self.afel2, 120, 450)
          fixed.put(self.afel2bar, 177, 450)
          fixed.put(self.afel2month, 185, 450)
          fixed.put(self.insol12, 130, 480)
          fixed.put(self.insol22, 130, 500)
          fixed.put(self.degr0, 240, 250)
          fixed.put(self.degr1, 240, 270)
          fixed.put(self.watts0, 220, 130)
          fixed.put(self.watts1, 220, 480)
          fixed.put(self.watts2, 220, 500)

          fontsumm  = pango.FontDescription("Carlito 12")
          fontdesc  = pango.FontDescription("Carlito 10")
          fontdesc2 = pango.FontDescription("Carlito 8")
          fontdesc3 = pango.FontDescription("Carlito 11")

          self.summ.modify_font(fontsumm)  
          self.s0.modify_font(fontdesc)
          self.ny.modify_font(fontdesc)
          self.cldn.modify_font(fontdesc)
          self.para.modify_font(fontdesc)
          self.year.modify_font(fontdesc)
          self.ecc.modify_font(fontdesc)
          self.oblq.modify_font(fontdesc)
          self.prcs.modify_font(fontdesc)
          self.seasons.modify_font(fontdesc3)
          self.spring.modify_font(fontdesc)
          self.summer.modify_font(fontdesc)
          self.autumn.modify_font(fontdesc)
          self.winter.modify_font(fontdesc)
          self.peri.modify_font(fontdesc)
          self.afel.modify_font(fontdesc)
          self.insol1.modify_font(fontdesc)
          self.insol2.modify_font(fontdesc)
          self.para2.modify_font(fontdesc)
          self.year2.modify_font(fontdesc)
          self.s02.modify_font(fontdesc)
          self.ny2.modify_font(fontdesc)
          self.cldn2.modify_font(fontdesc)
          self.ecc2.modify_font(fontdesc)
          self.oblq2.modify_font(fontdesc)
          self.prcs2.modify_font(fontdesc)
          self.spring2.modify_font(fontdesc)
          self.spring2month.modify_font(fontdesc)
          self.summer2.modify_font(fontdesc)
          self.summer2bar.modify_font(fontdesc)
          self.summer2month.modify_font(fontdesc)
          self.autumn2.modify_font(fontdesc)
          self.autumn2bar.modify_font(fontdesc)
          self.autumn2month.modify_font(fontdesc)
          self.winter2.modify_font(fontdesc)
          self.winter2bar.modify_font(fontdesc)
          self.winter2month.modify_font(fontdesc)
          self.peri2.modify_font(fontdesc)
          self.peri2bar.modify_font(fontdesc)
          self.peri2month.modify_font(fontdesc)
          self.afel2.modify_font(fontdesc)
          self.afel2bar.modify_font(fontdesc)
          self.afel2month.modify_font(fontdesc)
          self.insol12.modify_font(fontdesc)
          self.insol22.modify_font(fontdesc)
          self.degr0.modify_font(fontdesc2)
          self.degr1.modify_font(fontdesc2)
          self.watts0.modify_font(fontdesc2)
          self.watts1.modify_font(fontdesc2)
          self.watts2.modify_font(fontdesc2)

          self.add(fixed)
          self.connect("destroy", gtk.main_quit)
          self.show_all()

    PyApp()
    gtk.main()

PyApp()
gtk.main()
