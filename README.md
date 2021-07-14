This is just a simple script to update VMWares kernel modules in case you updated your kernel.

To run this script, make sure you have set it to be executable: ```chmod a+x vmware_updater```

Then just simply run it with: ```./vmware_updater``` (for the standard logic - fetching source from [vmware-host-modules](https://github.com/mkubecek/vmware-host-modules) branches) or via ```./vmware_updater -k``` (to fetch a more recent version (if not available as a branch) - most likely for newer kernels).

This usually will detect your current installed vmware-version (```vmware -v```), kernel version too and will update the respective kernel modules for your version.
