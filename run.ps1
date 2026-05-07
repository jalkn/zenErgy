# run.ps1 - Zenergia Unified Engine | WAVE Protocol Edition
# Operator: Jalko | Node: Santa Elena[cite: 18]

$Manifesto = @"
# 🍄 ZENERGIA.WORLD: Bio-Hardware & Bio-Construction Ecosystem

ZENERGIA orquesta la transición hacia una arquitectura regenerativa mediante la producción de materiales vivos y validación biocinética.[cite: 18]

## 🏗️ El Ecosistema de Resonancia
1. **Z-Box (Manufacturing Node)**: Bioreactor asíncrono IoT que estandariza la producción de bio-materiales y genera la "Sinfonía de Resonancia" (z-Beats).[cite: 18]
2. **Z-Brick (Construction Unit)**: Módulos de micelio con doble cara funcional (Onda de Gota / Código Z-Dial WAVE).[cite: 18]
3. **Z-Dial (Biokinetic Interface)**: Protocolo de validación humana WAVE (Walk, Absorb, Verticality, Explode).[cite: 18]

**Global Launch: Solsticio de Junio 2026 | Santa Elena, Antioquia**[cite: 18]
"@

Write-Host "Iniciando Ecosistema Zenergia con Protocolo WAVE..." -ForegroundColor Cyan[cite: 18]

# 1. SETUP DE DIRECTORIOS Y DOCUMENTACIÓN
$dirs = @("data", "img")[cite: 18]
foreach ($dir in $dirs) {
    if (!(Test-Path $dir)) {
        New-Item -ItemType Directory -Path $dir | Out-Null
    }
}
$Manifesto | Out-File -FilePath "README.md" -Encoding utf8[cite: 18]

# 2. GENERADOR DEL DIAL DEL DÍA (Lógica WAVE)
$now = Get-Date[cite: 18]
$d = $now.Day[cite: 18]
$m = $now.Month[cite: 18]

# Lógica de Fases WAVE sincronizada con el progreso anual:
# Mayo (5): AV (Absorb + Verticality)
# Junio (6): WAV (Walk + Absorb + Verticality)
# Julio+ (7): WAVE (Protocolo Completo)[cite: 18]
$protocol = if ($m -eq 5) { "AV" } elseif ($m -eq 6) { "WAV" } else { "WAVE" }[cite: 18]

$sets = $m[cite: 18]
$reps = $d * 10[cite: 18]
$dial = "$sets$protocol$reps"[cite: 18]

$logEntry = @"
# BITSTREAM_LOG: $($now.ToString("yyyy-MM-dd HH:mm"))
# DIAL_ACTIVE: $dial | PROTOCOL: WAVE_ENCRYPTION
[DATA] PHASE: $($protocol) | SETS: $sets | REPS: $reps | STATUS: SYNCED
"@[cite: 18]

$logEntry | Out-File -FilePath "data/bitstream.log" -Append[cite: 18]
Write-Host "[!] Z-Dial generado: $dial" -ForegroundColor Yellow[cite: 18]

# 3. LANZAMIENTO DEL SERVIDOR
Write-Host "Servidor activo en http://localhost:8000" -ForegroundColor Green[cite: 18]

if (Get-Command "python3" -ErrorAction SilentlyContinue) {
    python3 -m http.server 8000[cite: 18]
} elseif (Get-Command "python" -ErrorAction SilentlyContinue) {
    python -m http.server 8000[cite: 18]
} else {
    Write-Host "Error: No se encontró Python." -ForegroundColor Red[cite: 18]
}