#!/bin/bash

# 定义 samples.list 文件的路径
samples_list="$PWD/samples.list"
# 定义汇总结果的文件路径
summary_file="$PWD/QUAST/summary_report.txt"

# 初始化汇总报告文件
echo -e "Sample_ID\tN50\tL50\tTotal_Length\tContig_Num\tMax_Length" > "$summary_file"

# 读取 samples.list 文件并逐行处理
while IFS= read -r sample_id; do
  # 使用 sample_id 作为前缀
  prefix="$sample_id"
  # 构建 QUAST 结果目录的路径
  quast_results="$PWD/QUAST/quast_results_$prefix"
  # 检查 report.tsv 文件是否存在
  report_file="$quast_results/report.tsv"
  if [ -f "$report_file" ]; then
    # 提取相关信息并写入汇总文件
    n50=$(awk -F"\t" '{if ($1 == "N50") print $2}' "$report_file")
    l50=$(awk -F"\t" '{if ($1 == "L50") print $2}' "$report_file")
    total_length=$(awk -F"\t" '{if ($1 == "Total length") print $2}' "$report_file")
    contig_num=$(awk -F"\t" '{if ($1 == "Number of contigs") print $2}' "$report_file")
    max_length=$(awk -F"\t" '{if ($1 == "Max contig length") print $2}' "$report_file")
    
    # 将提取的数据添加到汇总文件
    echo -e "$sample_id\t$n50\t$l50\t$total_length\t$contig_num\t$max_length" >> "$summary_file"
  else
    # 如果 report.tsv 文件不存在，打印错误消息
    echo "ERROR! Report file not found for $sample_id: $report_file"
  fi
done < "$samples_list"

echo "汇总完成！结果已保存至 $summary_file"