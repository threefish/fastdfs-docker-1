#fastdfs_in_docker
<p>
当前仅支持1个tracker，一组storage的部署方式。每个storage上都装有nginx，提供http服务的端口为8080。可按如下的方式对文件进行http访问：http://192.168.83.176:8080/group1/M00/00/00/wKhTsFkRlTOAQqm6ABvFny1kWJ4443.mp4
</p>
<p>
假设存在安装场景：1个tracker；1组storage，包括两个storage；
tracker和其中一个storage安装在192.168.83.176上，另一个storage安装在192.168.83.177。
部署拓扑如下：
</p>
<pre><code>
            tracker(83.176)
              /      \
             /        \
------------/          \-------------
| group1   /            \           |
|         /              \          |
|        /                \         |
|     storage1         storage2     |
|     (83.176)         (83.177)     |
|                                   |
------------------------------------
</code></pre>
<p>
已上述安装场景为例，工程使用方法如下：
<ol>
<li>1、在宿主机上安装docker</li>
<li>2、下载工程到宿主机上，假定存储到宿主机的目录A</li>
<li>3、进入目录A，执行命令
   docker build -t zjg23/fastdfs:1.0 .
   构建镜像</li>
<li>4、在192.168.83.176上运行tracker
   docker run -d --name fdfs_tracker --net=host -e TRACKER_BASE_PATH=/export/fastdfs/tracker zjg23/fastdfs:1.0 sh /usr/local/src/tracker.sh
   在192.168.83.176上运行storage
   docker run -d --name fdfs_storage --net=host -e STORAGE_BASE_PATH=/export/fastdfs/storage  -e STORAGE_PATH0=/export/fastdfs/storage -e TRACKER_SERVER=192.168.83.176:22122 -e GROUP_COUNT=1 -e HTTP_SERVER_PORT=8080 zjg23/fastdfs:1.0 sh /usr/local/src/storage.sh
   在192.168.83.177上运行storage
   docker run -d --name fdfs_storage_2 --net=host -e STORAGE_BASE_PATH=/export/fastdfs/storage  -e STORAGE_PATH0=/export/fastdfs/storage -e TRACKER_SERVER=192.168.83.176:22122 -e GROUP_COUNT=1 -e HTTP_SERVER_PORT=8080 zjg23/fastdfs:1.0 sh /usr/local/src/storage.sh</li>
</ol>
至此，fastdfs安装完成。
</p>