import os
from PIL import Image, ImageFilter

def quitar_fondo_perfecto_sin_ia(input_path, output_path, tolerancia=230, erosion=1):
    """
    Remueve el fondo blanco instantáneamente sin descargar IA, 
    eliminando el stroke blanco mediante erosión de máscara.
    """
    if not os.path.exists(input_path):
        print(f"Error: No se encontró la imagen en {input_path}")
        return

    # 1. Abrir la imagen original
    img = Image.open(input_path).convert("RGBA")
    ancho, alto = img.size
    datos = img.getdata()

    # 2. Crear una máscara binaria inicial basada en la tolerancia del blanco
    mascara = Image.new("L", (ancho, alto), 0)
    pixeles_mascara = []

    for item in datos:
        # Si el píxel es más oscuro que la tolerancia, pertenece a la gorra (255 = visible)
        if item[0] < tolerancia or item[1] < tolerancia or item[2] < tolerancia:
            pixeles_mascara.append(255)
        else:
            pixeles_mascara.append(0)
    
    mascara.putdata(pixeles_mascara)

    # 3. ELIMINAR EL STROKE (Erosión): Encogemos la máscara hacia adentro
    if erosion > 0:
        mascara = mascara.filter(ImageFilter.MinFilter(size=3))

    # 4. SUAVIZAR EL BORDE (Anti-aliasing): Desvanecimiento fino
    mascara_final = mascara.filter(ImageFilter.GaussianBlur(radius=0.6))

    # 5. Aplicar la máscara refinada como el canal Alpha de la imagen
    img.putalpha(mascara_final)

    # Guardar el asset limpio
    os.makedirs(os.path.dirname(output_path), exist_ok=True)
    img.save(output_path, "PNG")
    print(f"¡Hecho en milisegundos! Render limpio guardado en: {output_path}")

if __name__ == "__main__":
    ruta_entrada = "img/biorushW.png"
    ruta_salida = "img/biorush.png"
    
    quitar_fondo_perfecto_sin_ia(ruta_entrada, ruta_salida, tolerancia=230, erosion=1)