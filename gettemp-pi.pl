#!/usr/bin/perl

use strict;
use warnings;
use lib "/home/pi/perl5/lib/perl5";
use RRD::Simple;

my $tempdev = "/sys/class/thermal/thermal_zone0/temp";
my $rrdfile = "/home/pi/rPI-multiDS18x20/bcmtemp.rrd";
my $rrd = RRD::Simple->new(file => $rrdfile);

open (my $fh, "<", $tempdev) or die "cannot open < $tempdev: $!";

# Loop forever, sleeping at least 1s per loop
while (1) {
	seek($fh, 0, 0);
	my $temp = <$fh>;
	$rrd->update('thermal0' => $temp/1000);
	sleep(5);
}
