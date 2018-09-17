# Analyst Workstation Build 1.0

The analyst workstation is a collections of tools used to collect and analyze data.  This workstationi can work as part of the overall Open Operations Center system or standalone.

This system is built with the intent to collect, analyze and correlate information across all data domains.

Functions for this software bulid include the following modes:

### Analyst Workstation
    Integration with security operations services for event triage.

### IR Workstation
    Incident Response and Forensics

### Sensor Workstation
    Data Collection and Processing

-------------------------------------


## Install CENTOS07

http://isoredirect.centos.org/centos/7/isos/x86_64/CentOS-7-x86_64-DVD-1804.iso

- Choose Creative/Development Workstation Build
- Install OS on SSD drive
- Set Root PW
- Update repos and system after install is complete

## Install VMware Workstation Pro 

**Any virtualization software will work, but VMware Workstation is what is tested**

*Install according to the VMware proceedures for CentOS07*

    https://www.vmware.com/products/workstation-pro.html

- Advise not signing up for checking for updates every time the software is started
- Advise not checking the "send VMware info to make this product better box"

'''
Licensing:  Generally if you are working in a large organization there is some sort of enterprise VMware deployment.  With many of the versions of vSphere come obligatory sets of Workstation Pro, get with your   purchasing manager to login to the my.vmware.com account and find the workstation licenses that no one is using! 

If you are an individual or don't have that resource available, I recommend using the Vmware Advantage Program 
    https://www.vmug.com/Join/VMUG-Advantage-Membership
for 200 dollars you get access to all the enterprise software for a year.
'''

### Create Windows 10 Virtual Machine
Start vmware workstation

> sudo vmware

Create a virtual machine with the following minimum specs:

OS|CPU|RAM|Disk|NIC
--|---|---|----|---
Win10x64|4|4GB|100GB

Options
- Store virtual disk as single file
- save as /home/vms/Win10-64-AW1
- Install VMware Tools







