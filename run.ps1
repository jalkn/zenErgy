# run.ps1 - Zenergia Unified Engine
# Operator: Jalkon | Node: Santa Elena

Write-Host "Iniciando Ecosistema Zenergia..." -ForegroundColor Cyan

# --- 1. SETUP DE DIRECTORIOS ---
$dirs = @("data", "img")
foreach ($dir in $dirs) {
    if (!(Test-Path $dir)) {
        New-Item -ItemType Directory -Path $dir | Out-Null
        Write-Host "[+] Directorio $dir creado." -ForegroundColor Gray
    }
}

# --- 2. GENERADOR DEL DIAL DEL DÍA (Lógica Hexagonal) ---
$now = Get-Date
$d = $now.Day
$m = $now.Month
$protocol = if ($m -eq 5) { "FS" } elseif ($m -eq 6) { "FSW" } else { "FSWJ" }
$sets = $m
$reps = $d * 10
$dial = "$sets$protocol$reps"

$logEntry = @"
# BITSTREAM_LOG: $($now.ToString("yyyy-MM-dd HH:mm"))
# DIAL_ACTIVE: $dial | PHASE: RESONANCE_STABILITY
[DATA] SETS: $sets | REPS: $reps | STATUS: ACTIVE
"@

$logEntry | Out-File -FilePath "data/bitstream.log" -Append
Write-Host "[!] Dial del día generado: $dial" -ForegroundColor Yellow

# --- 3. SERVIDOR DE DESARROLLO ---
# Esto sirve el index.html y los assets en el puerto 8000
Write-Host "Servidor activo en http://localhost:8000" -ForegroundColor Green
python -m http.server 8000