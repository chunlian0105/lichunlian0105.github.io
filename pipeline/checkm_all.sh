#!/bin/bash

# 定义存放 checkm 文件的目录
checkm_dir="$PWD/checkm1"  # 替换为实际路径
output_file="$PWD/combined_bins_qa.txt"

# 初始化输出文件，并添加表头（假设所有文件的表头相同）
first_file=$(find "$checkm_dir" -type f -name "bins_qa.txt" | head -n 1)
if [ -f "$first_file" ]; then
    # 提取表头并添加一个新列 "Source" 写入输出文件
    head -n 1 "$first_file" | awk '{print $0 "\tSource"}' > "$output_file"
else
    echo "No bins_qa.txt files found!"
    exit 1
fi

# 遍历所有 bins_qa.txt 文件，跳过表头并追加内容
find "$checkm_dir" -type f -name "bins_qa.txt" | while read -r file; do
    # 提取文件路径中的 SRR 文件名
    srr_name=$(basename "$(dirname "$file")")
    
    # 跳过表头，追加内容并添加 SRR 文件名作为新列
    tail -n +2 "$file" | awk -v source="$srr_name" '{print $0 "\t" source}' >> "$output_file"
done

echo "整合完成！结果保存到 $output_file"
