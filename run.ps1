# --- Configuración de Nombres ---
$newRootDir = "zenergy_platform"
$coreDir = "$newRootDir\core"
$appsDir = "$newRootDir\apps"
$bioApp = "$appsDir\biohacking"
$zboxApp = "$appsDir\zbox"

# --- Crear la carpeta raíz del proyecto y carpetas del sistema ---
New-Item -ItemType Directory -Path $newRootDir -Force
New-Item -ItemType Directory -Path "$newRootDir\media" -Force
New-Item -ItemType Directory -Path "$newRootDir\templates" -Force
New-Item -ItemType Directory -Path "$newRootDir\static\img" -Force

# --- Crear Estructura del Core de Django ---
New-Item -ItemType Directory -Path $coreDir -Force
New-Item -ItemType File -Path "$coreDir\__init__.py" -Force
New-Item -ItemType File -Path "$coreDir\settings.py" -Force
New-Item -ItemType File -Path "$coreDir\urls.py" -Force

# --- Crear Estructura de Apps ---
New-Item -ItemType Directory -Path $appsDir -Force
New-Item -ItemType File -Path "$appsDir\__init__.py" -Force

# App Biohacking
New-Item -ItemType Directory -Path $bioApp -Force
New-Item -ItemType File -Path "$bioApp\__init__.py" -Force
New-Item -ItemType File -Path "$bioApp\models.py" -Force

# App Z-Box
New-Item -ItemType Directory -Path $zboxApp -Force
New-Item -ItemType File -Path "$zboxApp\__init__.py" -Force
New-Item -ItemType File -Path "$zboxApp\models.py" -Force

# --- COPIAR ARCHIVOS (Sin borrar los originales) ---
# Copia index.html para que Django lo use luego
if (Test-Path "index.html") {
    Copy-Item -Path "index.html" -Destination "$newRootDir\templates\index.html" -Force
}

# Copia imágenes y troqueles a la carpeta static de desarrollo
Get-ChildItem -Path *.png, *.jpg, *.svg -Exclude venv | Copy-Item -Destination "$newRootDir\static\img" -Force

Write-Host "✅ Estructura creada en '$newRootDir'. Tu despliegue en la raíz sigue intacto." -ForegroundColor Green