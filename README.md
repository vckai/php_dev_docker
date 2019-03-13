## PHP docker开发环境

采用了多台docker，独立的Dockefile配置

* openresty/nginx
* php5.5，php7
* mysql5.7
* redis3.0.7
* rabbitMQ
* mongoDB

使用docker-compose 管理

> 目前只在OSX10.11+ 和 CentOS 5/6下部署过。

### 安装docker
下载镜像镜像源地址：https://www.docker.com

国内地址：http://get.daocloud.io/ （可直接下载）

选择：get docker for mac 或者 get docker for windows


`镜像默认是国外的地址，但是可以使用http://docs.daocloud.io/faq/what-is-daocloud-accelerator 进行加速处理`

### 安装docker-compose
	curl -L "https://github.com/docker/compose/releases/download/1.8.1/docker-compose-$(uname -s)-$(uname -m)" > /usr/local/bin/docker-compose
	chmod +x /usr/local/bin/docker-compose
	
### 下载安装项目
PHP 项目地址为:~/data/www

日记地址为:~/data/logs

mysql db路径为:~/data/data/mysql


1. 修改`~/.bashrc`配置文件，新增以下脚本，`~/.docker_alias`文件会在setp2中生成，并刷新配置：

		source ~/.docker_alias

2. 安装项目

        cd ~/data
        git clone git@github.com:vckai/php_dev_docker.git
		cd php_dev_docker
		./install.sh
	
3. 运行docker

		docker-compose up -d

4. 修改你的hosts指向本机，如：

		127.0.0.1 dev1.vckai.com

5. 命令简要说明，需要在php_dev_docker根目录运行

    ```
	# 启动
	docker-compose up -d
	
	# 修改配置后重启
	docker-compose build
	docker-compose up -d

	# 关闭运行
	docker-compose kill

	# 修改nginx hosts配置
	vim vhosts/default.conf
	docker-compose restart nginx
    ```

enjoy~
	
### 关于ssh
docker机器的ssh，推荐使用nsenter。

	docker run --rm -v /usr/local/bin:/target jpetazzo/nsenter
	
修改`~/.bashrc`新增

	docker-enter() {
	    CONTAINER=$1
	    shift 1
	    docker exec -it "$CONTAINER" su - root -c 'script -q /dev/null'
	}
	
使用，其中commit可以通过`docker ps`获取

	docker-enter <commit id>

### 关于php7的xhprof
目前尚未有该版本比较好的xhprof扩展，目前使用的有不少坑，但是开发环境勉强可以使用

保存的话只能使用这种方式，否则会出现core dump的错误

	xhprof_enable();

	register_shutdown_function(function() {
		file_put_contents(ini_get('xhprof.output_dir') . '/' . uniqid() . '.xhprof.xhprof', serialize(xhprof_disable()));
	});
