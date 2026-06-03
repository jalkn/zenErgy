from PIL import Image, ImageDraw, ImageOps
import math

def halftone_image(input_image_path, output_image_path, dot_size=3, spacing=5, angle=45, background_color=(255, 255, 255)):
    """
    Reads a PNG image, converts it to grayscale, and applies a halftone effect with a colored background.
    """
    try:
        # Open the image
        img = Image.open(input_image_path)
        img = img.convert('L')  # Convert to grayscale

        # Create a new blank image for the halftone output with the specified background color
        halftone_img = Image.new('RGB', img.size, background_color)
        draw = ImageDraw.Draw(halftone_img)

        # Convert angle to radians for math functions
        angle_rad = math.radians(angle)
        cos_angle = math.cos(angle_rad)
        sin_angle = math.sin(angle_rad)

        # Get image dimensions
        width, height = img.size

        # Initialize dot counter
        total_dots = 0

        # Iterate over the image in a grid pattern
        for x in range(0, width, spacing):
            for y in range(0, height, spacing):
                # Get the grayscale value of the pixel
                pixel_value = img.getpixel((x, y))

                # --- CORRECCIÓN DE INVERSIÓN ---
                # Proporción directa: píxeles más claros = puntos más grandes
                dot_radius = dot_size * (pixel_value / 255.0)

                # Draw a circle (halftone dot)
                if dot_radius > 0:
                    draw.ellipse(
                        (
                            x - dot_radius,
                            y - dot_radius,
                            x + dot_radius,
                            y + dot_radius
                        ),
                        fill=(255, 255, 255)  # Puntos blancos para la previsualización en imagen
                    )
                    total_dots += 1

        # Save the halftone image
        halftone_img.save(output_image_path)
        
        # Calculate dot count based on spacing
        dots_wide = width // spacing
        dots_high = height // spacing
        
        return halftone_img, width, height, total_dots, dots_high, dots_wide

    except FileNotFoundError:
        print(f"Error: The file '{input_image_path}' was not found.")
    except Exception as e:
        print(f"An error occurred: {e}")
        return None, None, None, None, None, None

def generate_svg_file(input_image_path, output_svg_path, dot_size, spacing, background_color):
    """
    Generates an SVG file with halftone dots (Fondo negro, puntos blancos sin invertir).
    """
    try:
        img = Image.open(input_image_path)
        img = img.convert('L')
        width, height = img.size
        
        # Build SVG content as a string
        svg_content = f'<?xml version="1.0" encoding="UTF-8" standalone="no"?>\n'
        svg_content += f'<svg width="{width}" height="{height}" viewBox="0 0 {width} {height}" xmlns="http://www.w3.org/2000/svg">\n'
        
        # Set background color
        rgb_tuple = background_color
        hex_color = '#{:02x}{:02x}{:02x}'.format(rgb_tuple[0], rgb_tuple[1], rgb_tuple[2])
        svg_content += f'<rect width="100%" height="100%" fill="{hex_color}" />\n'
        
        for x in range(0, width, spacing):
            for y in range(0, height, spacing):
                pixel_value = img.getpixel((x, y))
                
                # --- CORRECCIÓN DE INVERSIÓN ---
                dot_radius = dot_size * (pixel_value / 255.0)
                
                if dot_radius > 0:
                    # fill="white" para los puntos del colibrí
                    svg_content += f'<circle cx="{x}" cy="{y}" r="{dot_radius}" fill="white" />\n'
                    
        svg_content += '</svg>'
        
        with open(output_svg_path, "w") as svg_file:
            svg_file.write(svg_content)
        
        print(f"\nArchivo SVG guardado exitosamente en '{output_svg_path}'")
        
    except FileNotFoundError:
        print(f"Error: El archivo '{input_image_path}' no fue encontrado.")
    except Exception as e:
        print(f"Ocurrió un error al generar el SVG: {e}")

