import os
import pandas as pd

PATH = 'data/clean'
if __name__ == "__main__":

    for path, dirs, files in os.walk(PATH):
        for file in files:
            if file.endswith('.csv'):
                # Creamos path derl archivo
                f = os.path.join(path, file)
                print(f"Procesamiento del archivo: {f}")
                # Leemos el archivo
                df = pd.read_csv(f, encoding= 'utf-8', encoding_errors='strict')
                # pacic significa "basico" en la variable "catalogo"
                df.loc[df['catalogo'] == 'pacic', 'catalogo'] = 'basicos'
                # Existen unas cuantas observaciones con "medicamentos.1" en la columna "catalogo"
                df.loc[df['catalogo'] == 'medicamentos.1', 'catalogo'] = 'medicamentos'

                # Pasamos a minusculas las observaciones
                for col in df.columns:
                    # Si es string
                    if pd.api.types.is_string_dtype(df[col]):
                        # Pasamos a minusculas
                        df[col] = df[col].str.lower()
                        # Cambiamos comas por punto y coma
                        df[col] = df[col].str.replace(',', ';')

                df.to_csv(f, index=False)