#!/bin/bash

PROG="mongod"
## 安装路径
PROG_PATH="$MONGO_INSTALL_PATH" 
PROG_ARGS="$MONGO_OPTION"

## 定义启动函数
startMongo() {
    ## 如果pid文件存在，认为已经存在一个进程
    if [ -e "$DATA_PATH/$PROG.pid" ]; then
        echo "Error! $PROG is currently running!" 1>&2
    else
## 启动命令，错误重定向输出到/var/log/目录下
        $PROG_PATH/bin/$PROG $PROG_ARGS 2>&1 >/var/log/$PROG &
    pid=`ps ax | grep -i 'bin/mongod' | sed 's/^\([0-9]\{1,\}\).*/\1/g' | head -n 1`

        echo "$PROG started"
## 获取进程号存到pid文件中
        echo $pid > "$DATA_PATH/$PROG.pid"
    fi
}

## 定义关闭函数
stopMongo() {
    echo "begin stop"
    if [ -e "$DATA_PATH/$PROG.pid" ]; then
        ## kill掉进程
    pid=`ps ax | grep -i 'bin/mongod' | sed 's/^\([0-9]\{1,\}\).*/\1/g' | head -n 1`
    kill $pid
    ## 删除pid文件
        rm -f  "$DATA_PATH/$PROG.pid"
        echo "$PROG stopped"
    else
        echo "Error! $PROG not started!" 1>&2
        exit 1
    fi
}

initLeanoteData(){
    if [ -e "$DATA_PATH/initdata.flag" ]; then
        echo "alread init data for leanote"
    else
    	while ( [ -e "$DATA_PATH/$PROG.pid" ] &&  [ ! -e "$DATA_PATH/initdata.flag" ] )
        do
            mongorestore -h localhost -d leanote --dir $LEANOTE_INIT_DATA_DIR
            echo "init data" > "$DATA_PATH/initdata.flag"
        done
    fi
}

startLeanote(){
	$LEANOTE_RUN_BASH_PATH &
    echo "leanote started"
}

main(){
    startMongo
    initLeanoteData
    startLeanote
}

main

