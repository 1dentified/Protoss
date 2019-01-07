# Observer
![build](observer-build.png)

![build](Observer-Interconnections.png)

## Recommended Hardware Setup
  - Dell PowerEdge R610 (Current model in testing)
  - 96GB RAM 
  - 750 GB HDD Space
    - 2x 75GB
    - 4x 150GB
  - 7 physical NICs (depending on what segregated traffic will be monitored)
    
## Server
  - Raid Setup
    - Volume 1 (system) Create the first volume in a RAID1 configuration using the two 75GB HDDs.
    - Volume 2 (vms) Create the second volume in a RAID5 configuration using the four 150GB HDDs.
  - NOTE: At this point you may need to use a Windows installation disc to reformat Volume 1, since ESXi doesn't support a RAID1 configuration very well.
  - Install ESXi 6.7.u1 onto Volume 1
  

## Network Configuration
For the rest of the instructions we will be using the following placeholders:
   - Management VLAN: 10
   - Server VLAN: 20 **This should be an existing server VLAN within your network
   - Native Trunking VLAN: 999

On the Switch/Router
   - On the Layer 3 Switch or Router create the internal VLAN and VLAN interface for the esxi managment network.
      ```
      RTR(config)#interface Vlan 10 
      RTR(config-if)#description ESXI Management
      RTR(config-if)#ip address x.x.x.x
      ```
      
   - Configure the trunk port using 2 of the available NICs on the ESXi Server
      ```
      RTR(config)#interface [port#/#]
      RTR(config-if)#description Observer
      RTR(config-if)#switchport
      RTR(config-if)#switchport mode trunk
      RTR(config-if)#switchport trunk native vlan 999
      RTR(config-if)#switchport trunk allowed vlan 10
      RTR(config-if)#switchport trunk allowed add vlan 20
      ```
      
   - Configure the spans for each of the necessary VLANs, respectfully Infrastructure, Servers, Clients, Printers/Peripherals, Phones.
      ```
      RTR(config)#monitor session 1 source vlan [VLANs]
      RTR(config)#monitor session 1 destination interface [G#/#]
      
      RTR(config-if)#description Observer Monitor Port
      RTR(config-if)#switchport
      RTR(config-if)#switchport mode dynamic auto
      ```

## VM Configuration
### CENTOS - Packet Capture
