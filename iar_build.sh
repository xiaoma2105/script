#! /bin/bash

#Invoke example: $ iar_build.sh FRDM-K22F_RC2 FRDM-K22F_RC1    ### File types are optional

DIR=$1
SHELL_DIR=`pwd`
echo "About to build projects under dir: $DIR"
echo ""
#cd $DIR
failedCase=0
totalCase=`find $DIR -name "*.ewp" | wc -l`
totalCase=`expr 2 \* "$totalCase"`
if [ -e ./final_log_iar.txt ]; then
    rm ./final_log_iar.txt
else
    touch ./final_log_iar.txt
fi

echo "=============================== Build Start ===============================" >> final_log_iar.txt
# echo "0: Now is in dir: `pwd`"
time_start=`date`

#find $DIR -name "*.ewp" | xargs -n 1 iarbuild -build Debug -log warnings
#find $DIR -name "*.ewp" | xargs -n 1 iarbuild -build Release -log warnings
for PRJ in `find $DIR -name "*.ewp"`
do
    # echo "1: Now is in dir: `pwd`"
    PRJ_DIR=`dirname "$PRJ"`
    PRJ_NAME_TEMP=`ls $PRJ_DIR/*.ewp`
    PRJ_NAME=`basename "$PRJ_NAME_TEMP" .ewp`
    echo "***** Start to build project: $PRJ_NAME Debug & Release *****"

    iarbuild $PRJ -build Debug -log warnings   > temp_log.txt
    if [ "$?" != "0" ]; then
        cat temp_log.txt >> final_log_iar.txt
        echo "$PRJ Debug   target build failed!" >> final_log_iar.txt
        failedCase=`expr "$failedCase" + 1`
    fi

    iarbuild $PRJ -build Release -log warnings  > temp_log.txt
    if [ "$?" != "0" ]; then
        cat temp_log.txt >> final_log_iar.txt
        echo "$PRJ Release target build failed!" >> final_log_iar.txt
        failedCase=`expr "$failedCase" + 1`
    fi
done
rm temp_log.txt

# echo "2: Now is in dir: `pwd`"
time_end=`date`

echo "=============================== Build End ===============================" >> final_log_iar.txt
echo "Total cases:  $totalCase" >> final_log_iar.txt
echo "Failed cases: $failedCase" >> final_log_iar.txt
echo "Time elapse from:    $time_start  ----->  $time_end    " >> final_log_iar.txt
echo "Please check the final_log_iar.txt at: $SHELL_DIR "

# echo "Now is in dir: `pwd`"


