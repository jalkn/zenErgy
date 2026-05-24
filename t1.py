import os
from PIL import Image

def generate_biomesh(image_path, output_svg_path, grid_size=28):
    if not os.path.exists(image_path):
        print(f"[-] Error: No se encontró la imagen en {image_path}")
        return

    # 1. Cargar la imagen y forzar escala de grises (L)
    img = Image.open(image_path).convert('L')
    width, height = img.size
    
    # Comenzar a estructurar el string del SVG con los estilos que ya definimos
    svg_lines = []
    svg_lines.append(f'<svg viewBox="0 0 {width} {height}" width="100%" height="auto" class="overflow-visible">')
    svg_lines.append('  <style>')
    svg_lines.append('    .land-node { transition: fill 0.3s ease, opacity 0.3s ease, filter 0.3s ease; cursor: pointer; }')
    svg_lines.append('    .node-available { fill: #111111; opacity: 0.85; }')
    svg_lines.append('    .node-pulsed { fill: #ffffff !important; opacity: 1 !important; filter: drop-shadow(0 0 12px rgba(255, 255, 255, 0.9)); }')
    svg_lines.append('    .land-node:hover { fill: #ffffff !important; opacity: 1 !important; filter: drop-shadow(0 0 6px rgba(255, 255, 255, 0.6)); }')
    svg_lines.append('  </style>')
    svg_lines.append('  <g id="bioconstruccion-mesh">')

    node_count = 0
    max_radius = grid_size / 2 * 0.9  # El radio máximo permitido para que no se traslapen

    # 2. Muestreo por cuadrícula (Filas y Columnas)
    for y in range(0, height, grid_size):
        for x in range(0, width, grid_size):
            # Tomar el valor del píxel (0 = Negro absoluto, 255 = Blanco puro)
            pixel_value = img.getpixel((x, y))
            
            # 3. Mapear el brillo al tamaño del círculo (Inverso: más oscuro = punto más grande)
            # Si el píxel es muy claro (por encima de 240), no dibujamos nada para limpiar el fondo
            if pixel_value > 240:
                continue
                
            # Calcular el radio proporcional
            brightness_factor = (255 - pixel_value) / 255.0
            radius = brightness_factor * max_radius
            
            # Omitir puntos ridículamente pequeños para mantener la limpieza estética
            if radius < 1.5:
                continue
                
            node_count += 1
            
            # Generar el enlace dinámico de WhatsApp con el ID del nodo
            whatsapp_url = f"https://wa.me/573025333130?text=%5BZENERGIA%5D%20Reserva%20Nodo%20Instalacion%20%23{node_count:03d}"
            
            # Por defecto todos nacen como 'node-available'. 
            # Si necesitas activar uno como vendido inicialmente, puedes cambiar la clase condicionalmente aquí.
            node_class = "node-available"
            
            # Agregar el bloque al SVG
            svg_lines.append(f'    <a href="{whatsapp_url}" target="_blank">')
            svg_lines.append(f'      <circle class="land-node {node_class}" cx="{x}" cy="{y}" r="{radius:.1f}" />')
            svg_lines.append('    </a>')

    svg_lines.append('  </g>')
    svg_lines.append('</svg>')

    # 4. Guardar directamente en la ruta objetivo
    os.makedirs(os.path.dirname(output_svg_path), exist_ok=True)
    with open(output_svg_path, 'w', encoding='utf-8') as f:
        f.write('\n'.join(svg_lines))
        
    print(f"[+] Éxito: Matriz generada con {node_count} puntos interactivos.")
    print(f"[+] Archivo guardado en: {output_svg_path}")

# --- EJECUCIÓN DEL SCRIPT ---
if __name__ == "__main__":
    # Asegúrate de pasar la ruta correcta de tu foto en gris (P1200067.jpg)
    # El grid_size define la densidad (menor número = más puntos en pantalla)
    generate_biomesh(
        image_path="img/t1.jpg", 
        output_svg_path="img/barranquero-mesh.svg", 
        grid_size=30
    )