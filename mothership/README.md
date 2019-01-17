# Mothership

## Recommended Hardware Setup
  - Dell PowerEdge R820 (Current model in testing)
    - 96GB RAM 
    - 2x 128GB HDDs
    - 3 physical NICs 
  - Dell EqualLogic
    - 24x 128GB HDDs
    - 4 physical NICs (2 for redundancy)
    
## ESXi Server
  - Raid Setup
    - Volume 1 (system) Create the first volume in a RAID1 configuration using the two 128GB HDDs.
  - NOTE: At this point you may need to use a Windows installation disc to reformat Volume 1, since ESXi doesn't support a RAID1 configuration very well.
  - Install ESXi 6.7.u1 onto Volume 1
  
### ESXi Management


## EqualLogic Server (Storage)

## Network Configuration

