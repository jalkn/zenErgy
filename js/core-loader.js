// Motor de Inyección Dinámica y Telemetría Unificada // ZENERGIA 2026
document.addEventListener("DOMContentLoaded", () => {
    
    // 1. Inyectar Barra de Navegación con Estilo Original
    const navContainer = document.getElementById("global-nav");
    if (navContainer) {
        fetch("components/nav.html")
            .then(response => response.text())
            .then(html => {
                navContainer.innerHTML = html;
                // Inicialización inmediata de la matriz matemática sobre el contenedor inyectado
                updateZ();
                setInterval(updateZ, 60000); // Bucle de refresco de 1 minuto por deriva solar
            })
            .catch(err => console.error("[-] Error cargando nav component:", err));
    }

    // 2. Inyectar Pie de Página Monocromático
    const footerContainer = document.getElementById("global-footer");
    if (footerContainer) {
        fetch("components/footer.html")
            .then(response => response.text())
            .then(html => {
                footerContainer.innerHTML = html;
            })
            .catch(err => console.error("[-] Error cargando footer component:", err));
    }
});

/**
* Z-Dial Resonance Engine v8.8 - Solar Drift Matrix & PULS Protocol Sync
* Lógica matemática original intacta y unificada globalmente
*/
const PHI = 1.618033;
const $ = (id) => document.getElementById(id);

function updateZ() {
    const now = new Date();
    
    // 1. Deriva Solar Absoluta (Ángulo de rotación de la Tierra en 24h: 0° a 359.9°)
    const deg = (now.getHours() * 15) + (now.getMinutes() * 0.25);
    
    // 2. Mapeo de Transiciones Kinéticas por Cuadrante (PULS Protocol)
    let f, translation;
    
    if (deg >= 0 && deg < 180) { 
        f = 'PL'; 
        translation = 'pace // lift';
    } else if (deg >= 180 && deg < 270) { 
        f = 'ULS'; 
        translation = 'under // lift // surge';
    } else { 
        f = 'UP'; 
        translation = 'under // pace';
    }

    // 3. Parámetros Biokinéticos Puros mediante PHI
    const s = Math.floor(((now.getMinutes() + 1) * PHI) % (f.length > 2 ? 6 : 9)) || 2;
    let reps = Math.floor((Math.abs(180 - deg) % 18) + 6); 

    // 4. Compilación del Sello Alfanumérico
    const res = `${s}${f}${reps}`;
    
    // 5. Inyección en los contenedores activos del ecosistema
    if ($('big-dial')) $('big-dial').textContent = res;
    if ($('z-dial')) $('z-dial').innerText = res;
    if ($('hologram-dial')) $('hologram-dial').innerText = res;
    
    // 6. Inyección de Explicación Conceptual
    if ($('protocol-desc')) {
        $('protocol-desc').innerHTML = `
            • Beneficio: Sincronización bio-adaptógena + Reflejo activo del Ave
        `;
    }
}