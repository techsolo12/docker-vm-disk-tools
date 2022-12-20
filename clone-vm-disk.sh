#!/bin/sh

### Please check if the valuas are correct for your emvironment.

# Container ID SOURCE
SCID="213"

# Container ID TARGET
TCID="901"

# Disk number for SOURCE and TARGET vm-xxx-disk-x should normally be indentical. Only if you use more than ONE vm-disk on a LXC
# you need to check the numbers!

# Disk number from container SOURCE vm-xxx-disk-x
SDID="1"

# Disk number from container TARGET vm-xxx-disk-x
TDID="1"

# ZFS TARGET and SOURCE Poolname should normally be identical.
# It's only importent, if you want to clone a disk from a "old" pool to a "new" pool.

# ZFS Poolname TARGET
TPOOL="rpool"

# ZFS Poolname SOURCE
SPOOL="rpool"

# Filesystem for NEW vm-xxx-disk-x (ext4 / xfs)
FS="ext4"

### Script normally need to edit till this spot.

# Color CYAN for echo
CYAN='\033[0;36m'

# No Color echo
NC='\033[0m'

# Stop container before
pct stop "$SCID"
pct stop "$TCID"

# Create new vm-xxx-disk-x for TARGET Container
zfs create -s -V 8G "$TPOOL"/data/vm-"$TCID"-disk-"$TDID"
sleep 1
echo "vm-disk-$TCID-$TDID are created"

# Make a filsystem on new TARGET vm-xxx-disk-x
mkfs."$FS" /dev/zvol/"$TPOOL"/data/vm-"$TCID"-disk-"$TDID"
sleep 3

# Create a new tmp directory for the TARGET vm-xxx-disk-x
mkdir /tmp/docker-target-"$TCID"
sleep 1
echo "TMP directory for mounting the target vm-$TCID-disk-$TDID are created"

# Mount TARGET disk on /tmp/docker-target-ContainerID
mount /dev/zvol/"$TPOOL"/data/vm-"$TCID"-disk-"$TDID" /tmp/docker-target-"$TCID"/
sleep 1
echo "Target vm-$TCID-disk-$TDID are mounted"

# Set the correct ownership for TARGET vm-xxx-disk-x
chown -R 100000:100000 /tmp/docker-target-"$TCID"
sleep 1
echo "Ownership for mounted vm-$TCID-disk-$TDID are set"

# Create a new tmp directory for the SOURCE vm-xxx-disk-x
mkdir /tmp/docker-source-"$SCID"
sleep 1
echo "TMP directory for mounting the source vm-$SCID-disk-$SDID are created"

# Mount SOURCE disk on /tmp/docker-source-ContainerID
mount /dev/zvol/"$SPOOL"/data/vm-"$SCID"-disk-"$SDID" /tmp/docker-source-"$SCID"/
sleep 1
echo "Source vm-$SCID-disk-$SDID are mounted"

# Rsync the docker stuff from SOURCE vm-xxx-diks-x to TARGET vm-xxx-disk-x
rsync -a -h --stats /tmp/docker-source-"$SCID"/* /tmp/docker-target-"$TCID"/

# Unmount TARGET vm-xxx-disk-x
umount /tmp/docker-target-"$TCID"
echo "Target vm-$TCID-disk-$TDID now unmounted on pve host"
sleep 1

# Unmount SOURCE vm-xxx-disk-x
umount /tmp/docker-source-"$SCID"
echo "Source vm-$SCID-disk-$SDID now unmounted on pve host"
sleep 1

# Remove TARGET and SOURCE mounting directorys
rmdir /tmp/docker-target-"$TCID" /tmp/docker-source-"$SCID"
sleep 1

# Rescan LXC volumes for new disks
pct rescan

# Print to inform user for next steps on Web UI
echo "Rescan and copy process are complete."
echo "Check the ${CYAN}LXC$TCID${NC}.${CYAN}Edit vm-$TCID-disk-$TDID ${NC}on LXC$TCID"
echo "Please mount ${CYAN}vm-$TCID-disk-$TDID to path /var/lib/docker${NC}"
