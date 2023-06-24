# Pull base image 
FROM centos
WORKDIR /opt

RUN sed -i 's/mirrorlist/#mirrorlist/g' /etc/yum.repos.d/CentOS-*
RUN sed -i 's|#baseurl=http://mirror.centos.org|baseurl=http://vault.centos.org|g' /etc/yum.repos.d/CentOS-*

RUN yum install wget -y
RUN yum install fontconfig -y

RUN wget https://github.com/adoptium/temurin8-binaries/releases/download/jdk8u372-b07/OpenJDK8U-jdk_x64_linux_hotspot_8u372b07.tar.gz
RUN wget https://dlcdn.apache.org/tomcat/tomcat-8/v8.5.90/bin/apache-tomcat-8.5.90.tar.gz

RUN tar -zxvf OpenJDK8U-jdk_x64_linux_hotspot_8u372b07.tar.gz
RUN tar -zxvf apache-tomcat-8.5.90.tar.gz

RUN rm -rf OpenJDK8U-jdk_x64_linux_hotspot_8u372b07.tar.gz
RUN rm -rf apache-tomcat-8.5.90.tar.gz

RUN mv apache-tomcat-8.5.90 tomcat
RUN mv jdk8u372-b07 java8


RUN echo export JAVA_HOME=/opt/java8 >> /etc/profile
RUN echo export PATH=$PATH:/opt/java8/bin >> /etc/profile
ENV JAVA_HOME "/opt/java8"
ENV PATH "${JAVA_HOME}/bin:${PATH}"
COPY /webapp/target/webapp.war /opt/tomcat/webapps

EXPOSE 8080

CMD ["/opt/tomcat/bin/catalina.sh", "run"]


