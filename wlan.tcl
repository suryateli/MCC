# ======================================================================
# Define options
# ======================================================================

set opt(chan)       Channel/WirelessChannel         ;# channel type
set opt(prop)       Propagation/TwoRayGround       ;# radio-propagation model
set opt(netif)      Phy/WirelessPhy                 ;# network interface type
set opt(mac)        Mac/802_11                      ;# MAC type
set opt(ifq)        Queue/DropTail/PriQueue         ;# interface queue type
set opt(ll)         LL                              ;# link layer type
set opt(ant)        Antenna/OmniAntenna             ;# antenna model
set opt(ifqlen)         1000                          ;# max packet in ifq
set opt(nn)             4                              ;# number of mobilenodes
set opt(adhocRouting)   DSDV                           ;# routing protocol

set opt(x)          100                              ;# x coordinate of topology
set opt(y)          100                              ;# y coordinate of topology
set opt(stop)       10                                ;# time to stop simulation
set num_wired_nodes     7
set num_bs_nodes        2                  
set size        500
# ======================================================================



# create simulator instance

set ns_   [new Simulator]

# set up for hierarchical routing
$ns_ node-config -addressType hierarchical

AddrParams set domain_num_ 3           ;# number of domains
lappend cluster_num 1 1 1             ;# number of clusters in each domain
AddrParams set cluster_num_ $cluster_num
lappend eilastlevel 7 3 3        ;# number of nodes in each cluster
AddrParams set nodes_num_ $eilastlevel ;# of each domain

set tracefd  [open out.tr w]
set namtrace [open out.nam w]
$ns_ trace-all $tracefd
$ns_ namtrace-all $namtrace
$ns_ namtrace-all-wireless $namtrace $opt(x) $opt(y)




# Create topography object
set topo   [new Topography]

# define topology
$topo load_flatgrid $opt(x) $opt(y)

# create God
create-god $opt(nn)

#-=-=-=-NAM=-=-=-=--=-=-=-=-=-=-=-=-=---=-=---=-=-=-=-=
#set ns_ [new Simulator]
set f0 [open wir7.tr w]
$ns_ trace-all $f0

set namtrace [open out.nam w]
$ns_ namtrace-all-wireless $namtrace $opt(x) $opt(y)
#=-=--=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
#create wired nodes

set W1 [$ns_ node 0.0.0]
set W2 [$ns_ node 0.0.1]
set W3 [$ns_ node 0.0.2]
set W4 [$ns_ node 0.0.3]
set W5 [$ns_ node 0.0.4]

set W8 [$ns_ node 0.0.5]
set W9 [$ns_ node 0.0.6]

# Configure for Basestation Node
$ns_ node-config -adhocRouting $opt(adhocRouting) \
                 -llType $opt(ll) \
                 -macType $opt(mac) \
                 -ifqType $opt(ifq) \
                 -ifqLen $opt(ifqlen) \
                 -antType $opt(ant) \
                 -propType $opt(prop) \
                 -phyType $opt(netif) \
                 -channelType $opt(chan) \
         -topoInstance $topo \
                 -wiredRouting ON \
         -agentTrace ON \
                 -routerTrace ON \
                 -macTrace OFF



# Position (fixed) for base-station nodes (HA & FA).

set BS1 [$ns_ node 1.0.0]
set BS2 [$ns_ node 2.0.0]



# create a mobilenode that would be moving between HA and FA.
# note address of MH indicates its in the same domain as HA.
$ns_ node-config -wiredRouting OFF

set R1 [$ns_ node 1.0.2]
set R2 [$ns_ node 1.0.3]
set R3 [$ns_ node 2.0.2]
set R4 [$ns_ node 2.0.3]


$R1 base-station [AddrParams addr2id [$BS1 node-addr]]
$R2 base-station [AddrParams addr2id [$BS1 node-addr]]
$R3 base-station [AddrParams addr2id [$BS2 node-addr]]
$R4 base-station [AddrParams addr2id [$BS2 node-addr]]

# position of the nodes
$R1 set X_ 120.000000000000
$R1 set Y_ 80.000000000000
$R1 set Z_ 0.000000000000

$R2 set X_ 160.000000000000
$R2 set Y_ 40.000000000000
$R2 set Z_ 0.000000000000

$R3 set X_ 160.000000000000
$R3 set Y_ 0.000000000000
$R3 set Z_ 0.000000000000

$R4 set X_ 160.000000000000
$R4 set Y_ -40.000000000000
$R4 set Z_ 0.000000000000



# create links between wired and BaseStation nodes
$ns_ duplex-link $W1 $W3 2Mb 20ms DropTail
$ns_ duplex-link $W2 $W4 2Mb 20ms DropTail
$ns_ duplex-link $W8 $W3 2Mb 20ms DropTail
$ns_ duplex-link $W9 $W4 2Mb 20ms DropTail

$ns_ duplex-link $W3 $W5 5Mb 20ms DropTail
$ns_ duplex-link $W4 $W5 5Mb 20ms DropTail