def save_image_to_pdf(image, pdf_output_path, total_dots, target_print_height_cm, target_width_cm, dots_high, dots_wide):
    """
    Slices a large image and saves it as a multi-page PDF with letter size pages.
    """
    if image is None:
        print("Error: No image to save to PDF.")
        return

    # Letter size dimensions at 300 DPI
    page_width_px = 2550  # 8.5 inches * 300 DPI
    page_height_px = 3300 # 11 inches * 300 DPI

    img_width, img_height = image.size

    # Calculate number of pages needed
    num_pages_wide = math.ceil(img_width / page_width_px)
    num_pages_high = math.ceil(img_height / page_height_px)
    total_pages = num_pages_wide * num_pages_high
    
    # Calculate costs
    cost_per_page = 18000
    cost_total_pages = total_pages * cost_per_page
    
    # Fixed costs
    pintura_cost = 200000
    espuma_cost = 7000 * 10
    
    # Calculate Final Total Cost including fixed costs
    total_cost_final = cost_total_pages + pintura_cost + espuma_cost

    pages = []

    for row in range(num_pages_high):
        for col in range(num_pages_wide):
            left = col * page_width_px
            top = row * page_height_px
            right = min(left + page_width_px, img_width)
            bottom = min(top + page_height_px, img_height)

            # Crop the image to the current page's dimensions
            page = image.crop((left, top, right, bottom))
            pages.append(page)

    # Save all pages into a single PDF
    if pages:
        first_page = pages.pop(0)
        first_page.save(pdf_output_path, "PDF", save_all=True, append_images=pages)
        
        # Print outputs in the requested Spanish format
        print("MURALES COLECTIVOS")
        print("Alejandro Monsalve M.")
        print("Programador y Artista Visual UdeA")
        
        print("\n--- Tamaño de la Imagen ---")
        print(f"{target_print_height_cm}cms alto x {target_width_cm:.0f}cms ancho")

        print("\nPASO A PASO")
        print("\nDefinir el fondo del mural (azul, rojo, o dejarlo en blanco)")
        print(f"Pintura acrílica (Vinilo Tipo 1) 9 litros ${pintura_cost:,}")
        
        print("\nMapear todos los puntos")
        print("\n--- Cantidad de Puntos ---")
        print(f"Alto por ancho: {dots_high} x {dots_wide} puntos")
        print(f"	Total: {total_dots:,}")
        
        print("\nCada persona busca su número de plantilla en el mapa para pintar")
        print("	(color negro o libre elección)")
        
        print("\n--- Cantidad de Plantillas ---")
        print(f"{total_pages} - 2 o 3 páginas tamaño carta x persona")
        print("Cada plantilla contiene approx. 50 puntos perforados")
        print(f"Costo por plantilla: ${cost_per_page:,}")
        print(f"Pintura acrílica 9 litros(Se pueden variar los colores) ${pintura_cost:,}")
        print(f"Espuma para aplicar la pintura: ${7000:,}x10 ${espuma_cost:,}")

        print(f"\nCosto Total: ${total_cost_final:,}")
        print(f"\nPDF guardado exitosamente en '{pdf_output_path}'")
    else:
        print("No pages to save.")


# --- Main part of the script ---
if __name__ == "__main__":
    input_file = 'img/4.JPG'
    output_image_file = 'img/image.png'
    output_pdf_file = 'img/pages.pdf'
    output_svg_file = 'img/bigPicture.svg'
    
    # Desired final print height in cm
    target_print_height_cm = 200

    # Configuración de previsualización de imagen (Fondo Negro)
    halftone_img, original_width, original_height, total_dots, dots_high, dots_wide = halftone_image(
        input_file,
        output_image_file,
        dot_size=12,
        spacing=30,
        angle=45,
        background_color=(0, 0, 0) # Fondo negro para el PNG/PDF de muestra
    )

    # Calculate target dimensions in pixels for a 200cm high print
    pixels_per_cm = 300 / 2.54 # DPI / inches_per_cm
    target_height_px = int(target_print_height_cm * pixels_per_cm)
    aspect_ratio = original_width / original_height
    target_width_px = int(target_height_px * aspect_ratio)

    # Resize the halftone image
    resized_halftone_img = halftone_img.resize((target_width_px, target_height_px), Image.LANCZOS)
    
    target_width_cm = target_print_height_cm * aspect_ratio

    # Save the raster PDF and print report
    save_image_to_pdf(resized_halftone_img, output_pdf_file, total_dots, target_print_height_cm, target_width_cm, dots_high, dots_wide)
    
    # Generar el archivo SVG con Fondo Negro (0,0,0)
    generate_svg_file(input_file, output_svg_file, dot_size=12, spacing=30, background_color=(0, 0, 0))