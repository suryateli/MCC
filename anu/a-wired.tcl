#create simulator object
set ns [new Simulator]

#define different colors for data flow
$ns color 1 blue
$ns color 2 red

#open event trace file
set file1 [open out.tr w]
$ns trace-all $file1

#open nam trace file
set file2 [open out.nam w]
$ns namtrace-all $file2

#define finish procedure
proc finish {} {
  global ns file1 file2
  $ns flush-trace
  close $file1
  close $file2
  exec nam out.nam &
  exit 0}

#create nodes
set n0 [$ns node]
set n1 [$ns node]
set n2 [$ns node]
set n3 [$ns node]
set n4 [$ns node]
set n5 [$ns node]
set n6 [$ns node]
set n7 [$ns node]
set n8 [$ns node]


#lable the nodes 0 and 1
#$ns at 0.1"$n1 lable\"CBR\""
#$ns at 1.0"$n0 lable\"FTP\""

#create links between nodes
$ns duplex-link $n0 $n2 2Mb 10ms DropTail
$ns duplex-link $n1 $n2 2Mb 10ms DropTail
$ns duplex-link $n2 $n6 0.3Mb 100ms DropTail
$ns duplex-link $n6 $n7 0.3Mb 100ms DropTail
$ns duplex-link $n7 $n3 0.3Mb 100ms DropTail
$ns duplex-link $n2 $n8 0.3Mb 100ms DropTail
$ns duplex-link $n3 $n8 0.3Mb 100ms DropTail
$ns duplex-link $n3 $n4 0.5Mb 30ms DropTail
$ns duplex-link $n3 $n5 0.5Mb 30ms DropTail

#give node position
$ns duplex-link-op $n1 $n2 orient right-down
$ns duplex-link-op $n0 $n2 orient right-up
$ns duplex-link-op $n2 $n6 orient right
$ns duplex-link-op $n2 $n8 orient right-up
$ns duplex-link-op $n8 $n3 orient right-up
$ns duplex-link-op $n6 $n7 orient right
$ns duplex-link-op $n7 $n3 orient right
$ns duplex-link-op $n3 $n4 orient right-up
$ns duplex-link-op $n3 $n5 orient right-down

#set Queue size of link (n2-n3)
#$ns queue-limit $n2 $n3 40

#setup tcp connection
set tcp [new Agent/TCP]
$ns attach-agent $n0 $tcp
set sink [new Agent/TCPSink]
$ns attach-agent $n4 $sink
$ns connect $tcp $sink
$tcp set fid_ 1
$tcp set window_ 8000
$tcp set packetSize_ 552

#setup a FTP over TCP connection
set ftp [new Application/FTP]
$ftp attach-agent $tcp
#$ftpsettype_FTP

#setup UDP connection
set udp [new Agent/UDP]
$ns attach-agent $n1 $udp
set null [new Agent/Null]
$ns attach-agent $n5 $null
$ns connect $udp $null
$udp set fid_ 2

#setup a CBR over UDP connection
set cbr [new Application/Traffic/CBR]
$cbr attach-agent $udp
#$cbrsettype_CBR
$cbr set packetSize_ 1000
$cbr set rate_ 0.01Mb

#scheduling the events
$ns at 0.1 "$cbr start"
$ns at 1.0 "$ftp start"
$ns at 624.0 "$ftp stop "
$ns at 624.5 "$cbr stop"

#call finish procedure
$ns at 625.0 "finish"

#run simulation
$ns run
