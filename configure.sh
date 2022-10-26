#!/bin/bash
#已经实现自动安装golang，本地配置node文件夹，启动链，拉取tps测试工具，开始tps测试
cd /
sudo chown ubuntu data
cd /data
wget https://dl.google.com/go/go1.19.2.linux-amd64.tar.gz
tar -zxvf go1.19.2.linux-amd64.tar.gz
export GOROOT=/data/go
export PATH=$PATH:$GOROOT/bin 
mkdir gohome
cd /data
mkdir zion
cd /data/gohome
mkdir pkg
mkdir src
mkdir bin
cd src
git clone https://github.com/dylenfu/Zion.git
cd Zion
git checkout --track origin/consensus
go mod tidy
cd /data
git clone https://github.com/zsyznb/deploychain.git
cd /data/deploychain
git checkout --track origin/deploy-single-node
go build
./createChain
for i in $(ls /data/zion/)
do 
cd /data/zion/$i
./build.sh
./init.sh
./start.sh
done
cd /data/
cp -r /data/gohome/src/Zion ./
git clone https://github.com/zsyznb/zion-meter.git
cd /data/zion-meter
git checkout --track origin/tpsTest2.0
cd /data/zion-meter/build
mv config-sidechain.json config.json
cd /data/zion-meter
make compile
mkdir log
./start_tps.sh 60 20 1h
