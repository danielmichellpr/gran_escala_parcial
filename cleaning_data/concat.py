import os
import pandas as pd
import glob

PATH = 'data/clean'
PATH_OUT = 'data/concat'
if __name__ == "__main__":

    for folder in os.listdir(PATH):
        folder_path = os.path.join(PATH, folder)
        if os.path.isdir(folder_path):
            files = glob.glob(os.path.join(folder_path, '*.csv'))

            dfs = []
            for file in files:
                try:
                    df = pd.read_csv(file, encoding='utf-8', dtype=str)
                    dfs.append(df)
                except Exception as e:
                    print(f"Error al leer el archivo {file}: {e}")

            if dfs:
                    concat_df = pd.concat(dfs, ignore_index=True)
                    concat_df['anio'] = folder[-4:]
                    concat_df.to_csv(os.path.join(PATH_OUT, f'{folder[-4:]}.csv'), index=False, encoding='utf-8')
                    print(folder[-4:], ":", concat_df.shape)
                    print(concat_df['catalogo'].value_counts())
    

