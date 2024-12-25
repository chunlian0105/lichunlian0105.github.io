#!/bin/bash

# 设置输入目录、输出目录和样本列表文件
input_dir="$PWD/SPAdes"
output_dir="$PWD/prodigal"
samples_list="samples.list"

# 创建输出目录（如果不存在）
mkdir -p "$output_dir"

# 读取 samples.list 文件中的样本名
while read sample; do
    # 构建contigs.fasta文件的路径
    contig_file="$input_dir/outdir_$sample/contigs.fasta"

    # 检查文件是否存在
    if [ -f "$contig_file" ]; then
        # 创建一个与样本名对应的子目录
        sample_output_dir="$output_dir/$sample"
        mkdir -p "$sample_output_dir"

        # 设置输出文件路径
        gff_file="$sample_output_dir/${sample}_metagenomic.gff"
        faa_file="$sample_output_dir/${sample}_metagenomic_proteins.faa"
        fna_file="$sample_output_dir/${sample}_metagenomic_nucleotides.fna"

        # 使用 prodigal 进行预测
        prodigal -i "$contig_file" -o "$gff_file" -a "$faa_file" -d "$fna_file" -p meta

        echo "已完成预测：$sample"
    else
        echo "警告：文件不存在 $contig_file"
    fi
done < "$samples_list"
