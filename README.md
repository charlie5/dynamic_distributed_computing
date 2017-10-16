# Dynamic Distributed Computing
Provides a simple demonstration of 'Direct Distributed Computing' (DDC) in Ada 
using the 'Distributed Systems Annex' (DSA). 



### Requirements

- Provide an application which performs a complex calculation.
- The calculation should be split into multiple jobs.
- Jobs should be distributed to worker partitions running on separate network nodes.
- Workers may join/leave the worker pool at any time during the calculation.



### Versions

- Development (fused) ~ Builds a single executable which may be developed/debugged/tested as with any normal Ada program.

- Release      (dsa)  ~ Builds a distributed system providing a Boss partition and a Worker partition.




### Folder Layout

- ./applet:  Contains a folder each for the 'fused' (development) and 'dsa' (release) versions.

- ./library: Contains gnat project files for the common code in the 'source' folder.

- ./source:  Contains source files common to both the fused and dsa versions.




### Build

Polyorb is required.



##### Fused:

- $ cd ./applet/fused
- $ gnatmake -P ddc_fused


##### DSA:

- $ cd ./applet/dsa
- $ ./builder



### Test

##### LAN

Open a new terminal

- $ cd ./applet/dsa/test/po_cos_naming
- $ po_cos_naming


Open a new terminal

- $ cd ./applet/dsa/test/boss
- $ ../../bin/boss_partition


Open a new terminal

- $ cd ./applet/dsa/test/worker1
- $ ../../bin/worker_partition


Open a new terminal

- $ cd ./applet/dsa/test/worker2
- $ ../../bin/worker_partition



##### WAN:

###### General:

Open /etc/hosts and ensure it contains a line with your WAN (WWW) net address, matched with your hostname (as defined in /etc/hostname).

<your ip address>    <your hostname>


###### Running a Boss:


Open a new terminal:

- $ cd ./applet/dsa/test/po_cos_naming

- Make sure that the 'polyorb.protocols.iiop.default_port' value is open in any firewall and forwarded to the box running the po_cos_naming server.

- $ po_cos_naming


Open a new terminal:

- $ cd ./applet/dsa/test/boss

- Edit polyorb.conf and set the name service to the value given by 'po_cos_naming' server output, similar to the following:

- name_service=corbaloc:iiop:1.2@192.168.1.4:5001/NameService/000000024fF0000000080000000


- Make sure that the 'polyorb.protocols.iiop.default_port' value is open in any firewall and forwarded to the box running the server.


- Finally, launch the boss ...

- $ ../../bin/boss_partition


###### Running a Worker:


Open a new terminal:

- $ cd ./applet/dsa/test/worker3

- Edit 'polyorb.conf' and set the name service to the value given by 'po_cos_naming' server output, similar to te following:

- name_service=corbaloc:iiop:1.2@192.168.1.4:5001/NameService/000000024fF0000000080000000

- Make sure that the 'polyorb.protocols.iiop.default_port' value is open in any firewall and forwarded to the box running the worker.

- Finally, launch the worker ...

- $ ../../bin/worker_partition

