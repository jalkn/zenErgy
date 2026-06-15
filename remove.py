import os
from PIL import Image, ImageFilter

def procesar_croma_biorush_pro(input_path, output_path):
    # 1. Abrir imagen y asegurar transparencia
    img = Image.open(input_path).convert("RGBA")
    data = img.getdata()
    
    # 2. Crear máscara: Detectar verde y aplicar un umbral de suavizado
    # Usamos tolerancia para atrapar el halo (mezcla de verde)
    new_data = []
    for item in data:
        # Detectar píxeles donde el verde sea predominante
        if item[1] > (item[0] + 40) and item[1] > (item[2] + 40):
            new_data.append((0, 0, 0, 0)) # Transparente
        else:
            new_data.append(item)
            
    img.putdata(new_data)
    
    # 3. Limpieza de bordes:
    # A. Erosionamos 1 píxel para quitar el rastro verde
    # B. Aplicamos un ligero desenfoque para suavizar el corte (antialiasing)
    mascara = img.split()[3]
    mascara = mascara.filter(ImageFilter.MinFilter(3)) # Erosión
    img.putalpha(mascara)
    
    # 4. Autocrop final al ras
    bbox = img.getbbox()
    if bbox:
        img = img.crop(bbox)
        
    img.save(output_path, "PNG")
    print(f"Asset limpio guardado: {output_path}")

if __name__ == "__main__":
    procesar_croma_biorush_pro("img/6.png", "img/45capsBackCordy.png")