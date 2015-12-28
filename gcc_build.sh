#! /bin/bash

#Invoke example: $ gcc_build.sh FRDM-K22F_RC2 FRDM-K22F_RC1    ### File types are optional

DIR=$1
SHELL_DIR=`pwd`
echo "About to build projects under dir: $DIR"
echo ""
#cd $DIR
failedCase=0
totalCase=`find $DIR -name "CMakeLists.txt" | wc -l`
totalCase=`expr 2 \* "$totalCase"`
if [ -e ./final_log_gcc.txt ]; then
    rm ./final_log_gcc.txt
else
    touch ./final_log_gcc.txt
fi

echo "=============================== Build Start ===============================" >> final_log_gcc.txt
# echo "0: Now is in dir: `pwd`"
time_start=`date`

for PRJ in `find $DIR -name "CMakeLists.txt"`
do
    # echo "\$PRJ is: $PRJ"
    # echo "1: Now is in dir: `pwd`"
    PRJ_DIR=`dirname "$PRJ"`
    # echo "Project dir name is: $PRJ_DIR"
    PRJ_NAME_TEMP=`ls $PRJ_DIR/../iar/*.ewp`
    # echo "Project name temp is: $PRJ_NAME_TEMP"
    PRJ_NAME=`basename "$PRJ_NAME_TEMP" .ewp`
    echo "***** Start to build project: $PRJ_NAME Debug & Release *****"

    cd $PRJ_DIR
    TOOL_FILE=`head -1 build_release.bat | sed "s/-G.*$//g" | sed "s/cmake //g" | sed "s/-DCMAKE_TOOLCHAIN_FILE=//g" |
    sed "s/\"//g"`
    # echo "Tool file is: $TOOL_FILE"

    cmake -DCMAKE_TOOLCHAIN_FILE="$TOOL_FILE" -G "MinGW Makefiles" -DCMAKE_BUILD_TYPE=Debug . > $SHELL_DIR/temp_log.txt
    cmake -DCMAKE_TOOLCHAIN_FILE="$TOOL_FILE" -G "MinGW Makefiles" -DCMAKE_BUILD_TYPE=Debug . > $SHELL_DIR/temp_log.txt
    mingw32-make -j4 > $SHELL_DIR/temp_log.txt 2>&1


    if [ "$?" != "0" ]; then
        cat $SHELL_DIR/temp_log.txt >> $SHELL_DIR/final_log_gcc.txt
        echo "$PRJ Debug   target build failed!" >> $SHELL_DIR/final_log_gcc.txt
        failedCase=`expr "$failedCase" + 1`
        echo ""
    fi

    cmake -DCMAKE_TOOLCHAIN_FILE="$TOOL_FILE" -G "MinGW Makefiles" -DCMAKE_BUILD_TYPE=Release . > $SHELL_DIR/temp_log.txt
    cmake -DCMAKE_TOOLCHAIN_FILE="$TOOL_FILE" -G "MinGW Makefiles" -DCMAKE_BUILD_TYPE=Release . > $SHELL_DIR/temp_log.txt
    mingw32-make -j4 > $SHELL_DIR/temp_log.txt 2>&1
    if [ "$?" != "0" ]; then
        cat $SHELL_DIR/temp_log.txt >> $SHELL_DIR/final_log_gcc.txt
        echo "$PRJ Release target build failed!" >> $SHELL_DIR/final_log_gcc.txt
        failedCase=`expr "$failedCase" + 1`
        echo ""
    fi
    # cd -          ### change directory to previous one
    echo ""
    cd $SHELL_DIR
  
done
rm  $SHELL_DIR/temp_log.txt

# echo "2: Now is in dir: `pwd`"
time_end=`date`

echo "=============================== Build End   ===============================" >> final_log_gcc.txt
echo "Total cases:  $totalCase" >> final_log_gcc.txt
echo "Failed cases: $failedCase" >> final_log_gcc.txt
echo "Time elapse from:    $time_start  ----->  $time_end    " >> final_log_gcc.txt
echo "Please check the final_log_gcc.txt at: $SHELL_DIR"

# echo "Now is in dir: `pwd`"


