#!/bin/sh

# apollo config db info
apollo_config_db_url=jdbc:mysql://10.126.3.127:3306/apolloconfigdb?characterEncoding=utf8
apollo_config_db_username=root
apollo_config_db_password=mysql

# apollo portal db info
apollo_portal_db_url=jdbc:mysql://10.126.3.127:3306/apolloportaldb?characterEncoding=utf8
apollo_portal_db_username=root
apollo_portal_db_password=mysql

# meta server url, different environments should have different meta server addresses
dev_meta=http://10.126.3.127:8555
fat_meta=http://10.126.3.127:8555
uat_meta=http://10.126.3.127:8555
pro_meta=http://10.126.3.127:8555

META_SERVERS_OPTS="-Ddev_meta=$dev_meta -Dfat_meta=$fat_meta -Duat_meta=$uat_meta -Dpro_meta=$pro_meta"

# =============== Please do not modify the following content =============== #
cd ..

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

