#!/bin/bash
# 定义 samples.list 文件的路径
samples_list="$PWD/samples.list"
# 创建一个用于存储QUAST输出目录的列表
quast_dirs=()

# 读取 samples.list 文件并逐行处理
while IFS= read -r sample_id; do
  # 使用 sample_id 作为前缀
  prefix="$sample_id"
  # 构建完整的 contigs.fasta 文件路径
  contigs_fasta="$PWD/SPAdes/outdir_$prefix/contigs.fasta"
  # 构建QUAST输出目录
  quast_output_dir="$PWD/QUAST/quast_results_$prefix"
  # 检查 contigs.fasta 文件是否存在
  if [ -f "$contigs_fasta" ]; then
    # 如果文件存在，运行 QUAST
    quast.py -o "$quast_output_dir" "$contigs_fasta"
    # 将QUAST输出目录添加到列表中
    quast_dirs+=("$quast_output_dir")
  else
    # 如果文件不存在，打印错误消息
    echo "ERROR! File not found (contigs): $contigs_fasta"
  fi
done < "$samples_list"
