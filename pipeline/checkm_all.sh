#!/bin/bash

# ������ checkm �ļ���Ŀ¼
checkm_dir="$PWD/checkm1"  # �滻Ϊʵ��·��
output_file="$PWD/combined_bins_qa.txt"

# ��ʼ������ļ�������ӱ�ͷ�����������ļ��ı�ͷ��ͬ��
first_file=$(find "$checkm_dir" -type f -name "bins_qa.txt" | head -n 1)
if [ -f "$first_file" ]; then
    # ��ȡ��ͷ�����һ������ "Source" д������ļ�
    head -n 1 "$first_file" | awk '{print $0 "\tSource"}' > "$output_file"
else
    echo "No bins_qa.txt files found!"
    exit 1
fi

# �������� bins_qa.txt �ļ���������ͷ��׷������
find "$checkm_dir" -type f -name "bins_qa.txt" | while read -r file; do
    # ��ȡ�ļ�·���е� SRR �ļ���
    srr_name=$(basename "$(dirname "$file")")
    
    # ������ͷ��׷�����ݲ���� SRR �ļ�����Ϊ����
    tail -n +2 "$file" | awk -v source="$srr_name" '{print $0 "\t" source}' >> "$output_file"
done

echo "������ɣ�������浽 $output_file"
