#!/bin/bash
# �� samples.list �ļ���ȡSRR��Ų����д���
cat $PWD/samples.list | parallel -j 8 '
    SRR={};
    echo "Processing ${SRR}..."
    # ������������ļ���·��
    CONTIGS="$PWD/SPAdes/outdir_${SRR}/contigs.fasta"
    FASTQ1="/data/lcl/cohort/Ten_pairs_done/data/${SRR}_1.fastq.gz"
    FASTQ2="/data/lcl/cohort/Ten_pairs_done/data/${SRR}_2.fastq.gz"
    BAM_DIR="$PWD/bamfiles/bamfiles_${SRR}/"
    OUT_DIR="$PWD/vamb/${SRR}/"
    # ����BAM�ļ��У���������ڣ�
    mkdir -p ${BAM_DIR}
    # BWA���������бȶԣ�����BAM�ļ�����������
    bwa index ${CONTIGS} && \
    bwa mem -t 8 ${CONTIGS} ${FASTQ1} ${FASTQ2} | samtools sort -o ${BAM_DIR}/${SRR}.sorted.bam && \
    samtools index ${BAM_DIR}/${SRR}.sorted.bam
    # ����VAMB����binning
    vamb bin default --outdir ${OUT_DIR} --fasta ${CONTIGS} --bamdir ${BAM_DIR} --minfasta 200000
    echo "${SRR} processing completed."
'  # ���պ����ŷ��� parallel ����Ľ�β
