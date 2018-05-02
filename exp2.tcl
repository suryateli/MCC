set ns [new Simulator]

$ns color 1 Red

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

set n0 [$ns node]
set n1 [$ns node]
set n2 [$ns node]
set n3 [$ns node]
set n4 [$ns node]
set n5 [$ns node]
set n6 [$ns node]

$ns duplex-link $n0 $n1 50Mb 25ms DropTail
$ns duplex-link $n1 $n5 50Mb 25ms DropTail
$ns duplex-link $n5 $n4 50Mb 25ms DropTail
$ns duplex-link $n4 $n6 50Mb 25ms DropTail
$ns duplex-link $n0 $n2 100Mb 25ms DropTail
$ns duplex-link $n2 $n3 100Mb 25ms DropTail
$ns duplex-link $n3 $n4 100Mb 25ms DropTail
$ns duplex-link $n1 $n3 50Mb 25ms DropTail

$ns duplex-link-op $n0 $n1 orient right-up
$ns duplex-link-op $n1 $n5 orient right
$ns duplex-link-op $n5 $n4 orient right-down
$ns duplex-link-op $n4 $n6 orient right
$ns duplex-link-op $n0 $n2 orient right-down
$ns duplex-link-op $n2 $n3 orient right
$ns duplex-link-op $n3 $n4 orient right-up
$ns duplex-link-op $n1 $n3 orient right-down

$ns queue-limit $n1 $n3 500

set udp [new Agent/UDP]
$ns attach-agent $n1 $udp
set null [new Agent/Null]
$ns attach-agent $n6 $null
$ns connect $udp $null
$udp set fid_ 1

set cbr [new Application/Traffic/CBR]
$cbr attach-agent $udp
$cbr set packetsize_ 552
$cbr set rate_ 1Mb

$ns at 1.0 "$cbr start"
$ns at 50.0 "$cbr stop"

$ns at 60 "finish"
$ns run