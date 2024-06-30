#!/bin/bash


#
# to prepare: change: BUILDROOT_DIR,DEVICE_DISK,DEVICE_DISK_P
#


function setEnvironment() {
	export ARCH=arm
	export CROSS_COMPILE=arm-linux-gnueabihf-

	export BUILDROOT_DIR=/mnt/ssd/projects/lichee/lichee_pi/buildroot-2023.08

	export UBOOT_DIR=${BUILDROOT_DIR}/output/images
	export UBOOT_FILE_NAME=u-boot-sunxi-with-spl.bin
	export UBOOT_FILE_NAME_NORFLASH=uboot_spi.bin

	export KERNEL_DIR=${BUILDROOT_DIR}/output/images
	export KERNEL_FILE_NAME_ZIAMGE=./zImage
	export KERNEL_FILE_NAME_DTB=./sun8i-v3s-licheepi-*.dtb
	export KERNEL_FILE_NAME_MODULES=out/lib/*

	export ROOTFS_DIR=${BUILDROOT_DIR}/output/images
	export ROOTFS_FILE_NAME=rootfs.tar

	export FOOTFS_HOME=/home/fademike/Yandex.Disk/ubuntu/board/licheepi/home_iot

	export MOUNT_DIR=/media/fademike

	export DEVICE_DISK=/dev/sdc
	export DEVICE_DISK_P=/dev/sdc



}


function mount_fs() {
	udisksctl mount -b ${DEVICE_DISK_P}1
	udisksctl mount -b ${DEVICE_DISK_P}2
}

function umount_fs() {

	#sudo umount ${DEVICE_DISK}p1
	#sudo umount ${DEVICE_DISK}p2
	#sudo umount ${DEVICE_DISK}p3

	sudo udisksctl unmount -b ${DEVICE_DISK_P}1 2> /dev/null
	sudo udisksctl unmount -b ${DEVICE_DISK_P}2 2> /dev/null

	if [ -f ${MOUNT_DIR}/boot ] 
	then 
		echo "### boot error unmount"
		exit
	fi
	if [ -f ${MOUNT_DIR}/rootfs ] 
	then 
		echo "### rootfs error unmount"
		exit
	fi
}


function make_fs() {

	if [ ! -e ${DEVICE_DISK} ]; then 
		echo "### uSD not found! exit"
		exit
	else 
		echo "### prepare file system.."; sleep 2
	fi


	if [ ! -f ${UBOOT_DIR}/${UBOOT_FILE_NAME} ]; then 
		echo "### u-boot.imx arch not found! exit"
		exit
	fi

	#sudo umount ${MOUNT_DIR}/*
	
	sudo fdisk ${DEVICE_DISK} << EOF
		d
		
		d
		
		n
		p
		
		
		+1G
		y
		n
		p
		
		
		
		y
		p
		w
		q
EOF

	sudo dd if=${UBOOT_DIR}/${UBOOT_FILE_NAME} of=${DEVICE_DISK} bs=1024 seek=8

	sudo mkfs.vfat ${DEVICE_DISK_P}1 -n boot
	sudo mkfs.ext4 ${DEVICE_DISK_P}2 -L rootfs
	echo "### sync..."
	sync
	
	echo "### prepare file system..ok"
}

function copy_to_sd_rootfs() {
	echo "### sudo rm -Rf /media/fademike/rootfs/* "; sleep 2

	if [ ! -f ${ROOTFS_DIR}/${ROOTFS_FILE_NAME} ]; then 
		echo "### rootfs arch not found! exit"
		exit
	fi

	sudo rm -Rf ${MOUNT_DIR}/rootfs/*
	sync
	echo "### sudo tar zxf rootfs.tgz -C /media/fademike/rootfs/"; sleep 2
	sudo tar xf ${ROOTFS_DIR}/${ROOTFS_FILE_NAME} -C ${MOUNT_DIR}/rootfs/

	sync

}

function copy_to_sd_other() {
	echo "### add zImage *dtb, include..."; sleep 2

	if [ ! -f ${KERNEL_DIR}/${KERNEL_FILE_NAME_ZIAMGE} ]; then 
		echo "### zImage not found! exit"
		exit
	fi

	cp ${KERNEL_DIR}/${KERNEL_FILE_NAME_ZIAMGE} ${MOUNT_DIR}/boot/
	cp ${KERNEL_DIR}/${KERNEL_FILE_NAME_DTB} ${MOUNT_DIR}/boot/

#	copy uboot, rootfs for nor flash
	cp ${UBOOT_DIR}/${UBOOT_FILE_NAME_NORFLASH} ${MOUNT_DIR}/boot/
	cp ${ROOTFS_DIR}/rootfs.squashfs ${MOUNT_DIR}/boot/
	
	
	sync
	
}


function main() {
	echo "### mk SD: start."; sleep 2
	setEnvironment

	umount_fs
	make_fs

	mount_fs
	copy_to_sd_rootfs
	copy_to_sd_other

	#sudo cp -Rf ${FOOTFS_HOME}/* ${MOUNT_DIR}/rootfs/root/

	echo "### sync"
	sync
	echo "### update rootfs: ok."
}

main


