set ns [new Simulator]

$ns color 1 Blue
$ns color 2 Red

set file1 [open out.tr w]
$ns trace-all $file1

set file2 [open out.nam w]
$ns namtrace-all $file2

proc finish {} {
    global ns file1 file2
    $ns flush-trace
    close $file1
    close $file2
    exec nam out.nam &
    exit 0
}

set ns0 [$ns node]
set ns1 [$ns node]
set ns2 [$ns node]
set ns3 [$ns node]
set ns4 [$ns node]
set ns5 [$ns node]

$ns duplex-link $ns0 $ns1 50Mb 10ms DropTail
$ns duplex-link $ns1 $ns5 50Mb 10ms DropTail
$ns duplex-link $ns5 $ns4 50Mb 10ms DropTail
$ns duplex-link $ns0 $ns2 100Mb 10ms DropTail
$ns duplex-link $ns2 $ns3 100Mb 10ms DropTail
$ns duplex-link $ns3 $ns4 100Mb 10ms DropTail
$ns duplex-link $ns1 $ns3 50Mb 10ms DropTail

$ns duplex-link-op $ns0 $ns1 orient right-up
$ns duplex-link-op $ns1 $ns5 orient right
$ns duplex-link-op $ns5 $ns4 orient right-down
$ns duplex-link-op $ns0 $ns2 orient right-down
$ns duplex-link-op $ns2 $ns3 orient right
$ns duplex-link-op $ns3 $ns4 orient right-up
$ns duplex-link-op $ns1 $ns3 orient right-up

set tcp [new Agent/TCP]
$ns attach-agent $ns0 $tcp
set sink [new Agent/TCPSink]
$ns attach-agent $ns3 $sink
$ns connect $tcp $sink
$tcp set fid_ 1

set udp [new Agent/UDP]
$ns attach-agent $ns1 $udp
set null [new Agent/Null]
$ns attach-agent $ns3 $null
$ns connect $udp $null
$udp set fid_ 2

set ftp [new Application/FTP]
$ftp attach-agent $tcp
$ftp set class_ 2

set cbr [new Application/Traffic/CBR]
$cbr attach-agent $udp
$cbr set class_ 2
$cbr set rate_ 1Mbps
$cbr set packetSize_ 100

$ns at 0.5 "$ftp start"
$ns at 1 "$cbr start"
$ns at 50 "$ftp stop"
$ns at 50 "$cbr stop"

$ns at 50.5 "finish"

$ns run
