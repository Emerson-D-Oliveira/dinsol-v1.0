
* +++ This script is just a working model. 
* +++ For some customization, the user should edit it.
* +++
* +++ Author: Emerson Damasceno Oliveira
* +++ Last update: 17 January 2022 

'reinit'
'open solar.radiation.ctl'
'set display color white'
'c'
'set grads off'
'set grid off'
'set map 80 1 7'
'set mpt 1 off'
'set t 1 last'
'set xlopts 1 1 0.12'
'set ylopts 1 3 0.13'
'set tlsupp year'
'set annot 1 5'
'set gxout shaded'
'set xyrev on'
'd rad'
'set gxout contour'
'set clopts -1 -1 0.13'
'set cint 50'
'd rad'
'draw title Daily Insolation W/m^2'
'draw xlab Days'
'draw ylab Latitude' 
'printim insol_GrADS.png x500 y550'
'quit'