$ns_ duplex-link $W5 $BS1 5Mb 20ms DropTail
$ns_ duplex-link $W5 $BS2 5Mb 20ms DropTail

# set the layout of links in NAM
$ns_ duplex-link-op $W1 $W3 orient right
$ns_ duplex-link-op $W8 $W3 orient right-down

$ns_ duplex-link-op $W2 $W4 orient right-up
$ns_ duplex-link-op $W9 $W4 orient right

$ns_ duplex-link-op $W3 $W5 orient right-down
$ns_ duplex-link-op $W4 $W5 orient right-up



$ns_ duplex-link-op $W5 $BS1 orient right-up
$ns_ duplex-link-op $W5 $BS2 orient right-down



$ns_ at 0.0 "$W1 label W1"
$ns_ at 0.0 "$W2 label W2"
$ns_ at 0.0 "$W8 label W3"
$ns_ at 0.0 "$W9 label W4"
$ns_ at 0.0 "$W3 label R1"
$ns_ at 0.0 "$W4 label R2"
$ns_ at 0.0 "$W5 label R3"

$ns_ at 0.0 "$BS1 label BS1"
$ns_ at 0.0 "$BS2 label BS2"
$ns_ at 0.0 "$R1 label R1"
$ns_ at 0.0 "$R2 label R2"
$ns_ at 0.0 "$R3 label R3"
$ns_ at 0.0 "$R4 label R4"
$ns_ at 0.0 "$R1 add-mark m1 green circle"
$ns_ at 0.0 "$R2 add-mark m1 red circle"
$ns_ at 0.0 "$R3 add-mark m1 blue circle"
$ns_ at 0.0 "$R4 add-mark m1 purple circle"
# setup TCP connections

  set tcp1 [new Agent/TCP/Newreno]
  $tcp1 set packetSize_  $size
  $ns_ attach-agent $W1  $tcp1
  set sink1 [new Agent/TCPSink]
  $ns_ attach-agent $R1  $sink1
  $ns_ connect $tcp1 $sink1
  set ftp1 [new Application/FTP]
  $ftp1 attach-agent $tcp1
  $ns_ at 1.0 "$ftp1 start"
  $ns_ at 1.0 "$ns_ trace-annotate \"W1 Sends packets to R1 via Home
Agent(BS1). \""

  set tcp2 [new Agent/TCP/Newreno]
  $tcp2 set packetSize_  $size
  $ns_ attach-agent $W8  $tcp2
  set sink2 [new Agent/TCPSink]
  $ns_ attach-agent $R2  $sink2
  $ns_ connect $tcp2 $sink2
  set ftp2 [new Application/FTP]
  $ftp2 attach-agent $tcp2
  $ns_ at 2.0 "$ftp2 start"
  $ns_ at 2.0 "$ns_ trace-annotate \"W3 Sends packets to R2 via Home
Agent(BS1). \""

  set tcp3 [new Agent/TCP/Newreno]
  $tcp3 set packetSize_  $size
  $ns_ attach-agent $W2  $tcp3
  set sink3 [new Agent/TCPSink]
  $ns_ attach-agent $R3  $sink3
  $ns_ connect $tcp3 $sink3
  set ftp3 [new Application/FTP]
  $ftp3 attach-agent $tcp3
  $ns_ at 3.0 "$ftp3 start"
  $ns_ at 3.0 "$ns_ trace-annotate \"W2 Sends packets to R3 via Home
Agent(BS2). \""

  set tcp4 [new Agent/TCP/Newreno]
  $tcp4 set packetSize_  $size
  $ns_ attach-agent $W9  $tcp4
  set sink4 [new Agent/TCPSink]
  $ns_ attach-agent $R4  $sink4
  $ns_ connect $tcp4 $sink4
  set ftp4 [new Application/FTP]
  $ftp4 attach-agent $tcp4
  $ns_ at 4.0 "$ftp4 start"
  $ns_ at 4.0 "$ns_ trace-annotate \"W4 Sends packets to R4 via Home
Agent(BS2). \""


# Define initial node position in nam

$ns_ initial_node_pos $R1 10
$ns_ initial_node_pos $R2 10
$ns_ initial_node_pos $R3 10
$ns_ initial_node_pos $R4 10


# Tell all nodes when the siulation ends
$ns_ at $opt(stop).0 "$R1 reset";
$ns_ at $opt(stop).0 "$R2 reset";
$ns_ at $opt(stop).0 "$R3 reset";
$ns_ at $opt(stop).0 "$R4 reset";

$ns_ at $opt(stop).0002 "puts \"NS EXITING...\" ; $ns_ halt"
$ns_ at $opt(stop).0001 "stop"

proc stop {} {
    global ns_ tracefd namtrace opt f0

global ns_  tcp1 tcp2 tcp3 tcp4 
global sink
    $ns_ flush-trace
    close $tracefd
    close $f0
    close $namtrace
   
#    close $tracefd
#    close $namtrace
    exec  nam out.nam &
    exit 0
}

puts "Starting Simulation..."
$ns_ run
# ======================================================================
