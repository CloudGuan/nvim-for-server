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

#初始化环境检查,用于状态检查

function pre_install_env(){
    #依赖库 
    yum install -y bzip2
    yum install -y fuse fuse-devel
    yum install -y zip 
    #nodejs 支持
    if ! [ -x "$(command -v node)" ];then
        curl --fail -LSs https://install-node.now.sh/latest | sh 
    fi 
}

function pre_check_env(){
    # check for python install 
    if ! [ -x "$(command -v python3)" ];then
        echo "开始安装python3"
        curl -O https://raw.githubusercontent.com/CloudGuan/bashboot/master/python_boot.sh
        if [ $? -gt 0  ];then
            echo "python 安装脚本下载失败 请手动执行"
            exit 1
        fi 
        sh python_boot.sh
        if [ $? -gt 0 ];then
            echo "python 安装失败 请手动执行 https://raw.githubusercontent.com/CloudGuan/bashboot/master/python_boot.sh 后再尝试"
            exit 1
        fi
        pip3 install --upgrade pip
        pip3 install pynvim
        pip3 install pygments
        pip3 install neovim
        rm python_boot.sh
    fi 

    # check for glibc 2.18
    if [ ! -f /usr/lib64/libc-2.18.so ];then
        wget http://ftp.gnu.org/gnu/glibc/glibc-2.18.tar.gz
        if [ $? -gt 0 ];then
            echo "下载glibc 失败请手动准备好相关依赖在进行安装"
            exit 1
        fi 

        tar -xvf glibc-2.18.tar.gz 
        cd glibc-2.18
        mkdir build && cd build && ../configure --prefix=/usr && make -j4 && make install
        cd ../../
        echo "安装glibc完毕 开始执行清理程序"
        rm -rf glibc-2.18
        rm -f glibc-2.18.tar.gz 
    fi 

    # checkfor clangd 
    if ! [ -x "$(command -v clangd)" ];then 
        if [ ! -f clangd-linux-11.0.0.zip ];then
            wget https://github.com/clangd/clangd/releases/download/11.0.0/clangd-linux-11.0.0.zip
            if [ $? -gt 0 ];then
                echo "下载clangd 失败请手动准备好 https://github.com/clangd/clangd/releases/download/11.0.0/clangd-linux-11.0.0.zip 相关依赖在进行安装"
                exit 1
            fi 
        fi

        unzip clangd-linux-11.0.0.zip
        mv clangd_11.0.0/ /usr/local/clang
        ln -s /usr/local/clang/bin/clangd /usr/bin/clangd 
        echo "安装clangd完毕 开始执行清理程序"
        rm -f clangd-linux-11.0.0.zip
    fi 

    # checkfor nvim
    if [ ! -f /usr/bin/nvim.appimage ];then
        if [ ! -f nvim.appimage ];then
            curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim.appimage
            if [ $? -gt 0 ];then
                echo "下载neovim失败 https://github.com/neovim/neovim/releases/latest/download/nvim.appimage 请手动下载"
                exit 1
            fi 
        fi 

        chmod u+x nvim.appimage

        if [ $? -gt 0 ];then
            echo "下载neovim 失败请手动准备好 https://github.com/neovim/neovim/releases/latest/download/nvim.appimage 相关依赖在进行安装"
            exit 1
        fi 

        yum remove vim
        mv nvim.appimage /usr/bin/nvim.appimage 
        if [ -f /bin/vim ];
        then
            rm /bin/vim
        fi 
        ln -s /usr/bin/nvim.appimage /bin/vim
    fi 

    # install bash server
    npm i -g bash-language-server
}

pre_install_env
if [ $? -gt 0 ];then
    echo "下载依赖，安装依赖失败，请手动执行"
    exit 1
fi 
pre_check_env
