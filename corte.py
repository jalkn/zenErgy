import svgwrite
import math

def create_hexagon_diecut(filename, side_length=25, wall_height=20):
    # side_length 25mm = 2.5cm (para un diámetro total de 5cm)
    # wall_height 20mm = 2.0cm
    
    dwg = svgwrite.Drawing(filename, profile='tiny', size=("200mm", "200mm"))
    
    # Centro del dibujo
    cx, cy = 100, 100
    
    # 1. Dibujar la Base Hexagonal (Líneas de doblez)
    base_points = []
    for i in range(6):
        angle_deg = 60 * i
        angle_rad = math.radians(angle_deg)
        x = cx + side_length * math.cos(angle_rad)
        y = cy + side_length * math.sin(angle_rad)
        base_points.append((x, y))
    
    # Línea de doblez de la base (punteada)
    dwg.add(dwg.polygon(base_points, fill='none', stroke='blue', stroke_dasharray='2,2'))
    
    # 2. Dibujar las Paredes y Pestañas (Líneas de corte)
    for i in range(6):
        p1 = base_points[i]
        p2 = base_points[(i + 1) % 6]
        
        # Calcular vector perpendicular para la pared
        dx = p2[0] - p1[0]
        dy = p2[1] - p1[1]
        dist = math.sqrt(dx**2 + dy**2)
        nx = -dy / dist
        ny = dx / dist
        
        # Puntos de la pared externa
        ext1 = (p1[0] + nx * wall_height, p1[1] + ny * wall_height)
        ext2 = (p2[0] + nx * wall_height, p2[1] + ny * wall_height)
        
        # Dibujar bordes de la pared (Corte)
        dwg.add(dwg.line(p1, ext1, stroke='red'))
        dwg.add(dwg.line(ext1, ext2, stroke='red'))
        dwg.add(dwg.line(ext2, p2, stroke='red'))
        
        # Añadir una pequeña pestaña de pegado en cada unión (opcional pero recomendado)
        flap_w = 8
        dwg.add(dwg.line(ext1, (ext1[0] + dx*0.2, ext1[1] + dy*0.2), stroke='red'))

    dwg.save()
    print(f"Troquel guardado como {filename}. Rojo=Corte, Azul=Doblez.")

if __name__ == "__main__":
    # Generar Base
    create_hexagon_diecut("troquel_base.svg")
    # Generar Tapa (ligeramente más grande, 26mm de lado para que calce)
    create_hexagon_diecut("troquel_tapa.svg", side_length=26, wall_height=15)