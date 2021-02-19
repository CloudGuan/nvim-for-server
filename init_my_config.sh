#!/bin/sh

#MIT License
#
#Copyright (c) 2021 cloudguan rcloudguan@163.com
#
#Permission is hereby granted, free of charge, to any person obtaining a copy
#of this software and associated documentation files (the "Software"), to deal
#in the Software without restriction, including without limitation the rights
#to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
#copies of the Software, and to permit persons to whom the Software is
#furnished to do so, subject to the following conditions:
#
#The above copyright notice and this permission notice shall be included in all
#copies or substantial portions of the Software.
#
#THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
#IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
#FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
#AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
#LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
#OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
#SOFTWARE.

yum install -y git 

cd ~/

if [ ! -d ~/.config ];then
    mkdir ~/.config
fi 

if [ -d ~/.config/nvim ];then 
    echo "发现nvim 配置格式 开始备份"
    cd ~/.config
    tar -zcvf nvimconf.tar.gz ./nvim
    if [ $? -gt 0 ];then
        echo "备份nvim配置失败 请手动备份删除 ~/.config/nvim 之后在尝试执行此脚本"
        exit(0)
    fi 
    rm -rf ./nvim
    cd ../
fi 

cd ~/.config

echo "开始clone 远端的vim 配置"
git clone https://github.com/CloudGuan/nvim-for-server.git nvim --depth=1 
echo "clone 完成 enjoy your vim"
