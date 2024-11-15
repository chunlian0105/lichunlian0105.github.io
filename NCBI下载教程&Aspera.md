# **NCBI下载教程&Aspera**

## **1.Aspera**

NCBI数据下载工具aspera，该软件是由IBM开发，能够最大程度利用宽带速度，下载NR和NT数据库的时候速度能飚到400Mb/s，下载基因组的时候能飚到20Mb/s。

## **2.conda 安装Aspera**

```
#下载Aspera
conda create -n download 
conda activate download 
conda install -y -c hcc aspera-cli
conda install -y -c bioconda sra-tools
#确认安装
which ascp 
conda deactivate
#找到该配置文件
ls -lh ~/miniconda3/etc/asperaweb_id_dsa.openssh
#将其复制到该路径下
/home/lcl/miniconda3/etc/asperaweb_id_dsa.openssh
```

## **3.下载数据网站**

SRA数据下载（通过EBI-ENA数据库，使用ASpera）

### 3.1SRA数据

一种储存高通量测序数据格式。高通量测序：即NGS和TGS，通常数据产出在几十到几百MB不等

各种检索号
PRJNA：study_acession
SRP：secondary_study_accession（DRP,ERP）
SAMN：sample_accession
SRS：secondary_sample_accession（DRS,ERS）
SRX：experiment_accession
SRR：run_accession（DRR,ERR）
SRA：submission_accession

### 3.2EBI-ENA数据库——确定需要下载数据集的下载地址

因为EBI-ENA数据库可以直接提供fastq格式测序文件，省去了sra文件转fastq文件的时间
[EBI-ENA数据库](https://www.ebi.ac.uk/ena/browser/)，检索SRX5327410，点击View

获得结果，点击Show Column Selection，选择run_accession，fastq_aspera，sra_aspera这三项。点击Hide Column Selection
点击Download report后的TSV，得到一个文件filereport_read_run_SRX5327410_tsv.txt

![image-20241115194554361](https://github.com/chunlian0105/lichunlian0105.github.io/blob/main/image-20241115194554361.png)

![image-20241115194613232](https://github.com/chunlian0105/lichunlian0105.github.io/blob/main/image-20241115194613232.png)

![image-20241115194633201](https://github.com/chunlian0105/lichunlian0105.github.io/blob/main/image-20241115194633201.png)

## **4.下载数据**

### **4.1Aspera -cli 简单使用**

```
conda activate download
ascp -QT -l 300m -P33001 -i /home/lcl/miniconda3/etc/asperaweb_id_dsa.openssh era-fasp@fasp.sra.ebi.ac.uk:/vol1/fastq/SRR103/003/SRR1039773/SRR1039773_1.fastq.gz ./
```

```
nohup cat filereport_read_run_PRJNA473126_tsv.txt | while read id; do ascp                     -QT -l 300m -P33001 -i /home/lcl/miniconda3/etc/asperaweb_id_dsa.openssh era-fasp@$id ./；done &
#批量下载数据
#过滤数据
awk -F '\t' '{ split($2, arr, ";"); for (i in arr) { if (arr[i] ~ /\.fastq\.gz$/) { print arr[i] } } }' filereport_read_run_PRJNA473126_tsv.txt > fastq_files.txt
#下载
 nohup cat fastq_files.txt | while read id; do ascp -QT -l 300m -P33001 -i ~/miniconda3/etc/asperaweb_id_dsa.openssh -k 1 era-fasp@$id ./data;  done &

```

