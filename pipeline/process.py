import pandas as pd 
import os
import sys  # 导入 sys 模块

def metaphlan_result_extract(fold_path, outdir_path):
    fold_names = os.listdir(fold_path)
    for fold_name in fold_names:
        if fold_name.endswith('.txt'):  # metaphlan文件路径
            pre = fold_name.split('_')[0]
            file_path = os.path.join(fold_path, fold_name)
            file = pd.read_table(file_path, comment='#', names=['taxonomy', 'taxid', 'abundance', 'other_possible_taxon'])
            split = file['taxonomy'].str.split('|')
            file['level'] = split.map(lambda x: len(x))
            
            levels = ['kingdom', 'phylum', 'class', 'order', 'family', 'genus', 'species', 'SGB']
            for level_num, group in file.groupby('level'):
                if level_num < len(levels):  # 仅在级别名称在 levels 列表范围内时进行保存
                    outfile_path = os.path.join(outdir_path, f"{pre}_{levels[level_num - 1]}.txt")
                    group.to_csv(outfile_path, sep='\t', index=False)

def main():
    if len(sys.argv) < 3:  # 检查参数数量是否为3个
        print("usage: python process.py <input_dir> <outdir>")
        sys.exit(1)
    
    input_dir = sys.argv[1]
    output_dir = sys.argv[2]
    metaphlan_result_extract(input_dir, output_dir)  # 调用函数

if __name__ == "__main__":
    main()





                        

