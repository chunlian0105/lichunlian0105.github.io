#!/bin/bash

# 假设 samples.list 文件包含了所有样本的ID，例如：ERR1449743, ERR1449744...

# 循环处理 samples.list 中的每个样本
for sample in $(cat samples.list); do
    echo "Processing sample: $sample"

    # 创建输出目录（如果不存在）
    mkdir -p $PWD/bowtie2_results

    # 生成索引
    bowtie2-build $PWD/prodigal/$sample/${sample}_metagenomic_nucleotides.fna \
                  $PWD/prodigal/$sample/index

    # 使用 bowtie2 比对数据
    bowtie2 -x $PWD/prodigal/$sample/index \
            -1 $PWD/filter/non-humanDNA/${sample}_1_trimmed.fastq.gz \
            -2 $PWD/filter/non-humanDNA/${sample}_2_trimmed.fastq.gz \
            -S $PWD/bowtie2_results/${sample}.sam

    # 使用 samtools 将 .sam 文件转换为 .bam 文件
    samtools view -bS $PWD/bowtie2_results/${sample}.sam \
                  > $PWD/bowtie2_results/${sample}.bam

    # 排序 .bam 文件
    samtools sort $PWD/bowtie2_results/${sample}.bam \
                  -o $PWD/bowtie2_results/${sample}_sorted.bam

    # 索引排序后的 .bam 文件
    samtools index $PWD/bowtie2_results/${sample}_sorted.bam

    # 获取 idxstats 输出（每个基因的比对读数）
    samtools idxstats $PWD/bowtie2_results/${sample}_sorted.bam \
                      > $PWD/bowtie2_results/${sample}_idxstats.txt

    echo "Finished processing sample: $sample"
    wait 
done
