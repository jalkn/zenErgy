#!/bin/bash
set -e

# =========================================================================
# macOS Terminal Colors
# =========================================================================
CYAN='\033[0;36m'
MAGENTA='\033[0;35m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
GRAY='\033[0;90m'
NC='\033[0m' # No Color

echo -e "${CYAN}=========================================${NC}"
echo -e "${CYAN}     JAKO CORE - COMPILER ENGINE         ${NC}"
echo -e "${CYAN}=========================================${NC}"

# =========================================================================
# 1. Cache Purge
# =========================================================================
echo -e "\n${MAGENTA}[1/5] Executing aseptic purge of old cache...${NC}"
CACHE_PATHS=(".astro" "dist" "node_modules/.vite")
for path in "${CACHE_PATHS[@]}"; do
    if [ -d "$path" ]; then
        echo -e "${GRAY}🧹 Removing residues from: $path${NC}"
        rm -rf "$path"
    fi
done
echo -e "${GREEN}✔ Development environment completely clean.${NC}"

# =========================================================================
# 2. Base Infrastructure Configuration
# =========================================================================
echo -e "\n${YELLOW}[2/5] Verifying base configuration files...${NC}"

if [ ! -f "package.json" ]; then
    cat << 'JSON_EOF' > package.json
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
JSON_EOF
    echo -e "${GREEN}✔ package.json created successfully.${NC}"
fi

if [ ! -f "tsconfig.json" ]; then
    cat << 'TS_EOF' > tsconfig.json
{
  "extends": "astro/tsconfigs/strict"
}
TS_EOF
    echo -e "${GREEN}✔ tsconfig.json created successfully.${NC}"
fi

# =========================================================================
# 3. Component & Core Layout Injections
# =========================================================================
echo -e "\n${YELLOW}[3/5] Injecting ecosystem components aseptically...${NC}"
mkdir -p src/layouts src/pages src/components

# Layout Component Injection
cat << 'LAYOUT_EOF' > src/layouts/Layout.astro
---
interface Props {
	title: string;
}
const { title } = Astro.props;
---
<!DOCTYPE html>
<html lang="en">
	<head>
		<meta charset="UTF-8" />
		<meta name="viewport" content="width=device-width" />
		<link rel="icon" type="image/svg+xml" href="/favicon.svg" />
		<title>{title}</title>
	</head>
	<body class="bg-black text-white font-mono antialiased selection:bg-cyan-500 selection:text-black">
		<slot />
	</body>
</html>
LAYOUT_EOF
echo -e "${GREEN}✔ Component injected aseptically: src/layouts/Layout.astro${NC}"

# Index Page Injection
cat << 'INDEX_EOF' > src/pages/index.astro
---
import Layout from '../layouts/Layout.astro';
import HeaderHud from '../components/HeaderHud.astro';
import TacticalDial from '../components/TacticalDial.astro';
import FooterHud from '../components/FooterHud.astro';
---
<Layout title="Zenergia Core">
	<main class="min-h-screen flex flex-col justify-between p-4 relative overflow-hidden">
		<HeaderHud />
		<div class="flex-1 flex items-center justify-center my-8 z-10">
			<TacticalDial />
		</div>
		<FooterHud />
	</main>
</Layout>
INDEX_EOF
echo -e "${GREEN}✔ Component injected aseptically: src/pages/index.astro${NC}"

# Header HUD Injection
cat << 'HEADER_EOF' > src/components/HeaderHud.astro
---
---
<header class="w-full border-b border-zinc-800 p-4 flex justify-between items-center bg-black/50 backdrop-blur-md">
	<div class="flex items-center gap-3">
		<div class="w-3 h-3 rounded-full bg-cyan-500 animate-pulse"></div>
		<span class="tracking-widest text-xs uppercase font-bold text-zinc-400">System: Active</span>
	</div>
	<div class="text-right">
		<span class="text-cyan-400 text-xs tracking-wider uppercase font-bold">Zenergia Framework v3.5</span>
	</div>
</header>
HEADER_EOF
echo -e "${GREEN}✔ Component injected aseptically: src/components/HeaderHud.astro${NC}"

# Tactical Dial Injection
cat << 'DIAL_EOF' > src/components/TacticalDial.astro
---
---
<div class="relative w-80 h-80 flex items-center justify-center border border-zinc-800 rounded-full bg-zinc-950/30 backdrop-blur-sm">
	<div class="absolute inset-4 border border-dashed border-zinc-700 rounded-full animate-[spin_60s_linear_infinite]"></div>
	<div class="absolute inset-12 border border-cyan-500/30 rounded-full animate-[spin_20s_linear_infinite_reverse]"></div>
	<div class="text-center z-10">
		<h1 class="text-2xl font-black tracking-widest uppercase text-white mb-1">ZENERGIA</h1>
		<p class="text-[10px] tracking-[0.3em] uppercase text-cyan-400 font-bold">Tech-Lab Engine</p>
	</div>
</div>
DIAL_EOF
echo -e "${GREEN}✔ Component injected aseptically: src/components/TacticalDial.astro${NC}"

# Footer HUD Injection
cat << 'FOOTER_EOF' > src/components/FooterHud.astro
---
---
<footer class="w-full border-t border-zinc-800 p-4 flex justify-between items-center text-[10px] text-zinc-500 tracking-wider uppercase">
	<div>[ Location: Santa Elena, Med ]</div>
	<div class="animate-pulse text-cyan-500/80 font-bold">[ Core Engine Sync'd ]</div>
</footer>
FOOTER_EOF
echo -e "${GREEN}✔ Component injected aseptically: src/components/FooterHud.astro${NC}"

# =========================================================================
# 4. Environment Verification & Boot
# =========================================================================
echo -e "\n${YELLOW}[4/5] Verifying local execution environment...${NC}"

if [ ! -d "node_modules/astro" ]; then
    echo -e "${MAGENTA}⚠️ Modules not found. Downloading Node dependencies...${NC}"
    npm install
else
    echo -e "${GREEN}✔ Local modules environment stable.${NC}"
fi

echo -e "${CYAN}🔄 Synchronizing Astro dynamic TypeScript maps...${NC}"
npx astro sync

echo -e "\n${GRAY}Launching real-time development server...${NC}"
echo -e "${GRAY}--------------------------------------------------------${NC}"

npx --no-install astro dev
