#!/bin/bash
rrdtool create multirPItemp.rrd  --step 60 \
DS:ambient:GAUGE:600:0:100 \
DS:mid-level:GAUGE:600:0:100 \
DS:high-level:GAUGE:600:0:100 \
DS:boiler_flow:GAUGE:600:0:100 \
DS:coil:GAUGE:600:0:100 \
RRA:AVERAGE:0.5:1:60 \
RRA:AVERAGE:0.5:1:1440 \
RRA:AVERAGE:0.5:60:840 \
RRA:AVERAGE:0.5:60:3600 \
RRA:AVERAGE:0.5:1440:1825
