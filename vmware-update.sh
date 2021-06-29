#!/bin/bash

VMWVC=$(vmware -v | cut -d' ' -f 3)
VMWARE_VERSION=workstation-$VMWVC
VMWARE_KVERSION=w$VMWVC-k$(uname -r | cut -d'-' -f 1 | head -c 4)

GITHUB_MODULES_ROOT=https://github.com/mkubecek
GITHUB_GIT=$GITHUB_MODULES_ROOT/vmware-host-modules.git
GITHUB_HOST_MODULES=$GITHUB_MODULES_ROOT/vmware-host-modules
GITHUB_MODULES_RELEASE_PAGE=$GITHUB_HOST_MODULES/archive/refs/tags

TMP_FOLDER=/tmp/patch-vmware

################################################################################
# Help                                                                         #
################################################################################
Help()
{
    if [ -z "$VMWVC" ]; then
        VMVC_LINK="'$GITHUB_HOST_MODULES'"
    else
        VMVC_LINK="'$GITHUB_HOST_MODULES/tree/$VMWARE_VERSION'-branch"
    fi

    # Display Help
    echo "Use one of the following options to decide how vmware-modules should be installed"
    echo
    echo "Syntax: scriptTemplate [-k|K|-kernel|kernel]"
    echo "options:"
    echo "empty   Download modules from $VMVC_LINK"
    echo "k       Download source from '$GITHUB_MODULES_RELEASE_PAGE' and install it"
    echo
}

Build()
{
    echo
    echo "Attempt to install vmware-host-modules for $VMWARE_VERSION"
    echo
    make
    sudo make install
    sudo rm /usr/lib/vmware/lib/libz.so.1/libz.so.1
    sudo ln -s /lib/x86_64-linux-gnu/libz.so.1 /usr/lib/vmware/lib/libz.so.1/libz.so.1
    sudo /etc/init.d/vmware restart
    echo
    echo "Clean up '$TMP_FOLDER' ..."
    echo
    Clean
}

Clean()
{
    rm -fdr $TMP_FOLDER
}

Clean
mkdir -p $TMP_FOLDER
cd $TMP_FOLDER

if [ $1 = "-h" ]; then
    Help
elif [ $1 = "-k" ] || [ $1 = "k" ] || [ $1 = "-K" ] || [ $1 = "K" ] || [ $1 = "-kernel" ] || [ $1 = "kernel" ] ]; then
    echo
    echo "Downloading '$VMWARE_KVERSION' modules"
    echo
    mkdir -p $TMP_FOLDER/vmware-host-modules
    cd $TMP_FOLDER/vmware-host-modules
    wget $GITHUB_MODULES_RELEASE_PAGE/$VMWARE_KVERSION.zip
    unzip $VMWARE_KVERSION.zip
    cd $TMP_FOLDER/vmware-host-modules/vmware-host-modules-$VMWARE_KVERSION
    Build
else
    echo
    echo "Downloading '$VMWARE_VERSION' modules"
    echo "Cloning '$GITHUB_GIT' repo"
    git clone $GITHUB_GIT
    echo
    cd $TMP_FOLDER/vmware-host-modules
    echo "Checkout $VMWARE_VERSION from '$GITHUB_HOST_MODULES'"
    git checkout $VMWARE_VERSION
    git fetch
    echo
    Build
 fi
