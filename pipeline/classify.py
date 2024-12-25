# -*- coding: utf-8 -*-
import os
import pandas as pd

# �ֶ����������ļ���·��������ļ���·��
input_folder = input("input:").strip()
output_folder = input("output").strip()

# ��ʾ�㼶ѡ��
print("choice:")
print("1. kingdom")
print("2. kingdom, phylum")
print("3. kingdom, phylum, class")
print("4. kingdom, phylum, class, order")
print("5. kingdom, phylum, class, order, family")
print("6. kingdom, phylum, class, order, family, genus")
print("7. kingdom, phylum, class, order, family, genus, species")
print("8. kingdom, phylum, class, order, family, genus, species, form")

# ���û�ѡ��㼶
level_choice = input("number:").strip()

# ����ѡ��Ĳ㼶����㼶����
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

# ��ȡ�ļ���������.txt�ļ�������ѡ��Ĳ㼶
file_list = [f for f in os.listdir(input_folder) if f.endswith(file_suffix)]

# ����һ���������������ļ�
def process_file(file_path, output_folder, levels):
    # ��ȡ�ļ�
    df = pd.read_table(file_path)
    
    # ȷ���ļ�����taxonomy��
    if 'taxonomy' not in df.columns:
        print(f"skip")
        return
    
    # �� taxonomy �а� `|` �ָ�
    split_taxonomy = df['taxonomy'].str.split(r'\|')
    
    # ����һ���ֵ����洢�㼶��Ϣ
    taxonomy_dict = {level: [] for level in levels}
    
    # ��ÿ���㼶��ȡ��Ϣ
    for i, level in enumerate(levels):
        taxonomy_dict[level] = split_taxonomy.apply(lambda x: x[i] if len(x) > i else None)
    
    # ���taxonomy��ǰ׺
    for level in levels:
        taxonomy_dict[level] = taxonomy_dict[level].str.replace(r'^[a-z]+__', '', regex=True)
    
    # ����������ݿ�
    result_df = pd.DataFrame(taxonomy_dict)
    
    # �����abundance�У���ӵ�������ݿ�
    if 'abundance' in df.columns:
        result_df['abundance'] = df['abundance']
    
    # ��������ļ�·��
    output_file = os.path.join(output_folder, os.path.basename(file_path).replace(file_suffix, "_processed.csv"))
    
    # ����ļ�
    result_df.to_csv(output_file, index=False)

# ���������ļ�
for file in file_list:
    file_path = os.path.join(input_folder, file)
    process_file(file_path, output_folder, levels)

print("completed")
