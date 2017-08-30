#!/bin/sh

# apollo config db info
apollo_config_db_url=jdbc:mysql://db:3306/ApolloConfigDB?characterEncoding=utf8
apollo_config_db_username=root
apollo_config_db_password=root

# apollo portal db info
apollo_portal_db_url=jdbc:mysql://db:3306/ApolloPortalDB?characterEncoding=utf8
apollo_portal_db_username=root
apollo_portal_db_password=root

# meta server url
dev_meta=http://apollo-configservice:8080
fat_meta=http://apollo-configservice:8080
uat_meta=http://apollo-configservice:8080
pro_meta=http://apollo-configservice:8080

META_SERVERS_OPTS="-Ddev_meta=$dev_meta -Dfat_meta=$fat_meta -Duat_meta=$uat_meta -Dpro_meta=$pro_meta"

# =============== Please do not modify the following content =============== #

# package config-service and admin-service
echo "==== starting to build config-service and admin-service ===="

mvn clean package -DskipTests -pl apollo-configservice,apollo-adminservice -am -Dapollo_profile=github -Dspring_datasource_url=$apollo_config_db_url -Dspring_datasource_username=$apollo_config_db_username -Dspring_datasource_password=$apollo_config_db_password

echo "==== building config-service and admin-service finished ===="

echo "==== starting to build portal ===="

mvn clean package -DskipTests -pl apollo-portal -am -Dapollo_profile=github -Dspring_datasource_url=$apollo_portal_db_url -Dspring_datasource_username=$apollo_portal_db_username -Dspring_datasource_password=$apollo_portal_db_password $META_SERVERS_OPTS

echo "==== building portal finished ===="

echo "==== starting to build client ===="

mvn clean install -DskipTests -pl apollo-client -am $META_SERVERS_OPTS

echo "==== building client finished ===="

echo "==== starting to build apollo-spring-boot-sample ===="

mvn clean package -DskipTests -pl apollo-spring-boot-sample

echo "==== building apollo-spring-boot-sample finished ===="

echo "==== starting to build docker images ===="

cd apollo-configservice

mvn docker:build

cd ../apollo-adminservice

mvn docker:build

cd ../apollo-portal

mvn docker:build

cd ../apollo-spring-boot-sample

mvn docker:build

echo "==== building docker images finished ===="

cd ..

echo "==== starting to run docker images ===="

docker-compose up

