# ubuntu + mongo
FROM sxzt/ubuntu:latest
MAINTAINER sxzt sjzt2513@163.com

RUN apt -y update && \
	apt -y upgrade && \
	apt -y install curl && \
	apt -y install snmpd snmp snmp-mibs-downloader && \
	apt -y clean && \
    apt -y autoclean && \
    apt -y autoremove 
ENV DATA_PATH="/data/mongo/mongodb-data" 
ENV LOG_PATH="/data/mongo/mongodb-log/db.log" 
ENV MONGO_OPTION=" --fork --dbpath $DATA_PATH --logpath $LOG_PATH"
ENV MONGO_BASH mongo_start
COPY ./$MONGO_BASH /etc/rc.d/init.d/$MONGO_BASH


ENV MONGO_DIR="mongodb-linux-x86_64-ubuntu1804-4.0.2" 
ENV MONGO_DOWNLOAD_FILE="$MONGO_DIR.tgz" 
ENV MONGO_DOWNLOAD_URL="https://fastdl.mongodb.org/linux/$MONGO_DOWNLOAD_FILE"
ENV MONGO_INSTALL_PATH="/opt/mongo/$MONGO_DIR" 


 #environment variable editor
ENV PATH="$MONGO_INSTALL_PATH/bin:$PATH"


RUN mkdir -p $DATA_PATH
#download and install mongo

WORKDIR /opt/mongo

RUN echo $MONGO_DOWNLOAD_FILE
RUN wget $MONGO_DOWNLOAD_URL && \
    tar -xzvf $MONGO_DOWNLOAD_FILE && \
    rm $MONGO_DOWNLOAD_FILE

WORKDIR /etc/rc.d/init.d
RUN chmod 777 $MONGO_BASH 
#    update-rc.d $MONGO_BASH defaults

EXPOSE 27017

# docker run -dti --name xxx -v /x/xx:/data/mongo/mongodb-data sxzt/mongo

