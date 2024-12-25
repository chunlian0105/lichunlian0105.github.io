#!/bin/bash
# �������� *_1.fastq.gz �ļ�
for sample in $PWD/filter/non-humanDNA/*_1_trimmed.fastq.gz
do
    # ��ȡ�ļ���ǰ׺ (ȥ�� _1.fastq.gz)
    prefix=$(basename $sample "_1_trimmed.fastq.gz")
    # ���Ŀ¼��ȷ��Ŀ¼���Ʋ���ͻ���������ļ�����ͬ��
    output_dir="$PWD/SPAdes/outdir_$prefix"
    # �������Ŀ¼
    mkdir -p $output_dir
    # ����MetaSPAdes
    metaspades.py -o $output_dir \
                  -1 $PWD/filter/non-humanDNA/${prefix}_1_trimmed.fastq.gz \
                  -2 $PWD/filter/non-humanDNA/${prefix}_2_trimmed.fastq.gz \
                  -t 48 -m 500 -k 21,33,55,77,99,127
done
