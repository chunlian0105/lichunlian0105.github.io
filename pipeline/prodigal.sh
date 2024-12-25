#!/bin/bash

# ��������Ŀ¼�����Ŀ¼�������б��ļ�
input_dir="$PWD/SPAdes"
output_dir="$PWD/prodigal"
samples_list="samples.list"

# �������Ŀ¼����������ڣ�
mkdir -p "$output_dir"

# ��ȡ samples.list �ļ��е�������
while read sample; do
    # ����contigs.fasta�ļ���·��
    contig_file="$input_dir/outdir_$sample/contigs.fasta"

    # ����ļ��Ƿ����
    if [ -f "$contig_file" ]; then
        # ����һ������������Ӧ����Ŀ¼
        sample_output_dir="$output_dir/$sample"
        mkdir -p "$sample_output_dir"

        # ��������ļ�·��
        gff_file="$sample_output_dir/${sample}_metagenomic.gff"
        faa_file="$sample_output_dir/${sample}_metagenomic_proteins.faa"
        fna_file="$sample_output_dir/${sample}_metagenomic_nucleotides.fna"

        # ʹ�� prodigal ����Ԥ��
        prodigal -i "$contig_file" -o "$gff_file" -a "$faa_file" -d "$fna_file" -p meta

        echo "�����Ԥ�⣺$sample"
    else
        echo "���棺�ļ������� $contig_file"
    fi
done < "$samples_list"
