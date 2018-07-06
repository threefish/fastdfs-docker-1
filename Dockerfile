# Pull base image
FROM hub.c.163.com/library/centos:6.8

MAINTAINER zjg23 "zhaojianguo1234@aliyun.com"


#生成缓存
RUN yum update -y && yum makecache
#########################################中文乱码处理################################################
#时区设置
RUN rm -rf /etc/localtime && ln -s /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
#安装中文支持
RUN yum -y install kde-l10n-Chinese && yum -y reinstall glibc-common
#配置显示中文
RUN localedef -c -f UTF-8 -i zh_CN zh_CN.utf8
#设置环境变量
ENV LC_ALL zh_CN.utf8
RUN echo "export LC_ALL=zh_CN.utf8" >> /etc/profile
#清理，也可以先卸载一些不需要的软件 这样build出来的镜像会更小
RUN yum clean all


#install dependency
RUN yum install -y zlib zlib-devel pcre pcre-devel gcc gcc-c++ openssl openssl-devel libevent libevent-devel perl unzip


#install libfastcommon
ADD libfastcommon-1.0.7.zip /usr/local/src/
RUN cd /usr/local/src \
    && unzip /usr/local/src/libfastcommon-1.0.7.zip \
    && cd libfastcommon-1.0.7 \
    && ./make.sh \
    && ./make.sh install

#install fastdfs
ADD FastDFS_v5.05.tar.gz /usr/local/src/
RUN cd /usr/local/src/FastDFS \
&& ./make.sh \
&& ./make.sh install \
&& cp conf/*.conf /etc/fdfs \
&& cd /etc/fdfs/ \
&& rm -rf *.sample

#install nginx
ADD fastdfs-nginx-module_v1.16.tar.gz /usr/local/src/
ADD nginx-1.7.8.tar.gz /usr/local/src/
RUN cd /usr/local/src/ \
    && cd nginx-1.7.8 \
    && ./configure --prefix=/usr/local/nginx --add-module=/usr/local/src/fastdfs-nginx-module/src \
    && make \
    && make install \
    && cp /usr/local/src/fastdfs-nginx-module/src/mod_fastdfs.conf /etc/fdfs/
ADD nginx.conf /usr/local/nginx/conf/

#create directory
RUN mkdir -p /export/fastdfs/{storage,tracker}
ADD tracker.sh /usr/local/src/
ADD storage.sh /usr/local/src/
