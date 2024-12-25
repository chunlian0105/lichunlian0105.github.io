# -*- coding: utf-8 -*-
import os
import pandas as pd

# 手动输入数据文件夹路径和输出文件夹路径
input_folder = input("input:").strip()
output_folder = input("output").strip()

# 显示层级选项
print("choice:")
print("1. kingdom")
print("2. kingdom, phylum")
print("3. kingdom, phylum, class")
print("4. kingdom, phylum, class, order")
print("5. kingdom, phylum, class, order, family")
print("6. kingdom, phylum, class, order, family, genus")
print("7. kingdom, phylum, class, order, family, genus, species")
print("8. kingdom, phylum, class, order, family, genus, species, form")

# 让用户选择层级
level_choice = input("number:").strip()

# 根据选择的层级定义层级名称
if level_choice == "1":
    levels = ["kingdom"]
    file_suffix = "_kingdom.txt"
elif level_choice == "2":
    levels = ["kingdom", "phylum"]
    file_suffix = "_phylum.txt"
elif level_choice == "3":
    levels = ["kingdom", "phylum", "class"]
    file_suffix = "_class.txt"
elif level_choice == "4":
    levels = ["kingdom", "phylum", "class", "order"]
    file_suffix = "_order.txt"
elif level_choice == "5":
    levels = ["kingdom", "phylum", "class", "order", "family"]
    file_suffix = "_family.txt"
elif level_choice == "6":
    levels = ["kingdom", "phylum", "class", "order", "family", "genus"]
    file_suffix = "_genus.txt"
elif level_choice == "7":
    levels = ["kingdom", "phylum", "class", "order", "family", "genus", "species"]
    file_suffix = "_species.txt"
elif level_choice == "8":
    levels = ["kingdom", "phylum", "class", "order", "family", "genus", "species", "form"]
    file_suffix = "_form.txt"
else:
    print("exit")
    exit()

# 获取文件夹中所有.txt文件，根据选择的层级
file_list = [f for f in os.listdir(input_folder) if f.endswith(file_suffix)]

# 定义一个函数来处理单个文件
def process_file(file_path, output_folder, levels):
    # 读取文件
    df = pd.read_table(file_path)
    
    # 确保文件中有taxonomy列
    if 'taxonomy' not in df.columns:
        print(f"skip")
        return
    
    # 将 taxonomy 列按 `|` 分割
    split_taxonomy = df['taxonomy'].str.split(r'\|')
    
    # 创建一个字典来存储层级信息
    taxonomy_dict = {level: [] for level in levels}
    
    # 按每个层级提取信息
    for i, level in enumerate(levels):
        taxonomy_dict[level] = split_taxonomy.apply(lambda x: x[i] if len(x) > i else None)
    
    # 清除taxonomy中前缀
    for level in levels:
        taxonomy_dict[level] = taxonomy_dict[level].str.replace(r'^[a-z]+__', '', regex=True)
    
    # 创建结果数据框
    result_df = pd.DataFrame(taxonomy_dict)
    
    # 如果有abundance列，添加到结果数据框
    if 'abundance' in df.columns:
        result_df['abundance'] = df['abundance']
    
    # 设置输出文件路径
    output_file = os.path.join(output_folder, os.path.basename(file_path).replace(file_suffix, "_processed.csv"))
    
    # 输出文件
    result_df.to_csv(output_file, index=False)

# 批量处理文件
for file in file_list:
    file_path = os.path.join(input_folder, file)
    process_file(file_path, output_folder, levels)

print("completed")
