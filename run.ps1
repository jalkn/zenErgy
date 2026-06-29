<#
.SYNOPSIS
    Script unificado de aprovisionamiento, limpieza y ejecución para JAKO-CORE.
.DESCRIPTION
    Este script automatiza la purga de configuraciones previas, regenera la
    arquitectura base (incluyendo package.json si falta), inyecta los componentes
    del HUD y levanta el entorno local estable de Astro.
#>

$ErrorActionPreference = "Stop"

# =========================================================================
# 1. Configuración de Estructuras de Código Base e Infraestructura (Source Data)
# =========================================================================

$PackageJsonCode = @'
{
  "name": "jako-core",
  "type": "module",
  "version": "1.0.0",
  "scripts": {
    "dev": "astro dev",
    "start": "astro dev",
    "build": "astro build",
    "preview": "astro preview",
    "astro": "astro"
  },
  "dependencies": {
    "astro": "^4.11.3"
  }
}
'@

# Configuración extendida de TypeScript para eliminar errores de resolución de rutas y tipos de Astro
$TsConfigCode = @'
{
  "extends": "astro/tsconfigs/strict",
  "compilerOptions": {
    "target": "ESNext",
    "module": "ESNext",
    "moduleResolution": "node",
    "resolveJsonModule": true,
    "isolatedModules": true,
    "noEmit": true,
    "strict": true,
    "allowJs": true,
    "checkJs": false,
    "jsx": "preserve",
    "baseUrl": ".",
    "paths": {
      "@components/*": ["src/components/*"],
      "@layouts/*": ["src/layouts/*"]
    }
  },
  "include": ["src/**/*", ".astro/**/*"]
}
'@

$LayoutCode = @'
---
interface Props {
  title?: string;
}

const { title = "JAKO VAULT" } = Astro.props;
---

<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no" />
    <link class="icon" type="image/png" href="/img/favicon.png" />
    <meta name="generator" content={Astro.generator} />
    <title>{title}</title>
    
    <link href="https://fonts.googleapis.com/css2?family=Orbitron:wght@400;700;900&family=Plus+Jakarta+Sans:wght@300;400;500;700&display=swap" rel="stylesheet" />
    
    <style is:global>
      :root {
        --jako-black: #050508;
        --jako-darkblue: #030712;
      }

      html, body {
        margin: 0;
        padding: 0;
        width: 100%;
        height: 100%;
        background-color: var(--jako-darkblue);
        color: #e5e7eb;
        font-family: 'Orbitron', sans-serif; 
        scroll-behavior: smooth; 
        letter-spacing: 0.05em;
        overflow: hidden;
      }

      .font-body {
        font-family: 'Plus Jakarta Sans', sans-serif;
      }
      
      ::-webkit-scrollbar {
        width: 4px;
        height: 4px;
      }
      ::-webkit-scrollbar-track {
        background: rgba(3, 7, 18, 0.8);
      }
      ::-webkit-scrollbar-thumb {
        background: rgba(6, 182, 212, 0.3);
        border-radius: 2px;
      }
      ::-webkit-scrollbar-thumb:hover {
        background: rgba(6, 182, 212, 0.5);
      }
    </style>
  </head>
  <body>
    <slot />
  </body>
</html>
'@

$IndexCode = @'
---
import VaultLayout from '../layouts/VaultLayout.astro';
import QuantumBg from '../components/QuantumBg.astro';
import HeaderHud from '../components/HeaderHud.astro';
import FooterHud from '../components/FooterHud.astro';
import TacticalDial from '../components/TacticalDial.astro';
---

<VaultLayout title="JAKO VAULT">
  <QuantumBg />
  
  <main class="relative w-full h-screen overflow-hidden flex flex-col justify-between">
    
    <header class="w-full z-10">
      <HeaderHud />
    </header>

    <section class="flex-1 w-full flex items-center justify-center z-10">
      <TacticalDial />
    </section>

    <footer class="w-full z-10">
      <FooterHud />
    </footer>

  </main>
</VaultLayout>
'@

