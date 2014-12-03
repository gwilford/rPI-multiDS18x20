#!/bin/bash
rrdtool create hwtemps.rrd --step 60 \
DS:boiler_flow:GAUGE:600:0:100 \
DS:coil:GAUGE:600:0:100 \
DS:high-level:GAUGE:600:0:100 \
DS:mid-level:GAUGE:600:0:100 \
DS:ambient:GAUGE:600:0:100 \
RRA:AVERAGE:0.5:1:1576800 \
RRA:MAX:0.5:10:12096 \
RRA:MAX:0.5:30:17520
