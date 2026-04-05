import streamlit as st
import pandas as pd
from datetime import datetime
from PIL import Image
import os

# Configuración con la identidad visual de Zenergy
st.set_page_config(
    page_title="Z-Box Data Science",
    page_icon="🍄",
    layout="wide"
)

# Estilo personalizado para igualar tu landing page
st.markdown(f"""
    <style>
    .stApp {{ background-color: #0a0a0a; color: #f4f4f4; }}
    h1, h2, h3 {{ color: #13d47e !important; font-family: 'Space Grotesk', sans-serif; }}
    .stButton>button {{
        background-color: #13d47e;
        color: black;
        font-weight: bold;
        border-radius: 10px;
        border: none;
    }}
    </style>
    """, unsafe_allow_timezone=True)

# Definición de rutas para el monorepo
DATA_PATH = "zbox-app/data/bitacora_zbox.csv"
PHOTO_DIR = "zbox-app/data/fotos/"

if not os.path.exists(PHOTO_DIR):
    os.makedirs(PHOTO_DIR)

st.title("🍄 Z-Box: Bio-Hardware Inteligente")
st.subheader("Sistema de Registro y Análisis de Sustratos - Santa Elena")

# --- FORMULARIO DE REGISTRO ---
with st.expander("📝 Registrar Nuevo Lote de Sustrato", expanded=True):
    with st.form("registro_zbox"):
        c1, c2, c3 = st.columns(3)
        
        with c1:
            id_lote = st.text_input("ID del Lote", placeholder="Ej: ML-001")
            hongo = st.selectbox("Especie", ["Melena de León", "Reishi", "Orellana", "Cordyceps"])
            fecha = st.date_input("Fecha", datetime.now())
        
        with c2:
            corte = st.slider("Tamaño del corte (mm)", 5, 20, 10)
            secado = st.radio("Método de Secado", ["Sombra (Blanco)", "Sol (Café)", "Ventilación Forzada"])
            peso = st.number_input("Peso Seco (g)", value=13.0, step=0.1)
            
        with c3:
            chlorella = st.number_input("Chlorella (ml)", value=100)
            nevera = st.number_input("Horas Nevera", value=10)
            lc = st.number_input("Inóculo Líquido (ml)", value=7)

        foto = st.file_uploader("Cargar foto del sustrato/tubular", type=["jpg", "png", "jpeg"])
        notas = st.text_area("Notas técnicas (Ej: pH, textura, ventilación)")
        
        btn_guardar = st.form_submit_button("GUARDAR EN BITÁCORA")

if btn_guardar:
    # Procesar foto si existe
    foto_nombre = "N/A"
    if foto:
        foto_nombre = f"{id_lote}_{datetime.now().strftime('%Y%m%d')}.jpg"
        img = Image.open(foto)
        img.save(os.path.join(PHOTO_DIR, foto_nombre))

    nuevo_registro = {
        "ID": id_lote,
        "Fecha": fecha,
        "Hongo": hongo,
        "Corte_mm": corte,
        "Secado": secado,
        "Peso_g": peso,
        "Chlorella_ml": chlorella,
        "Nevera_h": nevera,
        "LC_ml": lc,
        "Foto": foto_nombre,
        "Notas": notas
    }

    df = pd.DataFrame([nuevo_registro])
    header = not os.path.exists(DATA_PATH)
    df.to_csv(DATA_PATH, mode='a', index=False, header=header)
    st.success(f"✅ Datos del lote {id_lote} sincronizados.")

# --- VISUALIZACIÓN Y CIENCIA DE DATOS ---
st.markdown("---")
st.header("📊 Análisis de Eficiencia")

if os.path.exists(DATA_PATH):
    df_history = pd.read_csv(DATA_PATH)
    
    tab1, tab2 = st.tabs(["📈 Tendencias", "📋 Historial Completo"])
    
    with tab1:
        col_a, col_b = st.columns(2)
        # Gráfico: Distribución de métodos de secado vs Peso
        with col_a:
            st.write("Distribución de Pesos por Método")
            st.bar_chart(df_history, x="Secado", y="Peso_g")
        
        with col_b:
            st.write("Especies en Producción")
            st.line_chart(df_history["Hongo"].value_counts())

    with tab2:
        st.dataframe(df_history, use_container_width=True)
else:
    st.info("Esperando primer registro para iniciar análisis de datos.")