$QuantumBgCode = @'
---
---
<div id="page-bg-overlay" class="fixed inset-0 z-[-1] transition-all duration-[600ms] ease-[cubic-bezier(0.4,0,0.2,1)]">
  <div class="absolute inset-0 bg-[radial-gradient(circle_at_50%_30%,_rgba(37,99,235,0.22)_0%,_rgba(15,23,42,0.75)_60%,_#030712_100%)]"></div>
  <div class="absolute inset-0 bg-gradient-to-b from-black/15 via-transparent to-black/25 pointer-events-none"></div>
  <canvas id="quantum-mesh-canvas" class="absolute inset-0 w-full h-full block opacity-45"></canvas>
</div>

<style>
  #page-bg-overlay {
    will-change: filter, opacity;
  }
</style>

<script>
  const initQuantumMesh = () => {
    const canvas = document.getElementById('quantum-mesh-canvas') as HTMLCanvasElement;
    if (!canvas) return;

    const ctx = canvas.getContext('2d');
    if (!ctx) return;

    let points: Array<{ x: number; y: number; ox: number; oy: number; vx: number; vy: number }> = [];
    const spacing = 32;
    const mouse = { x: -1000, y: -1000, rx: -1000, ry: -1000, active: false };
    const radius = 130;
    let animationFrameId: number;

    const resizeCanvas = () => {
      canvas.width = window.innerWidth;
      canvas.height = window.innerHeight;
      setupPoints();
    };

    const setupPoints = () => {
      points = [];
      const cols = Math.ceil(canvas.width / spacing) + 1;
      const rows = Math.ceil(canvas.height / spacing) + 1;

      for (let i = 0; i < cols; i++) {
        for (let j = 0; j < rows; j++) {
          const x = i * spacing;
          const y = j * spacing;
          points.push({ x, y, ox: x, oy: y, vx: 0, vy: 0 });
        }
      }
    };

    const animate = () => {
      ctx.clearRect(0, 0, canvas.width, canvas.height);
      mouse.rx += (mouse.x - mouse.rx) * 0.12;
      mouse.ry += (mouse.y - mouse.ry) * 0.12;
      ctx.fillStyle = 'rgba(6, 182, 212, 0.35)';

      for (let i = 0; i < points.length; i++) {
        const p = points[i];
        const dx = mouse.rx - p.ox;
        const dy = mouse.ry - p.oy;
        const dist = Math.sqrt(dx * dx + dy * dy);

        if (dist < radius) {
          const force = (radius - dist) / radius;
          const angle = Math.atan2(dy, dx);
          const tx = p.ox - Math.cos(angle) * force * 24;
          const ty = p.oy - Math.sin(angle) * force * 24;
          p.vx += (tx - p.x) * 0.08;
          p.vy += (ty - p.y) * 0.08;
        } else {
          p.vx += (p.ox - p.x) * 0.05;
          p.vy += (p.oy - p.y) * 0.05;
        }

        p.vx *= 0.82; p.vy *= 0.82;
        p.x += p.vx; p.y += p.vy;

        ctx.beginPath();
        ctx.arc(p.x, p.y, 1.1, 0, Math.PI * 2);
        ctx.fill();
      }
      animationFrameId = requestAnimationFrame(animate);
    };

    window.addEventListener('resize', resizeCanvas);
    window.addEventListener('mousemove', (e) => {
      mouse.x = e.clientX; mouse.y = e.clientY; mouse.active = true;
    });
    window.addEventListener('mouseleave', () => {
      mouse.x = -1000; mouse.y = -1000; mouse.active = false;
    });

    resizeCanvas();
    animate();
  };

  initQuantumMesh();
  document.addEventListener('astro:page-load', initQuantumMesh);
</script>
'@

