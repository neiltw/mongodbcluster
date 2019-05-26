version: '3.5'
    
services:
    conf:
    image: mongo-cluster:4.0.9
    container_name: conf
    hostname: configserver
    network_mode: host
        
    volumes:
      - /opt/mongodb/conf:/data/db
      - /opt/config-no.conf:/etc/config-no.conf
        
    command: &gt;
      sh -c "mongod --port 27019 --config /etc/config-no.conf --keyFile /etc/mongo/mongodb.key"
        
    logging:
      driver: json-file
      options:
        max-size: "100m"
        max-file: "5"
    sysctls:
      - net.core.somaxconn=1024
    ulimits:
      nproc: 65535
      nofile:
        soft: 20000
        hard: 40000
        
    ports:
      - 27019:27019
        
    extra_hosts:
      - mongo-cluster-1:192.168.56.228
      - mongo-cluster-2:192.168.56.241
      - mongo-cluster-3:192.168.56.242
        
        
    shard:
    image: mongo-cluster:4.0.9
    container_name: shard
    hostname: shard
        
    network_mode: host
        
    volumes:
      - /opt/mongodb/shard1:/data/db
      - /opt/shard-no.conf:/etc/shard-no.conf
        
    command: &gt;
      sh -c "mongod --port 27018 --config /etc/shard-no.conf --keyFile /etc/mongo/mongodb.key"
        
    logging:
      driver: json-file
      options:
        max-size: "100m"
        max-file: "5"
    sysctls:
      - net.core.somaxconn=1024
    ulimits:
      nproc: 65535
      nofile:
        soft: 20000
        hard: 40000
        
    ports:
      - 27018:27018
        
    extra_hosts:
      - mongo-cluster-1:192.168.56.228
      - mongo-cluster-2:192.168.56.241
      - mongo-cluster-3:192.168.56.242
        
        
    shard_2:
    image: mongo-cluster:4.0.9
    container_name: shard_2
    hostname: shard_2
        
    network_mode: host
        
    volumes:
      - /opt/mongodb/shard2:/data/db
      - /opt/shard-no_2.conf:/etc/shard-no_2.conf
        
    command: &gt;
      sh -c "mongod --port 28018 --config /etc/shard-no_2.conf --keyFile /etc/mongo/mongodb.key"
        
    logging:
      driver: json-file
      options:
        max-size: "100m"
        max-file: "5"
    sysctls:
      - net.core.somaxconn=1024
    ulimits:
      nproc: 65535
      nofile:
        soft: 20000
        hard: 40000
        
    ports:
      - 28018:28018
        
    extra_hosts:
      - mongo-cluster-1:192.168.56.228
      - mongo-cluster-2:192.168.56.241
      - mongo-cluster-3:192.168.56.242
        
        
        
    shard_3:
    image: mongo-cluster:4.0.9
    container_name: shard_3
    hostname: shard_3
        
    network_mode: host
        
    volumes:
      - /opt/mongodb/shard3:/data/db
      - /opt/shard-no_3.conf:/etc/shard-no_3.conf
        
    command: &gt;
      sh -c "mongod --port 29018 --config /etc/shard-no_3.conf --keyFile /etc/mongo/mongodb.key"
        
    logging:
      driver: json-file
      options:
        max-size: "100m"
        max-file: "5"
    sysctls:
      - net.core.somaxconn=1024
    ulimits:
      nproc: 65535
      nofile:
        soft: 20000
        hard: 40000
        
    ports:
      - 29018:29018
        
    extra_hosts:
      - mongo-cluster-1:192.168.56.228
      - mongo-cluster-2:192.168.56.241
      - mongo-cluster-3:192.168.56.242
        
        
    router:
    image: mongo-cluster:4.0.9
    container_name: router
    hostname: router
    network_mode: host
        
    volumes:
      - /opt/mongodb/router:/data/db
      - /opt/mongodb/router/config:/data/configdb
      - /opt/router-no.conf:/etc/router-no.conf
      - /opt/filebeat.yml:/filebeat/filebeat.yml
        
           
    command: &gt;
      sh -c "filebeat -c /filebeat/filebeat.yml -e -M "mongodb.log.var.paths=[/var/log/mongodb/*.log*]"  &amp;
              mongos --port 27017 --bind_ip_all --config /etc/router-no.conf -v --logpath /var/log/mongodb/router.log --keyFile /etc/mongo/mongodb.key"
        
    logging:
      driver: json-file
      options:
        max-size: "100m"
        max-file: "5"
    sysctls:
      - net.core.somaxconn=1024
    ulimits:
      nproc: 65535
      nofile:
        soft: 20000
        hard: 40000
        
    extra_hosts:
      - mongo-cluster-1:192.168.56.228
      - mongo-cluster-2:192.168.56.241
      - mongo-cluster-3:192.168.56.242
        
        ports:
          - 27017:27017
