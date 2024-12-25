#!/bin/bash

# ��ȡsamples.list�ļ�
sample_file="$PWD/samples.list"

# ����ÿ���������������
batch_size=6

# ��ȡ�ļ���������
total_lines=$(wc -l < "$sample_file")

# ������Ҫѭ���Ĵ���
loops=$((total_lines / batch_size))
if [ $((total_lines % batch_size)) -ne 0 ]; then
  loops=$((loops + 1))
fi

# ѭ������ÿһ������
for (( i=0; i<loops; i++ )); do
  # ��samples.list�ж�ȡ��һ������
  batch_samples=$(tail -n +$((i*batch_size+1)) "$sample_file" | head -n$batch_size)

  # Ϊÿ������ִ��expect�ű�
  while IFS= read -r sample; do
    # ����expect�ű������ݵ�ǰ����ID
    expect auto_authenticate.exp "$sample" &
    # ��ȡexpect�ű���PID
    pid=$!
    # ��PID��ӵ���̨�����б���
    pids+=($pid)
  done <<< "$batch_samples"

  # �ȴ���ǰ���ε�expect�ű�ִ�����
  for pid in "${pids[@]}"; do
    wait $pid
  done
  # ��պ�̨�����б�Ϊ��һ������׼��
  pids=()
done