$HeaderHudCode = @'
---
---
<div class="w-full max-w-7xl mx-auto px-4 pt-4 relative select-none">
  <div class="relative bg-[#050508]/40 backdrop-blur-md border border-cyan-500/20 rounded-xl p-4 flex flex-col md:flex-row justify-between items-center gap-4 shadow-[0_0_30px_rgba(6,182,212,0.03)] overflow-hidden">
    <div class="absolute top-0 left-0 w-full h-[1px] bg-gradient-to-r from-transparent via-cyan-500/40 to-transparent"></div>
    
    <div class="flex items-center gap-4">
      <div class="relative flex items-center justify-center w-10 h-10 border border-cyan-500/30 rounded-lg bg-cyan-950/20">
        <div class="absolute w-2 h-2 bg-cyan-400 rounded-full animate-ping opacity-75"></div>
        <div class="w-1.5 h-1.5 bg-cyan-400 rounded-full"></div>
      </div>
      <div>
        <div class="text-[10px] uppercase tracking-[0.25em] text-cyan-400/50 font-mono">System Time Matrix</div>
        <div id="hud-clock-display" class="text-lg font-bold font-mono tracking-widest text-white drop-shadow-[0_0_8px_rgba(255,255,255,0.1)]">
          00:00:00 <span class="text-xs text-cyan-400/70">Z</span>
        </div>
      </div>
    </div>

    <div class="text-center md:text-right flex flex-col items-center md:items-end">
      <div class="text-[10px] uppercase tracking-[0.3em] text-cyan-400/40 font-mono mb-0.5">Ecosistema Activo</div>
      <div class="flex items-center gap-2">
        <span class="font-black tracking-[0.2em] text-sm text-transparent bg-clip-text bg-gradient-to-r from-white via-gray-200 to-gray-400">
          JAKO VAULT
        </span>
        <span class="text-[9px] font-mono border border-emerald-500/30 bg-emerald-950/30 text-emerald-400 px-1.5 py-0.5 rounded uppercase tracking-widest">
          ONLINE
        </span>
      </div>
    </div>
  </div>
</div>

<script>
  const initHudClock = () => {
    const clockEl = document.getElementById('hud-clock-display');
    if (!clockEl) return;
    const updateClock = () => {
      const now = new Date();
      const hours = String(now.getHours()).padStart(2, '0');
      const minutes = String(now.getMinutes()).padStart(2, '0');
      const seconds = String(now.getSeconds()).padStart(2, '0');
      clockEl.innerHTML = `${hours}:${minutes}:${seconds} <span class="text-xs text-cyan-400/60 font-medium">Z</span>`;
    };
    updateClock();
    const intervalId = setInterval(updateClock, 1000);
    document.addEventListener('astro:before-swap', () => clearInterval(intervalId), { once: true });
  };
  initHudClock();
  document.addEventListener('astro:page-load', initHudClock);
</script>
'@

$FooterHudCode = @'
---
---
<div class="w-full max-w-7xl mx-auto px-4 pb-4 relative select-none">
  <div class="relative bg-[#050508]/40 backdrop-blur-md border border-cyan-500/20 rounded-xl p-3 flex flex-col md:flex-row justify-between items-center gap-3 text-[10px] font-mono tracking-wider text-cyan-400/60 shadow-[0_0_20px_rgba(6,182,212,0.02)] overflow-hidden">
    <div class="absolute bottom-0 left-0 w-full h-[1px] bg-gradient-to-r from-transparent via-cyan-500/30 to-transparent"></div>

    <div class="flex items-center gap-2 w-full md:w-auto overflow-hidden">
      <span class="text-emerald-400 font-bold animate-pulse">[STREAM]:</span>
      <div class="relative w-48 h-4 overflow-hidden">
        <div id="hud-stream-ticker" class="absolute whitespace-nowrap transition-transform duration-500 ease-out">
          INITIALIZING CORE SERVICES...
        </div>
      </div>
    </div>

    <div class="flex items-center gap-4 text-right text-[9px] text-cyan-400/40">
      <div>NODE: <span class="text-white font-bold">Z-STRUM.v1</span></div>
      <div>LATENCY: <span id="hud-latency-val" class="text-emerald-400 font-bold">-- ms</span></div>
      <div>SECURE: <span class="text-white font-bold">SSL_ECC_256</span></div>
    </div>
  </div>
</div>

<script>
  const logs = [
    "Z-STRUM CORE CONNECTED...",
    "ASYNC MATRIX OPERATIONAL...",
    "FETCHING LIVE PROTOCOLS...",
    "PULS BIOMETRICS BUFFER READY...",
    "SECURE ENVELOPE: ACTIVE"
  ];

  const initFooterHud = () => {
    const ticker = document.getElementById('hud-stream-ticker');
    const latencyVal = document.getElementById('hud-latency-val');
    if (!ticker) return;

    let logIndex = 0;
    const rotateLog = () => {
      ticker.style.opacity = '0';
      setTimeout(() => {
        ticker.innerText = logs[logIndex];
        ticker.style.opacity = '1';
        logIndex = (logIndex + 1) % logs.length;
      }, 500);
    };

    const logInterval = setInterval(rotateLog, 4500);
    const updateLatency = () => {
      if (latencyVal) {
        latencyVal.innerText = `${Math.floor(Math.random() * 30) + 12} ms`;
      }
    };
    
    updateLatency();
    const latencyInterval = setInterval(updateLatency, 6000);
    document.addEventListener('astro:before-swap', () => {
      clearInterval(logInterval); clearInterval(latencyInterval);
    }, { once: true });
  };

  initFooterHud();
  document.addEventListener('astro:page-load', initFooterHud);
