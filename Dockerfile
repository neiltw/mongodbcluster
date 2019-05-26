from centos:centos7.6.1810

RUN curl -L -O  https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-6.6.2-linux-x86_64.tar.gz

RUN tar xzvf filebeat-6.6.2-linux-x86_64.tar.gz 

RUN rm -rf filebeat-6.6.2-linux-x86_64.tar.gz && \
    mv filebeat-6.6.2-linux-x86_64 /filebeat && cp /filebeat/filebeat /usr/bin/ && \
    useradd -ms /bin/bash  filebeat && cd /filebeat && filebeat modules enable mongodb 


RUN yum install -y  openssl vim  wget  iproute iproute-doc

RUN cd / && \
    wget https://fastdl.mongodb.org/linux/mongodb-linux-x86_64-rhel70-4.0.9.tgz && \
    tar -xzvf mongodb-linux-x86_64-rhel70-4.0.9.tgz && \
    rm -rf mongodb-linux-x86_64-rhel70-4.0.9.tgz && \
    mv mongodb-linux-x86_64-rhel70-4.0.9 /mongodb

ENV PATH=/filebeat:/mongodb/bin:$PATH

RUN mkdir -p /var/lib/mongo  /var/log/mongodb /etc/mongo /data/db && \
    useradd -ms /bin/bash  mongod && \
    chown -R mongod:mongod /var/log/mongodb && \
    chown -R mongod:mongod /var/lib/mongo

RUN openssl rand -base64 756 > /etc/mongo/mongodb.key && \
    chmod 400 /etc/mongo/mongodb.key && \
    chown -R mongod:mongod /data/db

RUN yum clean all 

VOLUME /data/db /etc/mongo

EXPOSE 27017

CMD ["mongod"]
