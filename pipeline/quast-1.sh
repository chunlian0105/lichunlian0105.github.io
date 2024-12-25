#!/bin/bash

# ���� samples.list �ļ���·��
samples_list="$PWD/samples.list"
# ������ܽ�����ļ�·��
summary_file="$PWD/QUAST/summary_report.txt"

# ��ʼ�����ܱ����ļ�
echo -e "Sample_ID\tN50\tL50\tTotal_Length\tContig_Num\tMax_Length" > "$summary_file"

# ��ȡ samples.list �ļ������д���
while IFS= read -r sample_id; do
  # ʹ�� sample_id ��Ϊǰ׺
  prefix="$sample_id"
  # ���� QUAST ���Ŀ¼��·��
  quast_results="$PWD/QUAST/quast_results_$prefix"
  # ��� report.tsv �ļ��Ƿ����
  report_file="$quast_results/report.tsv"
  if [ -f "$report_file" ]; then
    # ��ȡ�����Ϣ��д������ļ�
    n50=$(awk -F"\t" '{if ($1 == "N50") print $2}' "$report_file")
    l50=$(awk -F"\t" '{if ($1 == "L50") print $2}' "$report_file")
    total_length=$(awk -F"\t" '{if ($1 == "Total length") print $2}' "$report_file")
    contig_num=$(awk -F"\t" '{if ($1 == "Number of contigs") print $2}' "$report_file")
    max_length=$(awk -F"\t" '{if ($1 == "Max contig length") print $2}' "$report_file")
    
    # ����ȡ��������ӵ������ļ�
    echo -e "$sample_id\t$n50\t$l50\t$total_length\t$contig_num\t$max_length" >> "$summary_file"
  else
    # ��� report.tsv �ļ������ڣ���ӡ������Ϣ
    echo "ERROR! Report file not found for $sample_id: $report_file"
  fi
done < "$samples_list"

echo "������ɣ�����ѱ����� $summary_file"