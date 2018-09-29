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
ENV MONGO_OPTION="--dbpath $DATA_PATH "
ENV MONGO_BASH mongo_start
ENV LEANOTE_DIR_NAME leanote
ENV LEANOTE_FILE $LEANOTE_DIR_NAME.tar.gz
ENV LEANOTE_INIT_DATA_DIR /opt/$LEANOTE_DIR_NAME/mongodb_backup/leanote_install_data/
ENV MONGO_DIR="mongodb-linux-x86_64-ubuntu1804-4.0.2" 
ENV MONGO_DOWNLOAD_FILE="$MONGO_DIR.tgz" 
#ENV MONGO_DOWNLOAD_URL="https://fastdl.mongodb.org/linux/$MONGO_DOWNLOAD_FILE"
ENV MONGO_INSTALL_PATH="/opt/$MONGO_DIR"

ENV LEANOTE_PORT 10008
ENV LEANOTE_SECRET V85ZzBeTnzpsHyjQX4zukbQ8qqtju9y2aDM55VWxAH9Qop19poekx3WZTDVvrD0y


WORKDIR /opt/

ADD $LEANOTE_FILE ./
ADD $MONGO_DOWNLOAD_FILE ./ 

ENV LEANOTE_RUN_BASH_PATH /opt/$LEANOTE_DIR_NAME/bin/run.sh
RUN chmod 777 $LEANOTE_RUN_BASH_PATH



#environment variable editor
ENV PATH="$MONGO_INSTALL_PATH/bin:$PATH"


RUN mkdir -p $DATA_PATH

VOLUME $DATA_PATH

ENV MONGO_START_BASH="$MONGO_INSTALL_PATH/bin/mongod $MONGO_OPTION"
COPY run.sh /root/run.sh
RUN chmod 777 /root/run.sh

ENTRYPOINT ["/root/run.sh"]

EXPOSE $LEANOTE_PORT

# docker run --name leanote-volume -v /xxx:/data/mongo/mongodb-data sxzt/ubuntu
# docker run -p xxxx:10008 -dti --name xxx --volumes-from leanote-volume  sxzt/leanote 

