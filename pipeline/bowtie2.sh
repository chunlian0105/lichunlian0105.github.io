#!/bin/bash

# ���� samples.list �ļ�����������������ID�����磺ERR1449743, ERR1449744...

# ѭ������ samples.list �е�ÿ������
for sample in $(cat samples.list); do
    echo "Processing sample: $sample"

    # �������Ŀ¼����������ڣ�
    mkdir -p $PWD/bowtie2_results

    # ��������
    bowtie2-build $PWD/prodigal/$sample/${sample}_metagenomic_nucleotides.fna \
                  $PWD/prodigal/$sample/index

    # ʹ�� bowtie2 �ȶ�����
    bowtie2 -x $PWD/prodigal/$sample/index \
            -1 $PWD/filter/non-humanDNA/${sample}_1_trimmed.fastq.gz \
            -2 $PWD/filter/non-humanDNA/${sample}_2_trimmed.fastq.gz \
            -S $PWD/bowtie2_results/${sample}.sam

    # ʹ�� samtools �� .sam �ļ�ת��Ϊ .bam �ļ�
    samtools view -bS $PWD/bowtie2_results/${sample}.sam \
                  > $PWD/bowtie2_results/${sample}.bam

    # ���� .bam �ļ�
    samtools sort $PWD/bowtie2_results/${sample}.bam \
                  -o $PWD/bowtie2_results/${sample}_sorted.bam

    # ���������� .bam �ļ�
    samtools index $PWD/bowtie2_results/${sample}_sorted.bam

    # ��ȡ idxstats �����ÿ������ıȶԶ�����
    samtools idxstats $PWD/bowtie2_results/${sample}_sorted.bam \
                      > $PWD/bowtie2_results/${sample}_idxstats.txt

    echo "Finished processing sample: $sample"
    wait 
done
