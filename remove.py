import os
from PIL import Image, ImageFilter

def quitar_fondo_con_borde_suave(input_path, output_path, tolerancia=230):
    if not os.path.exists(input_path):
        print(f"Error: No se encontró la imagen en {input_path}")
        return

    # 1. Abrir imagen original
    img = Image.open(input_path).convert("RGBA")
    datos = img.getdata()

    # 2. Crear una máscara binaria (blanco y negro) del fondo
    mascara = Image.new("L", img.size)
    pixeles_mascara = []

    for item in datos:
        # Si es casi blanco, la máscara es negra (transparente), si no, blanca (visible)
        if item[0] >= tolerancia and item[1] >= tolerancia and item[2] >= tolerancia:
            pixeles_mascara.append(0)
        else:
            pixeles_mascara.append(255)
    
    mascara.putdata(pixeles_mascara)

    # 3. SUAVIZAR EL BORDE: Aplicamos un ligero desenfoque a la máscara
    # Esto elimina el "stroke" blanco duro y hace una transición suave
    mascara_suave = mascara.filter(ImageFilter.GaussianBlur(radius=1))

    # 4. Aplicar la nueva máscara suave a la imagen original
    img.putalpha(mascara_suave)

    # Guardar resultado
    os.makedirs(os.path.dirname(output_path), exist_ok=True)
    img.save(output_path, "PNG")
    print(f"¡Hecho de inmediato! Guardado en: {output_path}")

if __name__ == "__main__":
    quitar_fondo_con_borde_suave("img/cap.png", "img/cap_limpio.png")