</script>

<style>
  #hud-stream-ticker { transition: opacity 0.4s ease-in-out; }
</style>
'@

$TacticalDialCode = @'
---
---
<div class="relative flex items-center justify-center w-[340px] h-[340px] sm:w-[400px] sm:h-[400px] select-none">
  <div class="absolute inset-0 border border-cyan-500/10 rounded-full animate-[spin_120s_linear_infinite] pointer-events-none"></div>
  <div class="absolute inset-4 border border-dashed border-cyan-500/5 rounded-full animate-[spin_80s_linear_infinite_reverse] pointer-events-none"></div>

  <div id="hud-tactical-wheel" class="absolute inset-8 rounded-full border border-cyan-500/20 bg-[#050508]/30 backdrop-blur-sm transition-transform duration-700 ease-[cubic-bezier(0.25,1,0.5,1)] will-change-transform">
    <button data-index="0" data-angle="0" class="dial-node absolute top-4 left-1/2 -translate-x-1/2 flex flex-col items-center group pointer-events-auto focus:outline-none">
      <div class="w-2 h-2 border border-cyan-400 bg-cyan-950 rounded-full group-hover:bg-cyan-400 transition-colors duration-300"></div>
      <span class="font-mono text-[9px] tracking-widest text-cyan-400/40 group-hover:text-cyan-300 mt-1.5">CORE</span>
    </button>

    <button data-index="1" data-angle="120" class="dial-node absolute bottom-12 right-6 flex flex-col items-center group pointer-events-auto focus:outline-none">
      <div class="w-2 h-2 border border-cyan-400 bg-cyan-950 rounded-full group-hover:bg-cyan-400 transition-colors duration-300"></div>
      <span class="font-mono text-[9px] tracking-widest text-cyan-400/40 group-hover:text-cyan-300 mt-1.5">BIORUSH</span>
    </button>

    <button data-index="2" data-angle="240" class="dial-node absolute bottom-12 left-6 flex flex-col items-center group pointer-events-auto focus:outline-none">
      <div class="w-2 h-2 border border-cyan-400 bg-cyan-950 rounded-full group-hover:bg-cyan-400 transition-colors duration-300"></div>
      <span class="font-mono text-[9px] tracking-widest text-cyan-400/40 group-hover:text-cyan-300 mt-1.5">FOTO.ART</span>
    </button>
  </div>

  <div class="absolute w-28 h-28 border border-cyan-500/30 rounded-full bg-[#050508]/80 shadow-[0_0_30px_rgba(6,182,212,0.05)] flex flex-col items-center justify-center pointer-events-none">
    <div class="absolute inset-1.5 border border-dashed border-cyan-500/10 rounded-full animate-[spin_40s_linear_infinite]"></div>
    <div id="dial-center-status" class="font-mono text-[10px] font-bold tracking-[0.2em] text-white">VAULT</div>
    <div id="dial-center-index" class="font-mono text-[8px] tracking-widest text-cyan-400/50 mt-0.5">00 / 02</div>
  </div>
</div>

<script>
  const initTacticalDial = () => {
    const wheel = document.getElementById('hud-tactical-wheel');
    const nodes = document.querySelectorAll('.dial-node');
    const statusText = document.getElementById('dial-center-status');
    const indexText = document.getElementById('dial-center-index');
    if (!wheel || !statusText || !indexText) return;

    const sections = [
      { name: "VAULT", code: "00" },
      { name: "BIORUSH", code: "01" },
      { name: "FOTO.ART", code: "02" }
    ];

    nodes.forEach(node => {
      node.addEventListener('click', (e) => {
        const button = e.currentTarget as HTMLButtonElement;
        const angle = button.getAttribute('data-angle');
        const index = parseInt(button.getAttribute('data-index') || '0', 10);

        if (angle !== null) {
          const targetRotation = -parseInt(angle, 10);
          wheel.style.transform = `rotate(${targetRotation}deg)`;
          nodes.forEach(n => {
            (n as HTMLButtonElement).style.transform = `rotate(${-targetRotation}deg) translateX(-50%)`;
          });
          statusText.innerText = sections[index].name;
          indexText.innerText = `${sections[index].code} / 02`;
        }
      });
    });
  };
  initTacticalDial();
  document.addEventListener('astro:page-load', initTacticalDial);
