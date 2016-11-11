#!/bin/sh
ZE_DOMAIN=/opt/zephyr/tomcat/
JAVA_BIN=/usr/java/jdk1.8.0_77/bin
LOG_DIR=$ZE_DOMAIN/logs
SCRIPT_LOG=$LOG_DIR/heap_dumps.log
MS_PID=`ps -aux |grep java |grep zephyr |awk '{print $2}'`
echo $MS_PID
echo "`date +%x" "%X` Starting Heap Dump $DUMP_COUNT" >> $SCRIPT_LOG
$JAVA_BIN/jmap -heap:format=b $MS_PID >>$SCRIPT_LOG 2>&1
mv heap.bin $LOG_DIR/heap_ZE`date +%m%d%Y_%H%M`.bin
echo "`date +%x" "%X` Completed Heap Dump $DUMP_COUNT" >> $SCRIPT_LOG
