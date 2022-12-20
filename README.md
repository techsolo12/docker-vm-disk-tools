# docker-vm-disk-tools

Hey! Docker-vm-disk-tools is very simpel scriptset for administrating vm-disks for a Docker runtime in a LXC
Mainly it's created for a very specify installation from Docker in a LXC which storage is based on a ZFS Pool on Proxmox VE.

Restore-vm-disk is a semi-automated script to create a new vm-disk to Proxmox LXC Container after a restore. You only need to edit the variabel for your environment. After execution of the script you edit the disk through Proxmox VE Web UI and set path to ```/var/lib/docker```

1. Copy script to your local machine ```nano restore-vm-disk.sh```
2. Make executeable ```chmod +x restore-vm-disk.sh```
3. Edit your ContainerID [CID], new disk number [DID] and old disk number [ODID].
4. Follow instructions after script execution

How to find the "old disk number" after a restore:
1. Open Proxmox Web UI and select LXC container you want to edit.
2. Open tab "Ressources" and search for a disk with name like "subvol-xxx-disk-x" and mount path "/var/lib/docker"
3. The number after "disk" is the number you search.

Clone-vm-disk is also a semi-automated script, which clone a existing vm-disk to a new or previous existing LXC Container. You need to do this, if you want to clone a LXC with this specifiy Docker installation. Since LXC Templates are broken with this installation method it's the only way to have "Template" Container to do this.

Normally the [SDID] and [TDID] are identical. Only if you had more the one disk on source container.
Normally also the [SPOOL] and [TPOLL] are indentical. It's can be different, if you want to clone a vm-disk from a "old" pool to a "new" pool.

1. Copy script to your local machine ```nano clone-vm-disk.sh```
2. Make executeable ```chmod +x clone-vm-disk.sh```
3. Edit your Source ContainerID [SCID], the Target ContainerID [TCID], the source disk number [SDID], the target disk number [TDID], your source ZFS poolname [SPOOL], your target ZFS poolname [TPOOL] and the needed filesystem [FS].
4. Follow instructions after script execution
