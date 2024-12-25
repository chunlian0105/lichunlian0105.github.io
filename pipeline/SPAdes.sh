#!/bin/bash
# 遍历所有 *_1.fastq.gz 文件
for sample in $PWD/filter/non-humanDNA/*_1_trimmed.fastq.gz
do
    # 获取文件名前缀 (去掉 _1.fastq.gz)
    prefix=$(basename $sample "_1_trimmed.fastq.gz")
    # 输出目录（确保目录名称不冲突，避免与文件名相同）
    output_dir="$PWD/SPAdes/outdir_$prefix"
    # 创建输出目录
    mkdir -p $output_dir
    # 运行MetaSPAdes
    metaspades.py -o $output_dir \
                  -1 $PWD/filter/non-humanDNA/${prefix}_1_trimmed.fastq.gz \
                  -2 $PWD/filter/non-humanDNA/${prefix}_2_trimmed.fastq.gz \
                  -t 48 -m 500 -k 21,33,55,77,99,127
done
