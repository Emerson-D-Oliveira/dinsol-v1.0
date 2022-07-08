
# +++ This script is just a working model. 
# +++ For some customization, the user should edit it.
# +++
# +++ Author: Emerson Damasceno Oliveira
# +++ Last update: 17 January 2022 

'open radiation.ctl'
'set t 1 last'
'set grads off'
'set grid off'
'set mproj orthogr'
'set lat -90 90'
'set lon -120 60'
*'set gxout shaded'
*'color 0 1300 -div 100 -kind black->blue->skyblue'
'd rad'
*'printim radiation.png x600 y450'
