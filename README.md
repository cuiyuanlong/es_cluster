# es_cluster
自动化部署、扩容、升级ES等分布式集群

> 本文主要向大家介绍一种在生产环境如何自动化部署ES等分布式集群的方法，通过该方法可以很方便地对多种分布式集群进行部署、扩容、升级、日常维护等运维操作。

## 部署准备
- 安装好系统及基本软件，如：supervisor, jdk, pip, python2.7及相关依赖包(curator)
- 设置好核心参数（根据各产品的官方要求设置）
- 各节点部署用户间建立好节点间互信
- 准备好配置文件并放置在${HOME}/conf下，分模块目录存放
- 将下载好的软件包放置在${HOME}/install下
- 由于nginx, elastalert和elastalert-server为定制开发版，因此不能直接自动安装，需手工安装
- 对于SDC,kafka,zookeeper,redis集群通常会单独部署，这里仅仅作简单演示，表明同样可以采用本方法进行自动部署
- ${HOME}/data/sdc下为演示用到的pipeline

## 目录结构
用户目录下存放各子目录的功能和内容

- **bin**

  存放在整个集群环境运行所需的各种命令脚本

- **conf**

  各服务、组件的配置文件；按服务、组件分子目录存放，事先准备好；该目录下的*.list文件定义了哪些节点启动哪些服务以及运行角色

- **data**

  各服务、组件的中间运行态数据；按服务、组件分子目录存放

- **log**

  各服务、组件的运行日志信息；按服务、组件分子目录存放

- **install**

  各服务、组件的标准安装包，从各产品的官方网站下载

- **software**

  各服务、组件的运行程序，由各安装包安装后产生；按服务、组件分子目录存放

## 重要命令
## 操作流程
## 架构优势
- 实现去中心化结构，无单点
- 节点间数据完全同步，具体运行态依赖于环境配置
- 可以由任何节点的数据自动生成其他节点
- 任何修改在小范围内通过验证后才同步到整个集群
- 结构简单易维护
- 该架构适用于多种软件、服务，易于快速扩展


