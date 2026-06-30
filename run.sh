#!/bin/bash
set -e

# =========================================================================
# macOS Terminal Colors
# =========================================================================
CYAN='\033;036m'
MAGENTA='\033;035m'
GREEN='\033;032m'
YELLOW='\033;033m'
GRAY='\033;090m'
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
		<meta name="viewport" content="width=device-width, initial-scale=1.0" />
		<link rel="icon" type="image/svg+xml" href="/favicon.svg" />
		<title>{title}</title>
	</head>
	<body class="bg-slate-950 text-white font-mono antialiased selection:bg-white selection:text-black">
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
<Layout title="Zenergia Vault">
	<main class="min-h-screen flex flex-col justify-between p-4 relative overflow-hidden bg-[radial-gradient(circle_at_center,rgba(3,7,18,1)_0%,rgba(5,5,8,1)_100%)]">
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
<header class="w-full border-b border-white/[0.05] p-4 flex justify-between items-center bg-black/40 backdrop-blur-md">
	<div class="flex items-center gap-3">
		<div class="w-2 h-2 rounded-full bg-white animate-pulse"></div>
		<span class="tracking-[0.3em] text-[9px] uppercase font-bold text-white/50">System: Active</span>
	</div>
	<div class="text-right">
		<span class="text-white text-[9px] tracking-[0.25em] uppercase font-black">Zenergia Core v3.5</span>
	</div>
</header>
HEADER_EOF
echo -e "${GREEN}✔ Component injected aseptically: src/components/HeaderHud.astro${NC}"

# Tactical Dial Injection (Quantum Engine Base-12 placeholders)
cat << 'DIAL_EOF' > src/components/TacticalDial.astro
---
---
<div class="relative w-80 h-80 flex items-center justify-center border border-white/[0.05] rounded-full bg-black/20 backdrop-blur-xl shadow-[inset_0_0_40px_rgba(255,255,255,0.02)]">
	<div class="absolute inset-4 border border-dashed border-white/10 rounded-full animate-[spin_120s_linear_infinite]"></div>
	<div class="absolute inset-12 border border-white/5 rounded-full animate-[spin_40s_linear_infinite_reverse]"></div>
	<div class="text-center z-10 select-none">
		<h1 class="text-xl font-black tracking-[0.4em] uppercase text-white mb-1">ZENERGIA</h1>
		<p class="text-[8px] tracking-[0.3em] uppercase text-white/40 font-bold">Quantum Matrix</p>
	</div>
</div>
DIAL_EOF
echo -e "${GREEN}✔ Component injected aseptically: src/components/TacticalDial.astro${NC}"

# Footer HUD Injection
cat << 'FOOTER_EOF' > src/components/FooterHud.astro
---
---
<footer class="w-full border-t border-white/[0.05] p-4 flex justify-between items-center text-[8px] text-white/40 tracking-[0.2em] uppercase">
	<div>[ Location: Santa Elena ]</div>
	<a href="https://wa.me/message/ARPA" class="hover:text-white transition-colors duration-300 font-bold tracking-[0.3em] text-white/60">[ Connect via WhatsApp ]</a>
</footer>
FOOTER_EOF
echo -e "${GREEN}✔ Component injected aseptically: src/components/FooterHud.astro${NC}"

# =========================================================================
# 4. Environment Verification & Compilation
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

echo -e "\n${CYAN}[5/5] Compiling Quantum Clock for Production Build...${NC}"
npx astro build

# =========================================================================
# 5. Production Live Cloud Deployment
# =========================================================================
echo -e "\n${MAGENTA}🚀 Synchronizing clean assets directly to Google Cloud Storage...${NC}"
gsutil -m rsync -R dist gs://vault.jako.world

echo -e "\n${GREEN}========================================================${NC}"
echo -e "${GREEN}✔ SYSTEM LIVE ON PRODUCTION CLOUD ARCHITECTURE${NC}"
echo -e "${GREEN}🔗 Link: https://storage.googleapis.com/vault.jako.world/index.html${NC}"
echo -e "${GREEN}========================================================${NC}"
