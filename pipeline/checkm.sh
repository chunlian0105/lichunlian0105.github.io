#!/bin/bash

# 读取samples.list文件
sample_file="$PWD/samples.list"

# 设置每批处理的样本数量
batch_size=6

# 读取文件的总行数
total_lines=$(wc -l < "$sample_file")

# 计算需要循环的次数
loops=$((total_lines / batch_size))
if [ $((total_lines % batch_size)) -ne 0 ]; then
  loops=$((loops + 1))
fi

# 循环处理每一批样本
for (( i=0; i<loops; i++ )); do
  # 从samples.list中读取下一批样本
  batch_samples=$(tail -n +$((i*batch_size+1)) "$sample_file" | head -n$batch_size)

  # 为每个样本执行expect脚本
  while IFS= read -r sample; do
    # 调用expect脚本，传递当前样本ID
    expect auto_authenticate.exp "$sample" &
    # 获取expect脚本的PID
    pid=$!
    # 将PID添加到后台进程列表中
    pids+=($pid)
  done <<< "$batch_samples"

  # 等待当前批次的expect脚本执行完成
  for pid in "${pids[@]}"; do
    wait $pid
  done
  # 清空后台进程列表，为下一批次做准备
  pids=()
done
