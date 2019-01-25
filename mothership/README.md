# Mothership

## Recommended Hardware Setup
  - Dell PowerEdge R820 (Current model in testing)
    - 96GB RAM 
    - 2x 128GB HDDs
    - 3 physical NICs 
  - Dell EqualLogic
    - 24x 128GB HDDs
    - 4 physical NICs (2 for redundancy)
    
## Network Configuration
For the network configuration, we are using a Cisco NEXUS 5000 to support 1/10GB connections, and a Cisco 2750 to support the 100MB connections. The following examples will be reflected using those configurations, and all VLAN numbers are nominal placeholders.

  - On the NEXUS 5000, enable the interface vlan feature and create 4 separate VLANs (segregated from your public network's VLAN pool) using local IPs.
      ```
      SW(config)#feature interface-vlan
      
      SW(config)#interface vlan 10
      SW(config-if)#description Management
      SW(config-if)#ip address 10.10.10.1/24
      
      SW(config)#interface vlan 11
      SW(config-if)#description Internal Servers
      SW(config-if)#ip address 10.10.11.1/24
      
      SW(config)#interface vlan 12
      SW(config-if)#description iSCSI
      SW(config-if)#ip address 10.10.12.1/24
      
      SW(config)#interface vlan 13
      SW(config-if)#description vMotion
      SW(config-if)#ip address 10.10.13.1/24
      ```

  - Connect the two servers as seen in the following network connection diagram:
  
  - Configure the necessary ports.
    - Mothership ESXi Management
      ```
      SW(config)#interface E#/#
      SW(config-if)#description Mothership ESXi Management
      SW(config-if)#switchport mode trunk
      SW(config-if)#switchport trunk native vlan 999
      SW(config-if)#switchport trunk allowed vlan 10
      ```
    - Mothership iSCSI (x2) - ensure you allow any necessary VLANs that your Observers may be a part of to the iSCSI trunks
      ```
      SW(config)#interface E#/#
      SW(config-if)#description Mothership iSCSI
      SW(config-if)#switchport mode trunk
      SW(config-if)#switchport trunk native vlan 999
      SW(config-if)#switchport trunk allowed vlan 10-13
      ```
    - EqualLogic Management (x2) - This must be configured on the 100MB capable switch unless your storage solution supports a 1GB connection
      ```
      SW(config)#interface Fe#/#
      SW(config-if)#description EqualLogic Management
      SW(config-if)#switchport mode access
      SW(config-if)#switchport access vlan 10
      ```
    - EqualLogic iSCSI (x2) 
      ```
      SW(config)#interface E#/#
      SW(config-if)#description EqualLogic iSCSI
      SW(config-if)#switchport access vlan 12
      ```

## ESXi Server
  - Raid Setup
    - Volume 1 (system) Create the first volume in a RAID1 configuration using the two 128GB HDDs.
  - NOTE: At this point you may need to use a Windows installation disc to reformat Volume 1, since ESXi doesn't support a RAID1 configuration very well.
  - Install ESXi 6.7.u1 onto Volume 1
  
### ESXi Management


## EqualLogic Server (Storage)
  - Configure the EqualLogic drives into RAID 5+0, this should leave you with around 4.7TB of usable space (if using the 128GB HDDs)
  - Configure Volumes:
    - 2.0TB - ARCHIVE (~45%)
    - 1.5TB - DATABASE (~33%)
    - 1.0TB - VMs (~22%)

## Elastic Cluster
The baseline build with be 3x CENTOS7 servers running elasticsearch with database storage on the EqualLogic.

### Create the Elastic VM
Create a new VM with the following configuration:
  - vCPUs: 2
  - RAM: 64GB
  - HDDs: 2
    - 30GB in the VMs volume (IDE slot 0)
    - 500GB in the DATABASE volume (IDE slot 1)
  - Network Adapter: management port-group

### Install CENTOS7
Manual Partitioning:

Mount Point | Partition Type | Size | Format | Volume Group
------------|----------------|------|--------|-------------
/boot | Standard | 1024 MB | xfs | -
swap | LVM | 10 GB | swap | "system"
/var | LVM | 500 GB | xfs | "database"
/ | LVM | ~19 GB | xfs | "system"

  - Notes:
    - As you choose each of the LVMs, you will have the option to create a new volume group - "system" for the 30GB HD and "database" for the 500GB HD
    - The root partition can take up the rest of the space on the 30GB HD, and if you attempt to create this one before creating both volume groups, the setup will not let you create another LVM, so create them in the order listed
