#!/usr/bin/perl

use strict;
use warnings;
use lib "/home/pi/perl5/lib/perl5";
use RRD::Simple;

#load up the device ID file.
get_device_IDs();

use vars qw(%deviceIDs %deviceCal $path);

my $path = "/home/pi/rPI-multiDS18x20/";
my $rrd = RRD::Simple->new( file => $path . "multirPItemp.rrd");

while (1) {
	for my $key ( keys %deviceIDs ) {
		my $reading = read_device($deviceIDs{$key});
		$rrd->update($key => $reading != 9999 ? $reading + $deviceCal{$key} : 'U');
		sleep(1);
	}
}

sub get_device_IDs {
	# If you've run detect.pl before, sensors.conf should be a CSV file containing a list of indicies and deviceIDs
	# Pull them into a hash here for processing later

	# open file
	open(INFILE, "sensors.conf") or die("Unable to open file");

	while(<INFILE>) {
		chomp;
		(my $index, my $cal, my $ID) = split(/,/);
		$index =~ s/\s*$//g;
		$deviceIDs{$index} = $ID;
		$deviceCal{$index} = $cal;
	}
	close(INFILE);
}

sub read_device {
	#takes one parameter - a device ID
	#returns the temperature if we have something like valid conditions
	#else we return "9999" for undefined

	my $deviceID = $_[0];
	$deviceID =~ s/\R//g;
 
	my $ret = 9999; # default to return 9999 (fail)
   
	my $sensordata = `cat /sys/bus/w1/devices/${deviceID}/w1_slave 2>&1`;
	#print "Read: $sensordata";

	if(index($sensordata, 'YES') != -1) {
		#fix for negative temps from http://habrahabr.ru/post/163575/
		$sensordata =~ /t=(\D*\d+)/i;
		$sensordata = (($1/1000));
		$ret = $sensordata;
	} else {
		print ("CRC Invalid for device $deviceID.\n");
	}
	return ($ret);
}
