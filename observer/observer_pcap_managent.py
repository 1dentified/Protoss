#pcap storage management
#TStheMechanic #iambecomed  #not finished!!!!

#check /data/moloch/raw
#check / available space
#
import os
import shutil
import fnmatch

usage_threshold = 50
pcapdir = '/data/moloch/raw'
giga = 1000 * 1000 * 1000
logfile = '/logfilelocationandname'

os.chdir ('/data/moloch/raw/')

results=os.statvfs(pcapdir)
freegb = results.f_bfree * results.f_frsize * giga

pcaps = os.listdir()

match = fnmatch.filter(pcaps, )

if freegb >= usageThreshold:

    os.listdir(pcapdir)
    shutil.move(desitnation, source)
    
log = open(logfile)
