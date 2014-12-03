#!/usr/bin/perl

use strict;
use warnings;
use lib "/home/pi/perl5/lib/perl5";
use RRD::Simple;

#load up the device ID file.
get_device_IDs();
open_devices();

use vars qw(%deviceIDs %deviceCal $path %fhandle);

my $path = "/home/pi/rPI-multiDS18x20/";
my $rrd = RRD::Simple->new( file => $path . "multirPItemp.rrd");

# Loop forever, sleeping at least 1s per loop
while (1) {
	for my $key ( keys %deviceIDs ) {
		my $reading = read_device($key);
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

sub open_devices {
	for my $key ( keys %deviceIDs ) {
		open (my $fh, "<", "/sys/bus/w1/devices/" . $deviceIDs{$key} . "/w1_slave") 
			or die "cannot open < $deviceIDs{$key}: $!";
		$fhandle{$key} = $fh;
	}
}

sub read_device {
	#returns the temperature if we have something like valid conditions
	#else we return "9999" for undefined

	my $key = $_[0];
	my $ret = 9999; # default to return 9999 (fail)
  	my $fh = $fhandle{$key};
	# reset the w1 sys file for reading
	seek($fh, 0, 0);
	local $/;
	my $sensordata = <$fh>;

	if(index($sensordata, 'YES') != -1) {
		#fix for negative temps from http://habrahabr.ru/post/163575/
		$sensordata =~ /t=(\D*\d+)/i;
		$sensordata = (($1/1000));
		$ret = $sensordata;
	} else {
		print ("CRC Invalid for device $key.\n");
	}
	return ($ret);
}
