#!/bin/bash
### LSI_0

function wait_for {
	while true;
	sleep 100
	do
		megacli -LDGetProp Consistency -L$1 -a0|grep 'Consistent' && return 0
		echo waiting for 10min for initialization
		sleep 600
	done
}
function create_LSI_10 {
	megacli -CfgSpanAdd -r10 -Array0[32:2,32:3] -Array1[32:4,32:5] -Array2[32:6,32:7] -Array3[32:8,32:9] -Array4[32:10,32:11] Direct WT NORA -a0
	megacli -LDSetProp -EnDskCache -L1 -a0
	blockdev --setra 0 /dev/sdb
	sleep 8000
}

function create_LSI_50 {
	megacli -CfgSpanAdd -r50 -Array0[32:2,32:3,32:4,32:5,32:6] -Array1[32:7,32:8,32:9,32:10,32:11] Direct WT NORA -a0
	megacli -LDSetProp -EnDskCache -L1 -a0
	blockdev --setra 0 /dev/sdb
	sleep 8000
}

function create_LSI_60 {
	megacli -CfgSpanAdd -r50 -Array0[32:2,32:3,32:4,32:5,32:6] -Array1[32:7,32:8,32:9,32:10,32:11] Direct WT NORA -a0
	megacli -LDSetProp -EnDskCache -L1 -a0
	blockdev --setra 0 /dev/sdb
}


function create_LSI_0 {
	megacli -CfgLdAdd -r0 [32:2,32:3,32:4,32:5,32:6,32:7,32:8,32:9,32:10,32:11] Direct WT NORA -a0
	megacli -LDSetProp -EnDskCache -L1 -a0
	blockdev --setra 0 /dev/sdb
	sleep 8000
}
function create_LSI_5 {
	megacli -CfgLdAdd -r5 [32:2,32:3,32:4,32:5,32:6,32:7,32:8,32:9,32:10,32:11] Direct WT NORA -a0
	megacli -LDSetProp -EnDskCache -L1 -a0
	megacli -LDInit -Start -L1 -a0
	sleep 8000
	blockdev --setra 0 /dev/sdb
}
function create_LSI_6 {
	megacli -CfgLdAdd -r6 [32:2,32:3,32:4,32:5,32:6,32:7,32:8,32:9,32:10,32:11] Direct WT NORA -a0
	megacli -LDSetProp -EnDskCache -L1 -a0
	megacli -LDInit -Start -L1 -a0
	sleep 8000
	blockdev --setra 0 /dev/sdb
}
function delete_LSI_0 {
	 megacli -CfgLdDel -L1 -a0
}
function delete_LSI_5 {
	 megacli -CfgLdDel -L1 -a0
}
function delete_LSI_6 {
	 megacli -CfgLdDel -L1 -a0
}
function delete_LSI_10 {
	 megacli -CfgLdDel -L1 -a0
}
function delete_LSI_50 {
	 megacli -CfgLdDel -L1 -a0
}
function delete_LSI_60 {
	 megacli -CfgLdDel -L1 -a0
}

function wipe {
	fio --name=write --blocksize=1M --rw=randwrite --direct=1 --buffered=0 --ioengine=libaio --iodepth=2  --filename=$1 >/dev/nul
}


function fiotest {
	rm $3.log
	set -v
	echo 4k/io1/read
	fio --size=100G --name=$3 --blocksize=4k --rw=randread --direct=1 --buffered=0 --ioengine=libaio --iodepth=1 --filename=$1 --minimal >>$3.log
	echo 4k/io1/write
	fio --size=100G --name=$3 --blocksize=4k --rw=randwrite --direct=1 --buffered=0 --ioengine=libaio --iodepth=1 --filename=$1 --minimal >>$3.log
	echo 4k/io32/read
	fio --size=100G --name=$3 --blocksize=4k --rw=randread --direct=1 --buffered=0 --ioengine=libaio --iodepth=32 --filename=$1 --minimal >>$3.log
	echo 4k/io32/write
	fio --size=100G --name=$3 --blocksize=4k --rw=randwrite --direct=1 --buffered=0 --ioengine=libaio --iodepth=32 --filename=$1 --minimal >>$3.log
	echo 256k/io32/read
	fio --size=100G --name=$3 --blocksize=256k --rw=randread --direct=1 --buffered=0 --ioengine=libaio --iodepth=32 --filename=$1 --minimal >>$3.log
	echo 256k/io32/write
	fio --size=100G --name=$3 --blocksize=256k --rw=randwrite --direct=1 --buffered=0 --ioengine=libaio --iodepth=32 --filename=$1 --minimal >>$3.log
}
#create_LSI_0
#wipe /dev/sdb
#fiotest /dev/sdb 320 LSI_0
#delete_LSI_0
#sleep 1
#create_LSI_5
#wipe /dev/sdb
#fiotest /dev/sdb 256 LSI_5
#delete_LSI_5
#sleep 1
#create_LSI_6
#wipe /dev/sdb
#fiotest /dev/sdb 224 LSI_6
#delete_LSI_6
#sleep 1

create_LSI_10
fiotest /dev/sdb 224 LSI_10
delete_LSI_10
sleep 1

create_LSI_50
fiotest /dev/sdb 224 LSI_50
delete_LSI_50
sleep 1

#create_LSI_60
#fiotest /dev/sdb 224 LSI_10
#delete_LSI_10
#sleep 1