</script>

<style>
  .dial-node { transform-origin: top left; }
</style>
'@

# =========================================================================
# 2. Secuencia de Ejecución y Sanitización Completa del Entorno
# =========================================================================
Clear-Host
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host "     JAKO-CORE ECOSYSTEM AUTOWRITER      " -ForegroundColor Cyan
Write-Host "=========================================" -ForegroundColor Cyan

# [PASO 1]: Purga completa de configuraciones anteriores y estados corruptos
Write-Host "`n[1/4] Ejecutando purga e higienización estructural..." -ForegroundColor Yellow
$DirsToPurge = @("src/layouts", "src/pages", "src/components")
foreach ($Dir in $DirsToPurge) {
    if (Test-Path $Dir) {
        Remove-Item -Path $Dir -Recurse -Force | Out-Null
        Write-Host "✔ Removido directorio previo: $Dir" -ForegroundColor DarkGray
    }
}

# Re-mapeo limpio de carpetas
foreach ($Dir in $DirsToPurge) {
    New-Item -ItemType Directory -Path $Dir -Force | Out-Null
    Write-Host "✔ Directorio creado en limpio: $Dir" -ForegroundColor Green
}

# [PASO 2]: Auditoría y restauración de Archivos de Infraestructura
Write-Host "`n[2/4] Auditando archivos de configuración raíz (.json)..." -ForegroundColor Yellow
[System.IO.File]::WriteAllText((Get-Item .).FullName + "/package.json", $PackageJsonCode)
Write-Host "✔ package.json restaurado con scripts estables de Astro." -ForegroundColor Green

# Sobrescribir siempre con la configuración robusta anti-errores
[System.IO.File]::WriteAllText((Get-Item .).FullName + "/tsconfig.json", $TsConfigCode)
Write-Host "✔ tsconfig.json alineado y optimizado sin conflictos de tipo." -ForegroundColor Green

# =========================================================================
# 3. Inyección Limpia de Componentes del Ecosistema HUD
# =========================================================================
Write-Host "`n[3/4] Inyectando archivos de componentes del HUD..." -ForegroundColor Yellow

$FilesToProcess = @{
    "src/layouts/VaultLayout.astro"     = $LayoutCode
    "src/pages/index.astro"             = $IndexCode
    "src/components/QuantumBg.astro"    = $QuantumBgCode
    "src/components/HeaderHud.astro"    = $HeaderHudCode
    "src/components/FooterHud.astro"    = $FooterHudCode
    "src/components/TacticalDial.astro"  = $TacticalDialCode
}

foreach ($File in $FilesToProcess.Keys) {
    [System.IO.File]::WriteAllText((Get-Item .).FullName + "/" + $File, $FilesToProcess[$File])
    Write-Host "✔ Archivo aprovisionado: $File" -ForegroundColor Green
}

# =========================================================================
# 4. Verificación de Módulos y Lanzamiento Multiplataforma
# =========================================================================
Write-Host "`n[4/4] Verificando dependencias e iniciando servidor..." -ForegroundColor Yellow

# Resolución de rutas unificada e infalible mediante Join-Path nativo
$AstroCliPath = Join-Path (Join-Path "node_modules" "astro") "package.json"

if (-not (Test-Path $AstroCliPath)) {
    Write-Host "⚠️ No se detectaron los módulos locales estables. Forzando instalación aséptica..." -ForegroundColor Magenta
    npm install
} else {
    Write-Host "✔ Módulos verificados. Saltando instalación para acelerar el despliegue." -ForegroundColor Green
}

Write-Host "Invocando directamente al CLI local de Astro..." -ForegroundColor Gray
Write-Host "--------------------------------------------------------" -ForegroundColor Gray

try {
    npx --no-install astro dev
}
catch {
    Write-Host "`n❌ Proceso de ejecución finalizado." -ForegroundColor Red
}