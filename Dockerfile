FROM centos:centos7.3.1611
MAINTAINER edward
LABEL name="freshlime-pipelinebase"

RUN yum install -y wget zip unzip supervisor dnsutils which net-tools telnet ntp ntpdate python-setuptools nc && \
    easy_install supervisor && \
    mkdir -p /etc/supervisor/conf.d && \
    echo_supervisord_conf > /etc/supervisor/supervisord.conf && \
    echo "[include]" >> /etc/supervisor/supervisord.conf && \
    echo "files=conf.d/*.conf" >> /etc/supervisor/supervisord.conf && \
    systemctl enable ntpd

ENV JDK_VERSION="202"
ENV JDK_DOWN_URL=https://corretto.aws/downloads/resources/11.0.9.12.1/java-11-amazon-corretto-devel-11.0.9.12-1.x86_64.rpm

RUN cd /tmp && \
    wget -nv --no-cookies --no-check-certificate $JDK_DOWN_URL && \
    yum install -y ./ java-11-amazon-corretto-devel-11.0.9.12-1.x86_64.rpm && \
    yum clean all

# DOCKER
RUN wget -P /tmp/ https://download.docker.com/linux/centos/7/x86_64/stable/Packages/docker-ce-cli-19.03.14-3.el7.x86_64.rpm  && \
    yum install -y /tmp/docker-ce-cli-19.03.14-3.el7.x86_64.rpm 

# aws cli
ENV AWSCLIURL=https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip
RUN cd /tmp && \
    wget -nv --no-cookies --no-check-certificate $AWSCLIURL && \
    unzip awscli-exe-linux-x86_64.zip && \
    ./aws/install && \
    yum clean all


WORKDIR /code
# npm
#RUN yum install -y http://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
COPY installnode.sh /installnode.sh
RUN chmod +x /installnode.sh
RUN /installnode.sh
RUN yum clean all && yum makecache fast && \
 yum install -y gcc-c++ make && \
 yum install -y nodejs

# CMD sleep infinity
VOLUME [ "/code" ]

CMD ["java","-version"]