This is just a simple script to update VMWares kernel modules in case you updated your kernel.

To run this script, make sure you have set it to be executable: ```chmod a+x vmware_update.sh```

Then just simply run it with: ```./vmware_update.sh```

This usually will detect your current installed vmware-version (```vmware -v```) and will update the kernel modules for your version.
