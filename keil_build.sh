#! /bin/bash

#Invoke example: $ keil_build.sh FRDM-K22F_RC2 FRDM-K22F_RC1    ### File types are optional

DIR=$1
SHELL_DIR=`pwd`
# echo "The Shell execution dir is: $SHELL_DIR"
echo "About to build projects under dir: $DIR"
echo ""
failedCase=0
totalCase=`find $DIR -name "*.uvprojx" | wc -l`
totalCase=`expr 2 \* "$totalCase"`
if [ -e ./final_log_keil.txt ]; then
    rm ./final_log_keil.txt
else
    touch ./final_log_keil.txt
fi

echo "=============================== Build Start ===============================" >> final_log_keil.txt
# echo "0: Now is in dir: `pwd`"
time_start=`date`

#find $DIR -name "*.ewp" | xargs -n 1 iarbuild -build Debug -log warnings
#find $DIR -name "*.ewp" | xargs -n 1 iarbuild -build Release -log warnings
for PRJ in `find $DIR -name "*.uvprojx"`
do
    # echo "1: Now is in dir: `pwd`"
    # echo "\$PRJ is : $PRJ"
    # echo "`basename $PRJ .uvprojx`"
    PRJ_DIR=`dirname "$PRJ"`
    # echo "\$PRJ_DIR is : $PRJ_DIR"
    PRJ_NAME_TEMP=`ls $PRJ_DIR/*.uvprojx`
    PRJ_NAME=`basename "$PRJ_NAME_TEMP" .uvprojx`
    echo "***** Start to build project: $PRJ_NAME Debug & Release *****"

    UV4.exe -b $PRJ -j0 -t "`basename $PRJ .uvprojx` Debug" -o  temp_log.txt
    if [ "$?" != "0" ]; then
        cat `dirname $PRJ`/temp_log.txt >> final_log_keil.txt
        echo "$PRJ Debug   target build failed!" >> final_log_keil.txt
        echo ""
        failedCase=`expr "$failedCase" + 1`
    fi
    rm `dirname $PRJ`/temp_log.txt

    UV4.exe -b $PRJ -j0 -t "`basename $PRJ .uvprojx` Release" -o temp_log.txt
    if [ "$?" != "0" ]; then
        cat `dirname $PRJ`/temp_log.txt >> final_log_keil.txt
        echo "$PRJ Release target build failed!" >> final_log_keil.txt
        echo ""
        failedCase=`expr "$failedCase" + 1`
    fi
    rm `dirname $PRJ`/temp_log.txt
done
#rm temp_log.txt

# echo "2: Now is in dir: `pwd`"
time_end=`date`

echo "=============================== Build End ===============================" >> final_log_keil.txt
echo "Total cases:  $totalCase" >> final_log_keil.txt
echo "Failed cases: $failedCase" >> final_log_keil.txt
echo "Time elapse from:    $time_start  ----->  $time_end    " >> final_log_keil.txt
echo "Please check the final_log_keil.txt under dir: $SHELL_DIR"

# echo "Now is in dir: `pwd`"


