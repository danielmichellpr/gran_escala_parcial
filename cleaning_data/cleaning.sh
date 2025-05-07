mkdir -p data
mkdir -p data/raw
mkdir -p data/clean
cd data/raw

# Descargamos los datos (asumiendo que ya tenemos configurado el AWS CLI)
aws s3 sync s3://itam-analytics-dante/profeco/ .  --exclude "*" --include "*.rar"

# Descomprimimos los datos (installamos unar desde brew: brew install unar)
    #(crea multiples carpetas, por año)
    # Diversos csv por cada año
for file in *.rar; do unar -f "$file"; done

# Movemos los csv a la carpeta clean
mv */ ../clean/
cd ../clean

# Checamos que ningún csv tenga encabezados (si ninguno tiene encabezados, se imprime que no tiene encabezados)
for file in */*.csv; do
    head -n 1 "$file" | grep -q "producto,presentacion,marca,categoria,catalogo,precio,fecharegistro,cadenacomercial,giro,nombrecomercial,direccion,estado,municipio,latitud,longitud" || echo "El archivo $file no tiene encabezados"
done

for file in */*.csv; do
    head -n 1 "$file" | grep -q "PRODUCTO,PRESENTACION,MARCA,CATEGORIA,CATALOGO,PRECIO,FECHAREGISTRO,CADENACOMERCIAL,GIRO,NOMBRECOMERCIAL,DIRECCION,ESTADO,MUNICIPIO,LATITUD,LONGITUD" || echo "El archivo $file no tiene encabezados"
done

# Checamos codificación
for file in */*.csv; do file -I "$file"; done

# Eliminamos tildes (CD's, etc.)
for file in */*.csv; do
  sed -i '' 's/´//g' "$file"
done

# Eliminamos acentos usando iconv
for file in */*.csv; do { iconv -c -f utf-8 -t ascii//TRANSLIT "$file" > temp && mv temp "$file" ;} ; done

# Ningún csv tiene encabezados
    # Los encabezados son (https://datos.profeco.gob.mx/diccionarioDatosQQP.php): 
      # producto, presentacion, marca, categoria, catálogo, precio, fecharegistro, cadenacomercial, 
      # giro, nombrecomercial, direccion, estado, municipio, latitud, longitud
# Agregamos encabezados a los csv
for file in */*.csv; do 
    echo "producto,presentacion,marca,categoria,catalogo,precio,fecharegistro,cadenacomercial,giro,nombrecomercial,direccion,estado,municipio,latitud,longitud" | cat - "$file" > temp && mv temp "$file"
done
