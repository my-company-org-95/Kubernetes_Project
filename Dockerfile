FROM rockylinux:8

# Install Apache + tools
RUN yum install -y httpd zip unzip wget && \
    yum clean all

WORKDIR /var/www/html/

# Download Nexus Flow template and extract
RUN wget -O template.zip https://templatemo.com/download/templatemo_594_nexus_flow && \
    unzip template.zip && \
    cp -rvf templatemo_594_nexus_flow/* . && \
    rm -rf templatemo_594_nexus_flow template.zip

EXPOSE 80 22
CMD ["/usr/sbin/httpd", "-D", "FOREGROUND"]
