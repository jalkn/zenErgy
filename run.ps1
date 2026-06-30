$ErrorActionPreference = "Stop"

# =========================================================================
# 1. Purga de Seguridad y Destrucción de Caché Vieja
# =========================================================================
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host "     JAKO CORE - COMPILER ENGINE         " -ForegroundColor Cyan
Write-Host "=========================================" -ForegroundColor Cyan

Write-Host "`n[1/5] Ejecutando purga aséptica de caché anterior..." -ForegroundColor Magenta

$CachePaths = @(
    ".astro",
    "dist",
    "node_modules/.vite"
)

foreach ($Path in $CachePaths) {
    if (Test-Path $Path) {
        Write-Host "🧹 Eliminando residuos de: $Path" -ForegroundColor Gray
        Remove-Item -Path $Path -Recurse -Force -ErrorAction SilentlyContinue
    }
}
Write-Host "✔ Entorno de desarrollo completamente limpio." -ForegroundColor Green

# =========================================================================
# 2. Configuración de Estructuras de Código Base e Infraestructura
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

$TsConfigCode = @'
{
  "extends": "astro/tsconfigs/strict",
  "compilerOptions": {
    "target": "ESNext",
    "module": "ESNext",
    "moduleResolution": "Node",
    "resolveJsonModule": true,
    "isolatedModules": true,
    "noEmit": true,
    "strict": true,
    "allowJs": true,
    "checkJs": false,
    "jsx": "preserve",
    "baseUrl": "."
  },
  "include": ["src/**/*"]
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
<html lang="es">
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
        background-color: var(--jako-black);
        color: #e5e7eb;
        font-family: 'Orbitron', sans-serif; 
        letter-spacing: 0.05em;
        overflow: hidden;
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
import HeaderHud from '../components/HeaderHud.astro';
import TacticalDial from '../components/TacticalDial.astro';
import FooterHud from '../components/FooterHud.astro';
---

<VaultLayout title="JAKO VAULT">
  <div id="page-bg-overlay"></div>
  <div class="fixed inset-0 bg-gradient-to-b from-black/15 via-transparent to-black/25 z-0 pointer-events-none"></div>

  <main id="main-vault" class="w-screen h-screen flex flex-col relative overflow-hidden">
      <header class="fixed top-0 w-full z-50 bg-[#050508]/35 backdrop-blur-[30px] border-b border-white/5">
          <HeaderHud />
      </header>

      <div class="flex-1 w-full flex flex-col items-center justify-between p-4 sm:p-6 select-none relative z-10 overflow-hidden">
          <TacticalDial />
      </div>

      <footer id="dynamic-footer" class="fixed bottom-0 left-0 w-full z-30 bg-gradient-to-t from-black/90 via-black/75 to-transparent backdrop-blur-[30px] border-t border-white/5">
          <FooterHud />
      </footer>
  </main>
</VaultLayout>

<style is:global>
  #page-bg-overlay {
      position: fixed;
      inset: 0;
      background: radial-gradient(circle at 50% 30%, rgba(37, 99, 235, 0.22) 0%, rgba(15, 23, 42, 0.75) 60%, #030712 100%);
      z-index: -1;
  }
</style>
'@

$HeaderHudCode = @'
---
---
<div class="w-full flex flex-col">
  <div class="px-4 sm:px-8 grid grid-cols-3 items-center uppercase tracking-widest font-mono text-[11px] text-white/50 min-h-[65px] sm:min-h-[72px] select-none">
    <div class="justify-self-start flex items-center justify-center">
      <a href="https://jako.world" class="group flex items-center justify-center transition-all duration-300 focus:outline-none cursor-pointer">
        <img src="/img/back.png" alt="Back" class="h-[13px] sm:h-[15px] w-auto object-contain opacity-65 group-hover:opacity-100 transition-all duration-500 filter drop-shadow-[0_0_8px_rgba(255,255,255,0.6)]" />
      </a>
    </div>
    
    <div class="justify-self-center text-center tracking-[0.28em] font-black drop-shadow-[0_0_12px_rgba(255,255,255,0.45)] text-white text-[13px] sm:text-[15px]">
      <span>VAULT</span>
    </div>
    
    <div class="justify-self-end flex items-center justify-center">
      <a href="https://biorush.shop" class="group flex items-center justify-center transition-all duration-300 focus:outline-none cursor-pointer">
        <img src="/img/pace.png" alt="Pace" class="h-[13px] sm:h-[15px] w-auto object-contain opacity-65 group-hover:opacity-100 transition-all duration-500 filter drop-shadow-[0_0_8px_rgba(255,255,255,0.6)]" />
      </a>
    </div>
  </div>

  <div class="w-full h-[1px] bg-gradient-to-r from-transparent via-white/10 to-transparent"></div>

  <div class="w-full flex flex-col bg-white/[0.01]">
    <div class="w-full grid grid-cols-5 items-center justify-between px-4 sm:px-8 h-12 gap-1 sm:gap-4 text-center select-none">
      
      <div id="telemetry-sphere-idx-trigger" class="flex flex-col-reverse items-start text-left cursor-pointer hover:text-white text-white/60 transition-colors">
        <span class="text-[7.5px] sm:text-[8.5px] tracking-[0.2em] text-white/30 mt-0.5 uppercase font-mono">Esfera</span>
        <span id="telemetry-sphere-idx" class="font-mono tracking-[0.15em] text-[10px] sm:text-[12px] font-bold text-white/90">0000</span>
      </div>

      <div id="sub-sets-solar-trigger" class="flex flex-col-reverse items-center text-center cursor-pointer hover:text-white text-white/60 transition-colors">
        <span class="text-[7.5px] sm:text-[8.5px] tracking-[0.2em] text-white/30 mt-0.5 uppercase font-mono">Hz</span>
        <span id="sub-sets-solar" class="font-mono tracking-[0.15em] text-[10px] sm:text-[12px] font-bold text-white drop-shadow-[0_0_8px_rgba(255,255,255,0.4)]">0.00</span>
      </div>

      <div id="z-dial-trigger" class="flex flex-col-reverse items-center text-center cursor-pointer hover:text-white text-white/60 transition-colors">
        <span class="text-[7.5px] sm:text-[8.5px] tracking-[0.2em] text-white/30 mt-0.5 uppercase font-mono">Dial</span>
        <span id="z-dial-mirror" class="font-mono tracking-[0.15em] text-[10px] sm:text-[12px] font-black text-white drop-shadow-[0_0_10px_rgba(255,255,255,0.5)]">0PU0</span>
      </div>

      <div id="sub-reps-tension-trigger" class="flex flex-col-reverse items-center text-center cursor-pointer hover:text-white text-white/60 transition-colors">
        <span class="text-[7.5px] sm:text-[8.5px] tracking-[0.2em] text-white/30 mt-0.5 uppercase font-mono">Tensión</span>
        <span id="sub-reps-tension" class="font-mono tracking-[0.15em] text-[10px] sm:text-[12px] font-bold text-white drop-shadow-[0_0_8px_rgba(255,255,255,0.4)]">0.0</span>
      </div>

      <div id="telemetry-active-node-trigger" class="flex flex-col-reverse items-end text-right cursor-pointer hover:text-white text-white/60 transition-colors">
        <span class="text-[7.5px] sm:text-[8.5px] tracking-[0.2em] text-white/30 mt-0.5 uppercase font-mono">Nodos</span>
        <span id="telemetry-active-node" class="font-mono tracking-[0.15em] text-[10px] sm:text-[12px] font-bold text-white/90">0000</span>
      </div>

    </div>

    <div class="w-full flex items-center justify-center px-4 h-8 bg-black/20 border-t border-white/[0.02]">
      <span id="panel-telemetry-data-secondary" class="text-[8.5px] xs:text-[9.5px] sm:text-[10px] text-center tracking-[0.25em] sm:tracking-[0.35em] text-white/70 font-medium transition-all duration-300 whitespace-normal block leading-none uppercase select-none">
        LENGUAJE DE GOTA BIOCINÉTICA REGENERATIVA
      </span>
    </div>
  </div>
</div>
'@

$TacticalDialCode = @'
---
---
<div id="artepanel-pack-container" class="my-auto relative w-[68vw] h-[68vw] sm:w-[58vw] sm:h-[58vw] md:w-[35vh] md:h-[35vh] max-w-[350px] max-h-[350px] min-w-[210px] min-h-[210px] aspect-square shrink-0 drop-shadow-[0_25px_55px_rgba(0,0,0,0.95)] transition-all duration-300">
  <div class="w-full h-full relative overflow-hidden rounded-md bg-transparent">
    
    <img id="artepanel-pack-img-back" src="/img/surface.png" alt="Back" class="img-glow-transition absolute inset-0 w-full h-full object-cover opacity-0 pointer-events-none z-0" />
    <img id="artepanel-pack-img" src="/img/surface.png" alt="Front" class="img-glow-transition absolute inset-0 w-full h-full object-cover pointer-events-auto z-10" />
    <img id="artepanel-pack-img-raw" src="/img/surface.png" alt="Raw" class="img-glow-transition absolute inset-0 w-full h-full object-cover opacity-0 pointer-events-none z-[5]" />
    
    <div class="absolute inset-0 flex items-center justify-center p-0 z-20 pointer-events-none">
        <svg id="laser-vector-target" viewBox="0 0 400 400" class="w-full h-full fill-none stroke-white/25 stroke-[1.2] transition-all duration-500 origin-center">
            <defs>
                <path id="textPath-top" d="M 65,200 A 135,135 0 0,1 335,200" />
                <path id="textPath-bottom" d="M 65,200 A 135,135 0 0,0 335,200" />
            </defs>
            <g class="origin-center">
                <path d="M 90,90 L 310,90 L 90,310 L 310,310 Z" class="opacity-15 stroke-[1]" />
                <path d="M 90,90 Q 200,125 310,90" class="opacity-15 stroke-[1]" />
                <path d="M 90,310 Q 200,275 310,310" stroke-dasharray="3 3" class="opacity-15 stroke-[1]" />
                
                <text id="z-dial" x="200" y="218" text-anchor="middle" class="fill-white font-black text-[45px] tracking-[0.35em] font-sans">8PU10</text>
            </g>
            <g id="laser-text-group" class="opacity-0 transition-opacity duration-500">
                <text class="fill-white font-black text-[10px] tracking-[0.25em] uppercase transition-all duration-500">
                    <textPath id="laser-variant-title" href="#textPath-top" startOffset="50%" text-anchor="middle">MACROPULSOR FOCUS</textPath>
                </text>
                <text class="fill-white/60 font-black text-[10px] tracking-[0.25em] uppercase transition-all duration-500">
                    <textPath id="artepanel-description" href="#textPath-bottom" startOffset="50%" text-anchor="middle">Enfoque y claridad cognitiva</textPath>
                </text>
            </g>
        </svg>
    </div>
  </div>
</div>

<style is:global>
  .img-glow-transition {
      transition: filter 0.5s cubic-bezier(0.4, 0, 0.2, 1), opacity 0.5s ease, transform 0.5s cubic-bezier(0.4, 0, 0.2, 1);
      will-change: filter, transform;
  }
</style>
'@

$FooterHudCode = @'
---
---
<div class="w-full flex flex-col font-mono uppercase text-xs">
  <div class="w-full flex items-center justify-center px-4 h-8 bg-black/20">
      <span id="panel-telemetry-data" class="text-[8.5px] xs:text-[9.5px] sm:text-[10px] text-center tracking-[0.25em] sm:tracking-[0.35em] text-white/70 font-medium transition-all duration-300 whitespace-normal block leading-none uppercase select-none">
          (MODELO 1:1) COMPRAS TU PIEZA Y FINANCIAS OTRA PARA LA COMUNIDAD
      </span>
  </div>

  <div class="w-full h-[1px] bg-gradient-to-r from-transparent via-white/10 to-transparent"></div>

  <div class="w-full bg-white/[0.01]">
      <div class="w-full grid grid-cols-5 items-center justify-between px-4 sm:px-8 h-12 gap-1 sm:gap-4 text-center select-none">
          <div class="flex flex-col-reverse items-start text-left cursor-pointer hover:text-white text-white/60 transition-colors">
              <span class="text-[7.5px] sm:text-[8.5px] tracking-[0.2em] text-white/30 mt-0.5 uppercase font-mono">Medio</span>
              <span id="telemetry-product-media" class="font-mono tracking-[0.15em] text-[10px] sm:text-[12px] font-bold text-white/90">--</span>
          </div>
          <div class="flex flex-col-reverse items-center text-center cursor-pointer hover:text-white text-white/60 transition-colors">
              <span class="text-[7.5px] sm:text-[8.5px] tracking-[0.2em] text-white/30 mt-0.5 uppercase font-mono">Dim Cms</span>
              <span id="telemetry-product-dim" class="font-mono tracking-[0.15em] text-[10px] sm:text-[12px] font-bold text-white drop-shadow-[0_0_8px_rgba(255,255,255,0.4)]">--</span>
          </div>
          <div class="flex flex-col-reverse items-center text-center cursor-pointer hover:text-white text-white/60 transition-colors">
              <span class="text-[7.5px] sm:text-[8.5px] tracking-[0.2em] text-white/30 mt-0.5 uppercase font-mono">Precio</span>
              <span id="telemetry-product-price" class="font-mono tracking-[0.15em] text-[10px] sm:text-[12px] font-black text-white drop-shadow-[0_0_10px_rgba(255,255,255,0.5)]">--</span>
          </div>
          <div class="flex flex-col-reverse items-center text-center cursor-pointer hover:text-white text-white/60 transition-colors">
              <span class="text-[7.5px] sm:text-[8.5px] tracking-[0.2em] text-white/30 mt-0.5 uppercase font-mono">Rate</span>
              <span id="telemetry-product-rate" class="font-mono tracking-[0.15em] text-[10px] sm:text-[12px] font-bold text-white drop-shadow-[0_0_8px_rgba(255,255,255,0.4)]">--</span>
          </div>
          <div class="flex flex-col-reverse items-end text-right cursor-pointer hover:text-white text-white/60 transition-colors">
              <span class="text-[7.5px] sm:text-[8.5px] tracking-[0.2em] text-white/30 mt-0.5 uppercase font-mono">Dials</span>
              <span id="telemetry-product-dial" class="font-mono tracking-[0.15em] text-[10px] sm:text-[12px] font-bold text-white/90">--</span>
          </div>
      </div>
  </div>

  <div class="w-full h-[1px] bg-white/5"></div>

  <div class="w-full h-12 relative z-10">
      <div class="w-full grid grid-cols-[54px_54px_1fr_54px_54px] items-center h-full px-4 sm:px-8">
          <button id="btn-lock-telemetry" class="h-full w-full flex items-center justify-center hover:bg-white/[0.03] text-white/40 hover:text-white transition-all duration-300 focus:outline-none border-r border-white/5">
              <svg id="lock-icon" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor" class="w-4 h-4">
                  <path stroke-linecap="round" stroke-linejoin="round" d="M13.5 10.5V6.75a4.5 4.5 0 1 1 9 0v3.75M3.75 21.75h10.5a2.25 2.25 0 0 0 2.25-2.25v-6.75a2.25 2.25 0 0 0-2.25-2.25H3.75a2.25 2.25 0 0 0-2.25 2.25v6.75a2.25 2.25 0 0 0 2.25 2.25Z" />
              </svg>
          </button>
          <button id="btn-reveal-raw" class="h-full w-full flex items-center justify-center hover:bg-white/[0.03] text-white/40 hover:text-white transition-all duration-300 focus:outline-none border-r border-white/5">
              <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor" class="w-4 h-4">
                  <path stroke-linecap="round" stroke-linejoin="round" d="M12 9v3.75m9-.75a9 9 0 1 1-18 0 9 9 0 0 1 18 0Zm-9 3.75h.008v.008H12v-.008Z" />
              </svg>
          </button>
          <button id="btn-activar-nodo" class="h-full w-full bg-transparent hover:bg-white/[0.05] text-white/90 font-black text-[11px] tracking-[0.35em] transition-all duration-300 focus:outline-none">
              ACTIVAR NODE
          </button>
          <button id="btn-reveal-bio" class="h-full w-full flex items-center justify-center hover:bg-white/[0.03] text-white/40 hover:text-white transition-all duration-300 focus:outline-none border-l border-white/5">
              <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor" class="w-4 h-4">
                  <path stroke-linecap="round" stroke-linejoin="round" d="M2.036 12.322a1.012 1.012 0 0 1 0-.639C3.423 7.51 7.36 4.5 12 4.5c4.638 0 8.573 3.007 9.963 7.178.07.207.07.431 0 .639C20.577 16.49 16.64 19.5 12 19.5c-4.638 0-8.573-3.007-9.963-7.178Z" />
                  <path stroke-linecap="round" stroke-linejoin="round" d="M15 12a3 3 0 1 1-6 0 3 3 0 0 1 6 0Z" />
              </svg>
          </button>
          <button class="h-full w-full flex items-center justify-center hover:bg-white/[0.03] text-white/40 hover:text-white transition-all duration-300 focus:outline-none border-l border-white/5">
              <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor" class="w-4 h-4"><path stroke-linecap="round" stroke-linejoin="round" d="M9.594 3.94c.09-.542.56-.94 1.11-.94h2.593c.55 0 1.02.398 1.11.94l.213 1.281c.063.374.313.686.645.87.074.04.147.083.22.127.324.196.72.257 1.075.124l1.217-.456a1.125 1.125 0 0 1 1.37.49l1.296 2.247a1.125 1.125 0 0 1-.26 1.43l-1.003.767a1.123 1.123 0 0 0-.417 1.03c.004.074.006.148.006.222 0 .074-.002.148-.006.222a1.123 1.123 0 0 0 .417 1.03l1.003.767a1.125 1.125 0 0 1 .26 1.43l-1.296 2.247a1.125 1.125 0 0 1-1.37.49l-1.216-.456a1.125 1.125 0 0 0-1.075.124c-.073.044-.146.087-.22.128-.332.183-.582.495-.645.869l-.213 1.281c-.09.543-.56.94-1.11.94h-2.594c-.55 0-1.019-.398-1.11-.94l-.213-1.281a1.125 1.125 0 0 0-.646-.869c-.074-.041-.147-.084-.22-.129a1.125 1.125 0 0 0-1.075-.124l-1.216.456a1.125 1.125 0 0 1-1.37-.49l-1.296-2.247a1.125 1.125 0 0 1 .26-1.43l1.003-.767c.318-.243.483-.646.417-1.03a1.121 1.121 0 0 0-.006-.222c0-.074.002-.148.006-.222a1.122 1.122 0 0 0-.417-1.03l-1.003-.767a1.125 1.125 0 0 1-.26-1.43l1.296-2.247a1.125 1.125 0 0 1 1.37-.49l1.216.456c.356.133.751.072 1.076-.124.072-.044.146-.087.22-.128.332-.183.582-.495.646-.869L9.593 3.94Z" /></svg>
          </button>
      </div>
  </div>

  <div class="w-full h-[1px] bg-white/5"></div>

  <div class="w-full h-12 relative z-10 bg-black/20 p-1">
      <div class="w-full grid grid-cols-[1fr_1fr] gap-3 h-full px-4 sm:px-8">
          <div class="grid grid-cols-[32px_1fr_32px] gap-1 h-full w-full items-center">
              <button id="btn-stencil-prev" class="h-full text-white/20 hover:text-white/50 focus:outline-none font-bold">&lt;</button>
              <div id="menu-bio-STENCIL-holder" class="h-full w-full flex items-center justify-center select-none"></div>
              <button id="btn-stencil-next" class="h-full text-white/20 hover:text-white/50 focus:outline-none font-bold">&gt;</button>
          </div>
          <div class="grid grid-cols-[32px_1fr_32px] gap-1 h-full w-full items-center">
              <button id="btn-panel-prev" class="h-full text-white/20 hover:text-white/50 focus:outline-none font-bold">&lt;</button>
              <div id="menu-bio-PANEL-holder" class="h-full w-full flex items-center justify-center select-none"></div>
              <button id="btn-panel-next" class="h-full text-white/20 hover:text-white/50 focus:outline-none font-bold">&gt;</button>
          </div>
      </div>
  </div>

  <div class="w-full h-[1px] bg-white/5"></div>

  <div class="w-full h-11 relative z-10">
      <div class="w-full grid grid-cols-[54px_1fr_54px] items-center h-full px-4 sm:px-8 text-[8px] tracking-[0.4em]">
          <div class="h-full flex items-center justify-start border-r border-white/5">
              <a href="https://jako.world" class="group w-full h-full flex items-center justify-start hover:bg-white/[0.02] transition-all cursor-pointer"><img src="/img/back.png" alt="Back" class="w-3.5 h-3.5 object-contain opacity-30 group-hover:opacity-80" /></a>
          </div>    
          <div class="h-full flex items-center justify-center text-center font-bold text-white/20">
              <a href="https://jako.world" class="h-full w-full flex items-center justify-center hover:text-white/60 hover:bg-white/[0.005] transition-all">POWERED BY JAKO.WORLD</a>
          </div>
          <div class="h-full flex items-center justify-end border-l border-white/5">
              <a href="https://biorush.shop" class="group w-full h-full flex items-center justify-end hover:bg-white/[0.02] transition-all cursor-pointer"><img src="/img/pace.png" alt="Pace" class="w-3.5 h-3.5 object-contain opacity-30 group-hover:opacity-80" /></a>
          </div>
      </div>
  </div>
</div>

<script>
  const ARTEPANEL_DATABASE = {
      'STENCIL': {
          defaultVariant: '40X40',
          variants: {
              '25X25': { label: 'STENCIL 25X25', desc: 'Murales participativos y espacio táctico', price: '$12USD', id: 'ST-25X25', img: '/img/surface.png', imgBack: '/img/surface.png', imgRaw: '/img/surface.png', telemetry: { DIM: '25x25', MEDIA: 'STENCIL', DIAL: '⧗240', RATE: '$0.05USD' } },
              '40X40': { label: 'MICROSTENCIL FOCUS', desc: 'Optimización de enfoque y claridad cognitiva', price: '$29USD', id: 'ST-MICRO', img: '/img/surface.png', imgBack: '/img/surface.png', imgRaw: '/img/surface.png', telemetry: { DIM: '40x40', MEDIA: 'STENCIL', DIAL: '⧗240', RATE: '$0.05USD' } },
              '80X80': { label: 'MACROSTENCIL SURGE', desc: 'Expansión de masa crítica y vector de salto', price: '$125USD', id: 'ST-MACRO', img: '/img/surface.png', imgBack: '/img/surface.png', imgRaw: '/img/surface.png', telemetry: { DIM: '80x80', MEDIA: 'STENCIL', DIAL: '⧗2500', RATE: '$0.05USD' } }
          }
      },
      'PANEL': {
          defaultVariant: '20X20',
          variants: {
              '20X20': { label: 'PANEL 20X20', desc: 'Premium Inkjet ADH montado sobre MDF', price: '$12USD', id: 'FP-20X20', img: '/img/surface.png', imgBack: '/img/surface.png', imgRaw: '/img/surface.png', telemetry: { DIM: '20x20', MEDIA: 'MDF_PRINT', DIAL: '⧗240', RATE: '$0.05USD' } },
              '30X30': { label: 'PANEL 30X30', desc: 'Estructura equilibrada de galería contemporánea', price: '$29USD', id: 'FP-30X30', img: '/img/surface.png', imgBack: '/img/surface.png', imgRaw: '/img/surface.png', telemetry: { DIM: '30x30', MEDIA: 'MDF_PRINT', DIAL: '⧗576', RATE: '$0.05USD' } },
              '40X40': { label: 'PANEL 40X40', desc: 'Máxima densidad espacial para eje vertical', price: '$55USD', id: 'FP-40X40', img: '/img/surface.png', imgBack: '/img/surface.png', imgRaw: '/img/surface.png', telemetry: { DIM: '40x40', MEDIA: 'MDF_PRINT', DIAL: '⧗1100', RATE: '$0.05USD' } }
          }
      }
  };

  let activeCatalog = 'STENCIL';
  let activeVariant = '40X40';
  let isDialFrozen = false;
  let freezeTimeoutId: number | null = null;
  const phoneEndpoint = "573025333130";
  const VECTORS = ["P", "U", "L", "S", "PU", "UL", "LS", "SP", "PUL", "ULS", "LSP", "SPU"];
  
  const $ = (id: string) => document.getElementById(id);

  function aplicarModoVisual(modo: string) {
      const front = $('artepanel-pack-img'); const back = $('artepanel-pack-img-back'); const raw = $('artepanel-pack-img-raw'); const svg = $('laser-vector-target');
      if(!front || !back || !raw) return;
      [front, back, raw].forEach(el => el.style.opacity = '0');
      if (modo === 'front') { front.style.opacity = '1'; if (svg) { svg.style.opacity = '1'; svg.style.pointerEvents = 'auto'; } }
      else if (modo === 'back') { back.style.opacity = '1'; if (svg) { svg.style.opacity = '0'; svg.style.pointerEvents = 'none'; } }
      else if (modo === 'raw') { raw.style.opacity = '1'; if (svg) { svg.style.opacity = '0'; svg.style.pointerEvents = 'none'; } }
  }

  function syncUI() {
      const config = ARTEPANEL_DATABASE[activeCatalog as 'STENCIL'|'PANEL'].variants[activeVariant];
      const txtTitle = $('laser-variant-title'); const txtDesc = $('artepanel-description');
      const imgFront = $('artepanel-pack-img') as HTMLImageElement; const imgBack = $('artepanel-pack-img-back') as HTMLImageElement; const imgRaw = $('artepanel-pack-img-raw') as HTMLImageElement;

      if (txtTitle) txtTitle.textContent = config.label; if (txtDesc) txtDesc.textContent = config.desc;
      if (imgFront) imgFront.src = config.img; if (imgBack) imgBack.src = config.imgBack; if (imgRaw) imgRaw.src = config.imgRaw;

      $('telemetry-product-media')!.textContent = config.telemetry.MEDIA;
      $('telemetry-product-dim')!.textContent = config.telemetry.DIM;
      $('telemetry-product-price')!.textContent = config.price;
      $('telemetry-product-rate')!.textContent = config.telemetry.RATE;
      $('telemetry-product-dial')!.textContent = config.telemetry.DIAL;

      const textFluidClass = "text-[8px] xs:text-[9.5px] sm:text-[11px] tracking-[0.2em] sm:tracking-[0.35em] uppercase font-sans transition-all duration-300";
      ['STENCIL', 'PANEL'].forEach(item => {
          const el = $(`menu-bio-${item}`);
          if (el) {
              el.className = (item === activeCatalog) 
                  ? `cursor-pointer font-black h-full w-full flex items-center justify-center text-white bg-white/[0.07] rounded-lg border border-white/20 shadow-[inset_0_1px_3px_rgba(255,255,255,0.25)] ${textFluidClass}` 
                  : `cursor-pointer font-medium h-full w-full flex items-center justify-center text-white/20 bg-transparent rounded-lg hover:text-white/50 ${textFluidClass}`;
          }
      });
  }

  function toggleFreeze() {
      isDialFrozen = !isDialFrozen; const icon = $('lock-icon'); const textGroup = $('laser-text-group');
      if (isDialFrozen) {
          if (icon) icon.innerHTML = '<path stroke-linecap="round" stroke-linejoin="round" d="M16.5 10.5V6.75a4.5 4.5 0 1 0-9 0v3.75m-.75 11.25h10.5a2.25 2.25 0 0 0 2.25-2.25v-6.75a2.25 2.25 0 0 0-2.25-2.25H6.75a2.25 2.25 0 0 0-2.25 2.25v6.75a2.25 2.25 0 0 0 2.25 2.25Z" />';
          if (textGroup) textGroup.classList.remove('opacity-0');
          if (freezeTimeoutId) clearTimeout(freezeTimeoutId);
          freezeTimeoutId = window.setTimeout(() => { isDialFrozen = false; toggleFreeze(); }, 8000);
      } else {
          if (icon) icon.innerHTML = '<path stroke-linecap="round" stroke-linejoin="round" d="M13.5 10.5V6.75a4.5 4.5 0 1 1 9 0v3.75M3.75 21.75h10.5a2.25 2.25 0 0 0 2.25-2.25v-6.75a2.25 2.25 0 0 0-2.25-2.25H3.75a2.25 2.25 0 0 0-2.25 2.25v6.75a2.25 2.25 0 0 0 2.25 2.25Z" />';
          if (textGroup) textGroup.classList.add('opacity-0'); if (freezeTimeoutId) clearTimeout(freezeTimeoutId);
      }
  }

  function ciclarVariante(catalogo: 'STENCIL' | 'PANEL', direccion: number) {
      if(activeCatalog !== catalogo) { activeCatalog = catalogo; activeVariant = ARTEPANEL_DATABASE[catalogo].defaultVariant; }
      const variantes = Object.keys(ARTEPANEL_DATABASE[catalogo].variants);
      let idx = variantes.indexOf(activeVariant); idx = (idx + direccion + variantes.length) % variantes.length;
      activeVariant = variantes[idx]; syncUI();
  }

  function updateZ() {
      const now = new Date(); const sec = now.getSeconds(); const min = now.getMinutes();
      const epoch = new Date('2012-12-21T00:00:00Z');
      const totalSpheres = (Math.floor((now.getTime() - epoch.getTime()) / 86400000) * 4) + Math.floor(now.getHours() / 6);
      $('telemetry-sphere-idx')!.textContent = String(totalSpheres).padStart(4, '0');

      if (!isDialFrozen) {
          let sets = sec % 2 !== 0 ? Math.floor((now.getMilliseconds() / 1000) * 12) + 1 : Math.floor((min % 12) + 1);
          let reps = 13 - sets; let vec = VECTORS[(sec + sets) % VECTORS.length]; const coord = `${sets}${vec}${reps}`;
          $('z-dial')!.textContent = coord; $('z-dial-mirror')!.textContent = coord;
          $('sub-sets-solar')!.textContent = (0.05 + (sets / 240)).toFixed(3); $('sub-reps-tension')!.textContent = (14.2 + (reps * 0.8)).toFixed(1);
      }
      $('telemetry-active-node')!.textContent = String((now.getHours() * 3600) + (min * 60) + sec + 1).padStart(4, '0');
  }

  const bindEvents = () => {
      let modoActual = 'front';
      $('btn-reveal-bio')?.addEventListener('click', () => { modoActual = modoActual==='back'?'front':'back'; aplicarModoVisual(modoActual); });
      $('btn-reveal-raw')?.addEventListener('click', () => { modoActual = modoActual==='raw'?'front':'raw'; aplicarModoVisual(modoActual); });
      $('z-dial')?.addEventListener('click', (e) => { e.stopPropagation(); toggleFreeze(); });
      $('btn-lock-telemetry')?.addEventListener('click', toggleFreeze);

      $('btn-stencil-prev')?.addEventListener('click', () => ciclarVariante('STENCIL', -1));
      $('btn-stencil-next')?.addEventListener('click', () => ciclarVariante('STENCIL', 1));
      $('btn-panel-prev')?.addEventListener('click', () => ciclarVariante('PANEL', -1));
      $('btn-panel-next')?.addEventListener('click', () => ciclarVariante('PANEL', 1));

      $('menu-bio-STENCIL-holder')!.innerHTML = `<span id="menu-bio-STENCIL">STENCIL</span>`;
      $('menu-bio-PANEL-holder')!.innerHTML = `<span id="menu-bio-PANEL">PANEL</span>`;

      $('btn-activar-nodo')?.addEventListener('click', () => {
          const config = ARTEPANEL_DATABASE[activeCatalog as 'STENCIL'|'PANEL'].variants[activeVariant];
          const msg = `⚡ *ORDEN ARTEPANEL* ⚡\n\n• *Vector:* ${activeCatalog} ${activeVariant}\n• *ID:* \`${config.id}\`\n• *Matriz:* \`${$('z-dial')?.textContent}\``;
          window.open(`https://api.whatsapp.com/send?phone=${phoneEndpoint}&text=${encodeURIComponent(msg)}`, '_blank');
      });

      const PULS_MEANINGS: Record<string, string> = {
          'sub-sets-solar-trigger': "FRECUENCIA COAXIAL VIVA TIERRA-LUNA-SOL.",
          'sub-reps-tension-trigger': "COHESIÓN TENSIONAL Y MAGNETISMO GRAVITACIONAL.",
          'telemetry-sphere-idx-trigger': "MATRIZ CUÁNTICA. CICLO DE ESFERA.",
          'telemetry-active-node-trigger': "SATURACIÓN SINÁPTICA. NODOS ACUMULADOS REALES."
      };
      Object.keys(PULS_MEANINGS).forEach(id => {
          $(id)?.addEventListener('click', () => {
              $('panel-telemetry-data-secondary')!.textContent = PULS_MEANINGS[id];
              setTimeout(() => { $('panel-telemetry-data-secondary')!.textContent = "LENGUAJE DE GOTA BIOCINÉTICA REGENERATIVA"; }, 8000);
          });
      });

      setInterval(updateZ, 100); syncUI();
  };

  document.addEventListener('DOMContentLoaded', bindEvents);
  document.addEventListener('astro:page-load', bindEvents);
</script>
'@

# =========================================================================
# 3. Mapeo e Inyección Estructural en Espacio de Trabajo
# =========================================================================
Write-Host "`n[3/5] Generando mapa estructural de carpetas..." -ForegroundColor Yellow
$Dirs = @("src/layouts", "src/pages", "src/components")
foreach ($Dir in $Dirs) {
    if (-not (Test-Path $Dir)) {
        New-Item -ItemType Directory -Path $Dir -Force | Out-Null
    }
}
Write-Host "✔ Mapa de carpetas verificado." -ForegroundColor Green

Write-Host "`n[4/5] Re-inyectando componentes de última generación..." -ForegroundColor Yellow
$Files = @{
    "src/layouts/VaultLayout.astro"     = $LayoutCode
    "src/pages/index.astro"             = $IndexCode
    "src/components/HeaderHud.astro"    = $HeaderHudCode
    "src/components/FooterHud.astro"    = $FooterHudCode
    "src/components/TacticalDial.astro" = $TacticalDialCode
}

foreach ($File in $Files.Keys) {
    [System.IO.File]::WriteAllText((Get-Item .).FullName + "/" + $File, $Files[$File])
    Write-Host "✔ Componente inyectado de forma aséptica: $File" -ForegroundColor Green
}

# =========================================================================
# 4. Verificación de Módulos y Lanzamiento Multiplataforma
# =========================================================================
Write-Host "`n[5/5] Verificando entorno de ejecución local..." -ForegroundColor Yellow

$AstroCliPath = Join-Path (Join-Path "node_modules" "astro") "package.json"

if (-not (Test-Path $AstroCliPath)) {
    Write-Host "⚠️ Módulos no encontrados. Descargando dependencias de Node..." -ForegroundColor Magenta
    npm install
} else {
    Write-Host "✔ Entorno de módulos locales estable." -ForegroundColor Green
}

Write-Host "🔄 Sincronizando mapas dinámicos de TypeScript de Astro..." -ForegroundColor Cyan
npx astro sync

Write-Host "`nLanzando servidor de desarrollo en tiempo real..." -ForegroundColor Gray
Write-Host "--------------------------------------------------------" -ForegroundColor Gray

try {
    npx --no-install astro dev
}
catch {
    Write-Host "`n❌ Servidor finalizado de forma segura." -ForegroundColor Red
}