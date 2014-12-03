#!/bin/bash

FLAGS="-A -Y -E --right-axis 1:0 -w 1200 -h 600 --start -12h"
#FLAGS="-A -Y -w 1200 -h 600 --start -1h"
OUTDIR=/var/www/img

INCOLOUR="#FF0000"
OUTCOLOUR="#0000FF"
TRENDCOLOUR="#000000"

CRIMSON="#B0171F"
PINK="#FFC0CB"
PURPLE="#9B30FF"
BLUE="#0000FF"
CYAN="#00EEEE"
GREEN="#00C957"
LIME="#00FF00"
YELLOW="#FFFF00"
ORANGE="#FFA500"
RED="#FF0000"
BLACK="#000000"

#hour
rrdtool graph $OUTDIR/mhour.png $FLAGS \
DEF:boiler_flowtemp=multirPItemp.rrd:boiler_flow:AVERAGE \
DEF:coiltemp=multirPItemp.rrd:coil:AVERAGE \
DEF:high-leveltemp=multirPItemp.rrd:high-level:AVERAGE \
DEF:mid-leveltemp=multirPItemp.rrd:mid-level:AVERAGE \
DEF:ambienttemp=multirPItemp.rrd:ambient:AVERAGE \
CDEF:boiler_flowtrend=boiler_flowtemp,300,TREND \
CDEF:coiltrend=coiltemp,300,TREND \
CDEF:high-leveltrend=high-leveltemp,300,TREND \
CDEF:mid-leveltrend=mid-leveltemp,300,TREND \
CDEF:ambienttrend=ambienttemp,300,TREND \
LINE2:boiler_flowtemp$GREEN:"boiler_flow temperature" \
LINE2:coiltemp$CYAN:"coil temperature" \
LINE2:high-leveltemp$BLUE:"high-level temperature" \
LINE2:mid-leveltemp$RED:"mid-level temperature" \
LINE2:ambienttemp$ORANGE:"ambient temperature"


rrdtool graph $OUTDIR/boiler_flow.png $FLAGS \
DEF:boiler_flowtemp=multirPItemp.rrd:boiler_flow:AVERAGE \
CDEF:boiler_flowtrend=boiler_flowtemp,300,TREND \
LINE2:boiler_flowtemp$GREEN:"boiler_flow temperature" \
LINE1:boiler_flowtrend$BLACK:"5 min average" 

rrdtool graph $OUTDIR/coil.png $FLAGS \
DEF:coiltemp=multirPItemp.rrd:coil:AVERAGE \
CDEF:coiltrend=coiltemp,300,TREND \
LINE2:coiltemp$CYAN:"coil temperature" \
LINE1:coiltrend$BLACK:"5 min average" 

rrdtool graph $OUTDIR/high-level.png $FLAGS \
DEF:high-leveltemp=multirPItemp.rrd:high-level:AVERAGE \
CDEF:high-leveltrend=high-leveltemp,300,TREND \
LINE2:high-leveltemp$BLUE:"high-level temperature" \
LINE1:high-leveltrend$BLACK:"5 min average" 

rrdtool graph $OUTDIR/mid-level.png $FLAGS \
DEF:mid-leveltemp=multirPItemp.rrd:mid-level:AVERAGE \
CDEF:mid-leveltrend=mid-leveltemp,300,TREND \
LINE2:mid-leveltemp$RED:"mid-level temperature" \
LINE1:mid-leveltrend$BLACK:"5 min average" 

rrdtool graph $OUTDIR/ambient.png $FLAGS \
DEF:ambienttemp=multirPItemp.rrd:ambient:AVERAGE \
CDEF:ambienttrend=ambienttemp,300,TREND \
LINE2:ambienttemp$ORANGE:"ambient temperature" \
LINE1:ambienttrend$BLACK:"5 min average" 
