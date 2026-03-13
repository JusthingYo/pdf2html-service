
# pdf2htmlex image
FROM pdf2htmlex/pdf2htmlex:0.18.8.rc1-master-20200630-Ubuntu-bionic-x86_64

ENV TZ='CST-8'
ENV LANG C.UTF-8

# apt
RUN sed -i s@/archive.ubuntu.com/@/mirrors.aliyun.com/@g /etc/apt/sources.list
RUN apt-get clean && apt-get update
RUN apt-get install -y vim curl htop net-tools

# vim
RUN echo "set fileencodings=utf-8,ucs-bom,gb18030,gbk,gb2312,cp936" >> /etc/vim/vimrc
RUN echo "set termencoding=utf-8" >> /etc/vim/vimrc
RUN echo "set encoding=utf-8" >> /etc/vim/vimrc

# jdk 建议下载本地打包，跳过安全认证过期的地址 https://repo.huaweicloud.com/java/jdk/8u202-b08/jdk-8u202-linux-x64.tar.gz 
ADD jdk-8u202-linux-x64.tar.gz /tmp/
RUN tar -zxf /tmp/jdk-*.tar.gz -C /opt/ && rm -f /tmp/jdk-*.tar.gz && mv /opt/jdk* /opt/jdk

ENV JAVA_HOME /opt/jdk
ENV PATH ${JAVA_HOME}/bin:$PATH

# pdf2html-service  ！！！！需调整gz包名称，部分情况下*错误的
COPY target/pdf2html-service-*.tar.gz /tmp/
RUN tar -zxf /tmp/pdf2html-service-1.0.1-20260312.tar.gz -C /opt/ && rm -f /tmp/pdf2html-service-1.0.1-20260312.tar.gz && apt-get update && apt-get install -y dos2unix && dos2unix /opt/pdf2html-service/start.sh


ENTRYPOINT [""]
WORKDIR /opt/pdf2html-service
CMD ["bash","-c","./start.sh && tail -f /dev/null"]
