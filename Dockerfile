
#RUN configure.sh


########################################
# Build Image
########################################
# FROM docker.io/maven:3.6-jdk-8-slim as build
FROM docker.io/maven:3.8.7-eclipse-temurin-8 as build

WORKDIR /app
COPY . .

#RUN mvn dependency:resolve
#RUN mvn package

# Disable maven processes to avoid error
# RUN mvn clean
# RUN mvn install



########################################
# Production Image
########################################
# FROM open-liberty:microProfile2-java8-ibm
# FROM open-liberty:full
FROM icr.io/appcafe/open-liberty:full-java8-openj9-ubi

# Add build files
COPY --from=build --chown=1001:0 /app/daytrader-ee7/target/daytrader-ee7.ear /config/apps/daytrader-ee7.ear

COPY --from=build --chown=1001:0 /app/daytrader-ee7/src/main/liberty/config/ /config/


# Derby
# COPY --chown=1001:0 daytrader-ee7/target/liberty/wlp/usr/shared/resources/DerbyLibs/derby-10.14.2.0.jar /opt/ol/wlp/usr/shared/resources/DerbyLibs/derby-10.14.2.0.jar
# COPY --chown=1001:0 daytrader-ee7/target/liberty/wlp/usr/shared/resources/data /opt/ol/wlp/usr/shared/resources/data

# DB2
COPY --from=build --chown=1001:0 /app/daytrader-ee7/src/main/liberty/resources/db2jcc4.jar /liberty/usr/shared/resources/db2jars/
