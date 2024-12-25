#!/bin/bash
# 从 samples.list 文件读取SRR编号并并行处理
cat $PWD/samples.list | parallel -j 8 '
    SRR={};
    echo "Processing ${SRR}..."
    # 定义输入输出文件和路径
    CONTIGS="$PWD/SPAdes/outdir_${SRR}/contigs.fasta"
    FASTQ1="/data/lcl/cohort/Ten_pairs_done/data/${SRR}_1.fastq.gz"
    FASTQ2="/data/lcl/cohort/Ten_pairs_done/data/${SRR}_2.fastq.gz"
    BAM_DIR="$PWD/bamfiles/bamfiles_${SRR}/"
    OUT_DIR="$PWD/vamb/${SRR}/"
    # 创建BAM文件夹（如果不存在）
    mkdir -p ${BAM_DIR}
    # BWA索引并进行比对，排序BAM文件，生成索引
    bwa index ${CONTIGS} && \
    bwa mem -t 8 ${CONTIGS} ${FASTQ1} ${FASTQ2} | samtools sort -o ${BAM_DIR}/${SRR}.sorted.bam && \
    samtools index ${BAM_DIR}/${SRR}.sorted.bam
    # 运行VAMB进行binning
    vamb bin default --outdir ${OUT_DIR} --fasta ${CONTIGS} --bamdir ${BAM_DIR} --minfasta 200000
    echo "${SRR} processing completed."
'  # 将闭合引号放在 parallel 命令的结尾
