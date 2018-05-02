set val(chan)        Channel/WirelessChannel        ;#channel type
set val(prop)        Propagation/TwoRayGround
set val(netif)        Phy/WirelessPhy            ;#network interface t
set val(mac)        Mac/802_11            ;#MAC type
set val(ifq)        Queue/DropTail/PriQueue        ;#interface queue type
set val(ll)        LL                ;#link layer type
set val(ant)        Antenna/OmniAntenna        ;#antena model
set val(ifqlen)    100                ;#max packet in ifq
set val(mn)        3
set val(rp)     AODV
set val(x)    500
set val(y)    500
set val(stop)    110

set ns [new Simulator]
set nf1 [open simple.tr w]
$ns trace-all $nf1

set topo [new Topography]
$topo load_flatgrid $val(x) $val(y)
create-god $val(mn)

set nf [open adhoc.nam w]
$ns namtrace-all $nf
$ns namtrace-all-wireless $nf $val(x) $val(y)


set chan [new $val(chan)]
$ns node-config -adhocRouting $val(rp)\
-llType $val(ll)\
-macType $val(mac)\
-propType $val(prop)\
-ifqType $val(ifq)\
-ifqLen $val(ifqlen)\
-antType $val(ant)\
-phyType $val(netif)\
-channel $chan\
-topoInstance $topo\
-agentTrace ON\
-routerTrace OFF\
-macTrace ON\
-movementTrace ON\

for {set i 0} {$i < $val(mn)} {incr i} {
    set n_($i) [$ns node]
}

$n_(0) set X_ 5.0
$n_(0) set Y_ 5.0
$n_(0) set Z_ 0.0


$n_(1) set X_ 390.0
$n_(1) set Y_ 180.0
$n_(1) set Z_ 0.0

$n_(2) set X_ 250.0
$n_(2) set Y_ 120.0
$n_(2) set Z_ 0.0

$ns at 7.0 "$n_(0) setdest 35.0 45.0 3.0"
$ns at 5.0 "$n_(2) setdest 45.0 35.0 3.0"
$ns at 10.0 "$n_(1) setdest 105.0 50.0 3.0"

set udp0 [new Agent/UDP]
set null0 [new Agent/Null]

$ns attach-agent $n_(0) $udp0
$ns attach-agent $n_(1) $null0

$ns connect $udp0 $null0

set cbr0 [new Application/Traffic/CBR]
$cbr0 set packetSize_ 512
$cbr0 set rate_ 600kb
$cbr0 set interval_ 0.05
$cbr0 set random_ 1
$cbr0 set maxpkts_ 10000
$cbr0 attach-agent $udp0

$ns at 2.0 "$cbr0 start"

for {set i 0} {$i < $val(mn)} {incr i} {
    $ns initial_node_pos $n_($i) 30
}

for {set i 0} {$i<$val(mn)} {incr i} {
    $ns at $val(stop) "$n_($i) reset"
}

$ns at $val(stop) "stop"
$ns at 110.00 "puts \" end simulation...\";$ns halt"

proc stop {} {
global ns nf nf1
$ns flush-trace
close $nf
close $nf1
 exec nam out.nam &
  exit 0
}
puts "Starting Simulation..."
$ns run
