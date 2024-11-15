# **miniconda3介绍、安装、使用教程**

简单来说conda有什么用？
方便的创建多个python虚拟环境，方便多个python项目同时开发的时候，每个项目都有自己独立的python开发环境。

相当于在一个园区，建立很多仓库，每个仓库都相互独立，可以安装不同的python环境，防止python环境不对应导致代码运行出错。

对于pip、conda、anaconda和miniconda的区别。
conda是一个包和环境管理工具，它不仅能管理包，还能隔离和管理不同python版本的环境。类似管理nodejs环境的nvm工具。

anaconda和miniconda都是conda的一种发行版。只是包含的包不同。

anaconda包含了conda、python等180多个科学包及其依赖项，体格比较大。但很多东西你未必用到，所以才有mini版。

miniconda是最小的conda安装环境，只有conda+python+pip+zlib和一些其他常用的包，体格非常迷你。

pip也叫包管理器，和conda的区别是，pip只管理python的包，而conda可以安装所有语言的包。而且conda可以管理python环境，pip不行。

## 1.conda 安装

conda 安装

```
mkdir -p ~/miniconda3
wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/miniconda3/miniconda.sh
bash ~/miniconda3/miniconda.sh -b -u -p ~/miniconda3
rm ~/miniconda3/miniconda.sh
source miniconda3/bin/activate
conda init --all
rm ./condarc
```

目前conda 已经安装在公共目录中

### **使用 `which` 命令**

在终端输入以下命令查看 `conda` 的可执行文件路径：

```
which conda
```

如果没有找到conda的路径

请打开~/.bashrc 文件

```
__conda_setup="$('/opt/miniconda/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/opt/miniconda/etc/profile.d/conda.sh" ]; then
        . "/opt/miniconda/etc/profile.d/conda.sh"
    else
        export PATH="/opt/miniconda/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<
#将conda 的安装路径进行如上修改
```

```
source  ~/.bashrc
```

加载即可

## 2.conda 使用

### 2.1配置国内镜像源[](https://lfpara.com/docs/hpc/tools/miniconda3/miniconda3.html#id9)

在下载某些包时使用miniconda3自带的源时可能出现下载速度较慢，使用国内的镜像源下载速度较快（此处添加的为清华源）。

```
conda config --add channels https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/free/
conda config --add channels https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/main/
conda config --set show_channel_urls yes
```

### 2.2管理虚拟环境

```shell
# 查看环境信息，当前环境会通过一个星号 (*) 标识
$ conda env list
# conda environments:
#
root                  *  /home/zhangsan/miniconda
```

如上，默认的环境名称为root。

创建虚拟环境：

```shell
# 新建一个基于Python 3.6的环境，名称为myenv
$ conda create -n myenv python=3.6.2
$ conda env list
# conda environments:
#
myenv                    /home/zhangsan/miniconda/envs/myenv
root                  *  /home/zhangsan/miniconda
```

创建完新环境之后查看环境列表，默认还是`root`环境。

选择虚拟环境：

```shell
$ source activate myenv
discarding /home/zhangsan/miniconda/bin from PATH
prepending /home/zhangsan/miniconda/envs/myenv/bin to PATH

# 在指定环境中查看Python版本时正是创建环境时指定的版本
$ python -V
Python 3.6.2 :: Continuum Analytics, Inc.
```

退出虚拟环境：

```shell
# 退出当前所处的虚拟环境
$ source deactivate
discarding /home/zhangsan/miniconda/envs/myenv/bin from PATH

# 再次查看Python版本时就是conda默认root环境的Python版本
$ python -V
Python 2.7.9 :: Continuum Analytics, Inc.
```

删除虚拟环境：

```shell
# 删除指定名称的虚拟环境
$ conda env remove -n myenv
$ conda env list
# conda environments:
#
root                  *  /home/zhangsan/miniconda
```

### 2.3管理软件包

```shell
# 查看在当前所在虚拟环境中已经安装的包
$ conda list

# 在当前所在的虚拟环境中安装软件包
$ conda install <package_name>

# 在指定虚拟环境中安装包
$ conda install --name <env_name> <package_name>

# 卸载当前所在虚拟环境下的指定包
$ conda remove <package_name>

# 卸载指定虚拟环境下的指定包
$ conda remove --name <env_name> <package_name>

# 升级当前所在虚拟环境下的指定包
$ conda update <package_name>
```