#!/usr/bin/perl
#+-------------------------------------------------------------------------------+
#DESCRIPTION: checks Microfocus OMi ports
#USE:perl <FILENNAME>
#EXAMPLE: perl dc_omi_portcan.pl
#DATE:18/11/2016
#AUTHOR:Deepak Chohan
#VERSION:
#+-------------------------------------------------------------------------------+
#
#
#
use strict;
use warnings;
use Net::Ping;
use IO::Socket;
use Term::ANSIColor;

#Write the server name into the text file

open (MYHOSTSFILE, "<",./myhosts.txt") or die $!;


#Create a file to report on what servers are alive

open (SRV_RPT, ">",./server_report.txt") or die $!;
open (SRV_ALIVE, ">",./server_alive.txt") or die $!;

#Start of Variables
#
#
my $output = '';
my $host;
my $timeout = 10;


#These are OMI ports 
my @well_known_ports = qw( 383 443 8443 1098 1099 5445 8009 8080  29000 );

# End of my variables
#
#Code Start
#ping servers belonging to the opsa_server array group
sub ping_hosts 
  {
   while (my @lines = <MYHOSTSFILE>)
{
   foreach $host (@lines)
{
   print "Pinging $host\n";
   my $p = Net::Ping ->new("icmp"); #create ping object
   chomp $host;
   if ( $p-> ping ($host, $timeout) )
{
   print color ('bold green');
   print "+------------------------------------------+\n";
   print "Host ".$host."  is alive\n";
   my $aliveoutput = "Host ".$host." is alive\n";
   print SRV_ALIVE "";
   print SRV_ALIVE "+------------------------------------------+\n";
   print SRV_ALIVE $aliveoutput;
   print SRV_ALIVE "";
   print "\n";
   print color ('reset');
   foreach my $port (@well_known_ports)
{
   my  $socket = IO::Socket::INET->new(PeerAddr => $host , PeerPort => $port , Proto => 'tcp' , Timeout => 5);
   if($socket )
{
   print color ('bold green');
   print "Port: $port on $host is open.\n";
   my $openport = "Port: $port on $host is open.\n";
   my $portrpt = "$port $host\n";
   print SRV_ALIVE "";
   print SRV_ALIVE $openport;
   print SRV_RPT $portrpt;
   print color ('reset');
}
   else
{
   print  "Port: $port on $host is closed.\n";
  }
 }
}
   else
{
   print color ('bold red');
   print "+------------------------------------------+\n";
   print "Warning: ".$host." is offline\n";
   print "\n";
   print color ('reset');
   }
  }
 }
}


#Run the functions
ping_hosts;
print $output;
close MYHOSTSFILE;
close SRV_ALIVE;
close SRV_RPT;
exit (0);
#End of Code

=======================================================================