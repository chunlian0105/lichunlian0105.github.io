#!/bin/bash
# ���� samples.list �ļ���·��
samples_list="$PWD/samples.list"
# ����һ�����ڴ洢QUAST���Ŀ¼���б�
quast_dirs=()

# ��ȡ samples.list �ļ������д���
while IFS= read -r sample_id; do
  # ʹ�� sample_id ��Ϊǰ׺
  prefix="$sample_id"
  # ���������� contigs.fasta �ļ�·��
  contigs_fasta="$PWD/SPAdes/outdir_$prefix/contigs.fasta"
  # ����QUAST���Ŀ¼
  quast_output_dir="$PWD/QUAST/quast_results_$prefix"
  # ��� contigs.fasta �ļ��Ƿ����
  if [ -f "$contigs_fasta" ]; then
    # ����ļ����ڣ����� QUAST
    quast.py -o "$quast_output_dir" "$contigs_fasta"
    # ��QUAST���Ŀ¼��ӵ��б���
    quast_dirs+=("$quast_output_dir")
  else
    # ����ļ������ڣ���ӡ������Ϣ
    echo "ERROR! File not found (contigs): $contigs_fasta"
  fi
done < "$samples_list"
