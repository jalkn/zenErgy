# Definir variables de estructura
$rootDir = "."
$zboxDir = "zbox-app"
$dataDir = "$zboxDir\data"

Write-Host "Configurando el ecosistema de Zenergy..." -ForegroundColor Cyan

# Crear carpetas
New-Item -ItemType Directory -Force -Path $dataDir | Out-Null
New-Item -ItemType Directory -Force -Path "img" | Out-Null

# Crear o vaciar el archivo de protocolo FastAPI
$fastApiFile = "zbox_protocol.py"
@'
from fastapi import FastAPI, HTTPException, status
from pydantic import BaseModel, Field
from typing import Dict, Any, Optional
from datetime import datetime
import math

app = FastAPI(
    title="Zenergy Z-Box 60x40 API",
    version="1.0.0-beta",
    description="Ecosistema de control asíncrono y encriptación biocinética"
)

class SensorData(BaseModel):
    temperature: float = Field(..., description="Temperatura interna en °C")
    humidity: float = Field(..., description="Humedad relativa en %")
    co2_ppm: float = Field(..., description="Nivel de CO2 en ppm")
    resonance_phase: bool = Field(..., description="Estado de resonancia booleana H interseca T")

class BioLandArtSeed(BaseModel):
    batch_id: str
    seed_type: str
    rotation_angle: int = Field(..., ge=0, le=360, description="Sistema de rotación de 90°")
    mass_g: float

class BiokineticEngine:
    def __init__(self, node_id: str):
        self.node_id = node_id
    
    def calculate_intersection(self, h: float, t: float, h_min: float, t_max: float) -> bool:
        return h >= h_min and t <= t_max

    def compose_state(self, action: str, response: str) -> str:
        return f"{action} -> {response}"

    def get_geometry_state(self, angle: int) -> Dict[str, Any]:
        is_valid_angle = angle % 90 == 0
        return {
            "angle": angle,
            "normalized_angle": angle / 360,
            "render_in_4k": is_valid_angle,
            "geometry_type": "semicircle_inclusion" if is_valid_angle else "unaligned"
        }

engine = BiokineticEngine(node_id="Z-BOX-60x40-01")

@app.post("/api/v1/telemetry", status_code=status.HTTP_201_CREATED)
async def process_telemetry(data: SensorData):
    is_in_resonance = engine.calculate_intersection(data.humidity, data.temperature, 85.0, 24.0)
    if not is_in_resonance:
        return {
            "status": "out_of_phase",
            "message": "Composición de resonancia no alcanzada. Comprobando vectores."
        }
    return {
        "status": "in_resonance",
        "timestamp": datetime.utcnow().isoformat(),
        "composition_result": engine.compose_state("Ventilacion Forzada", "Resonancia Biológica Validada")
    }

@app.post("/api/v1/seed_art", status_code=status.HTTP_201_CREATED)
async def register_seed(seed: BioLandArtSeed):
    geom_data = engine.get_geometry_state(seed.rotation_angle)
    if not geom_data["render_in_4k"]:
        raise HTTPException(
            status_code=400, 
            detail="El ángulo del huevo semilla no cumple con la geometría de rotación funcional (múltiplos de 90°)."
        )
    return {
        "batch_id": seed.batch_id,
        "geometry_metadata": geom_data,
        "biokinetic_hash": f"zenergy_hash_{hash(seed.batch_id)}",
        "saved": True
    }
'@ | Set-Content $fastApiFile -Encoding utf8

Write-Host "Ecosistema inicializado correctamente." -ForegroundColor Green
Write-Host "Para correr el protocolo ejecuta: uvicorn zbox_protocol:app --reload" -ForegroundColor Yellow