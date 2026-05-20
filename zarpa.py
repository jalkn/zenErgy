import streamlit as st
import json
import os
import pandas as pd
from datetime import datetime
import math

# Technical Configuration for Scientific Rigor
st.set_page_config(page_title="Z-ARPA | Lab Auditor", page_icon="🛡️", layout="wide")

st.markdown("""
    <style>
    body { background-color: #0a0a0a; color: #f4f4f4; }
    .stMetric { border-bottom: 1px solid #3b82f6; }
    </style>
    """, unsafe_allow_html=True)

st.title("🛡️ Z-ARPA: Laboratory Minimalist Label Engine")

def load_data():
    path = 'data/zenergia_db.json'
    if not os.path.exists('data'): os.makedirs('data')
    if os.path.exists(path):
        with open(path, 'r') as f: return json.load(f)
    return []

def save_log(entry):
    db = load_data()
    db.append(entry)
    with open('data/zenergia_db.json', 'w') as f:
        json.dump(db, f, indent=4)

def calculate_z_dial_v8():
    """Core Mathematical Replication of Z-Dial Engine v8.0"""
    now = datetime.now()
    hora = now.hour
    minuto = now.minute
    
    solar_angle = (hora * 15.0) + (minuto * 0.25)
    
    if 0.0 <= solar_angle < 180.0:
        factor_action = "PL"
        m_compress = 6
    elif 180.0 <= solar_angle < 270.0:
        factor_action = "ULS"
        m_compress = 9
    else:
        factor_action = "UP"
        m_compress = 6
        
    phi = 1.61803398875
    rondas = math.floor(((minuto + 1) * phi) % m_compress)
    if rondas == 0: rondas = 3
        
    repetitions = math.floor((abs(180.0 - solar_angle) % 18) + 6)
    return f"{rondas}{factor_action}{repetitions}"

def generate_minimalist_front_svg(batch_id, adaptogen_name, dial_string):
    """Generates an absolute minimalist front label based on the user's sleek reference mockup"""
    folder = "data/laser_output"
    if not os.path.exists(folder): os.makedirs(folder)
    filepath = f"{folder}/{batch_id}_FRONT_MINIMAL.svg"
    
    # Absolute Clean Canvas Layout: No borders, no lines, no technical footnote metrics.
    svg_content = f"""<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 460 180" width="120mm" height="50mm">
        <text x="30" y="45" font-family="'Courier New', monospace" font-size="14" fill="#ffffff" font-weight="bold" letter-spacing="3">{adaptogen_name.upper()}</text>
        <text x="430" y="45" font-family="'Courier New', monospace" font-size="14" fill="#ffffff" font-weight="bold" letter-spacing="1" text-anchor="end">ZENERGY.WORLD</text>
        
        <text x="50%" y="115" font-family="'Courier New', monospace" font-size="52" fill="#ffffff" font-weight="bold" letter-spacing="16" text-anchor="middle">{dial_string.upper()}</text>
    </svg>"""
    
    with open(filepath, "w", encoding="utf-8") as f:
        f.write(svg_content)
    return filepath

# --- Navigation Architecture ---
module_select = st.sidebar.radio("Select Active Module", [
    "Substrate Audit (Amero)", 
    "Media Formulation (Agar)", 
    "Capsule Packaging (Pulsor)"
])

if module_select == "Substrate Audit (Amero)":
    st.header("🔬 Substrate Audit: Quality Sorting & Biomass Yield")
    with st.form("lab_entry"):
        col1, col2, col3 = st.columns(3)
        with col1:
            batch_id = st.text_input("Batch ID", value=f"AMERO_{datetime.now().strftime('%m%d_%H%M')}")
            amero_provider = st.text_input("Amero Provider / Source", value="Plaza Rionegro")
            dry_method = st.selectbox("Dehydration Method", ["Direct Solar", "Controlled Thermal (35°C)", "Hybrid"])
        with col2:
            total_raw_weight = st.number_input("Total Sack Input Weight (g)", min_value=0.0)
            matrix_topology = st.selectbox("Matrix Topology", ["1x1cm Fragmented Grid", "Continuous Longitudinal Strips"])
            useful_dry_weight = st.number_input("Accepted Clean Fiber Weight (g)", min_value=0.0)
        with col3:
            rejected_weight = st.number_input("Rejected Material Weight (g)", min_value=0.0)
            active_dial = st.text_input("Z-Dial Resonance")
            resonance_root = st.number_input("Daily Root", min_value=1, max_value=9)
            est_moisture = st.number_input("Estimated Final Moisture (%)", value=12.0)

        uploaded_file = st.file_uploader("Upload Substrate Quality Photo", type=['jpg', 'jpeg', 'png'])
        contamination_risk = st.select_slider("Observed Raw Contamination Hazard", options=["None", "Low", "Medium", "High"])
        notes = st.text_area("Observations")
        
        if st.form_submit_button("Execute Quality Audit"):
            img_path = f"data/img/{batch_id}.jpg" if uploaded_file else "None"
            if uploaded_file and not os.path.exists('data/img'): os.makedirs('data/img')
            if uploaded_file:
                with open(img_path, "wb") as f: f.write(uploaded_file.getbuffer())
            
            total_processed = useful_dry_weight + rejected_weight
            rejection_rate = (rejected_weight / total_processed * 100) if total_processed > 0 else 0.0
            efficiency = (useful_dry_weight / total_processed * 100) if total_processed > 0 else 0.0

            entry = {
                "timestamp": datetime.now().isoformat(), "type": "SUBSTRATE", "batch_id": batch_id, "provider": amero_provider,
                "method": dry_method, "topology": matrix_topology, "raw_input_g": total_raw_weight, "accepted_clean_g": useful_dry_weight,
                "rejected_dirty_g": rejected_weight, "rejection_rate_pct": round(rejection_rate, 2), "process_efficiency_pct": round(efficiency, 2),
                "hazard_rating": contamination_risk, "moisture_pct": est_moisture, "resonance": active_dial, "root": resonance_root, "image_ref": img_path, "status": "QC_PASSED"
            }
            save_log(entry)
            st.success(f"Substrate Audit Logged: {batch_id}")

elif module_select == "Media Formulation (Agar)":
    st.header("🧬 Media Formulation & Batch Rectification")
    is_rectification = st.checkbox("Is this a Batch Rectification?")
    with st.form("agar_entry"):
        col1, col2, col3 = st.columns(3)
        with col1:
            media_id = st.text_input("Media Batch ID", value=f"AGAR_{datetime.now().strftime('%m%d_%H%M')}")
            water_source = st.selectbox("Water Base Source", ["Pure Distilled", "Amero Decoction Extract"])
            water_volume = st.number_input("Total Water Volume (ml)", value=600.0)
        with col2:
            agar_mass = st.number_input("Agar-Agar Mass Added (g)", value=12.0 if not is_rectification else 7.0)
            honey_mass = st.number_input("Pure Honey Mass (g)", value=12.0 if not is_rectification else 0.0)
            chlorella_mass = st.number_input("Chlorella Powder Mass (g)", value=2.4 if not is_rectification else 0.0)
        with col3:
            container_count = st.number_input("Number of Jars", value=3)
            vol_per_container = st.number_input("Volume per Jar (ml)", value=200.0)
            target_strain = st.text_input("Target Strain Lineage", value="Reishi")

        col4, col5 = st.columns(2)
        with col4:
            sterilization_time = st.number_input("Sterilization Duration (mins)", value=20 if not is_rectification else 15)
            parent_batch_error = st.text_input("Parent Batch ID", value="None")
        with col5:
            sterilization_psi = st.number_input("Sterilization Pressure (PSI)", value=15.0)
            chlorella_mix_temp = st.number_input("Chlorella Addition Temp (°C)", value=60.0)

        notes = st.text_area("Notes")
        if st.form_submit_button("Log Media Metrics"):
            entry = {
                "timestamp": datetime.now().isoformat(), "type": "MEDIA_BASE", "batch_id": media_id, "parent_batch": parent_batch_error,
                "water_source": water_source, "water_vol_ml": water_volume, "agar_g": agar_mass, "honey_g": honey_mass, "chlorella_g": chlorella_mass,
                "containers": container_count, "vol_per_container_ml": vol_per_container, "psi": sterilization_psi, "duration_min": sterilization_time,
                "strain": target_strain, "mix_temp_c": chlorella_mix_temp, "status": "STERILIZED_READY"
            }
            save_log(entry)
            st.success(f"Logged Batch {media_id}")

elif module_select == "Capsule Packaging (Pulsor)":
    st.header("⚡ Adaptogen Packaging & Minimalist Label Generator")
    
    computed_solar_dial = calculate_z_dial_v8()
    st.metric(label="Calculated Solar Engine v8.0 Pulse", value=computed_solar_dial)
    
    with st.form("pulsor_entry"):
        col1, col2 = st.columns(2)
        with col1:
            pack_id = st.text_input("Package Batch ID", value=f"PULS_{datetime.now().strftime('%m%d_%H%M')}")
            adaptogen_select = st.selectbox("Active Adaptogen Node", ["Reishi", "Melena de Leon", "Cordyceps", "Cola de Pavo"])
            cap_weight = st.number_input("Capsule Core Weight (mg)", value=500.0)
        with col2:
            final_dial = st.text_input("Active Z-Dial Code Validation", value=computed_solar_dial)
            unit_count = st.number_input("Units per Container", value=45)
            parent_grain_batch = st.text_input("Source Matrix Batch ID", value="REISHI_S_01")
            
        operator_sig = st.text_input("Operator Signature", value="JALKO")
        notes = st.text_area("Manufacturing notes")
        
        if st.form_submit_button("Lock Manufacturing Cycle & Export Minimal Front Label"):
            dial_target = final_dial if final_dial else computed_solar_dial
            svg_path = generate_minimalist_front_svg(pack_id, adaptogen_select, dial_target)
            
            entry = {
                "timestamp": datetime.now().isoformat(),
                "type": "ADAPTOGEN_PACK",
                "batch_id": pack_id,
                "adaptogen": adaptogen_select,
                "capsule_mg": cap_weight,
                "units": unit_count,
                "resonance_dial": dial_target.upper(),
                "parent_biomass": parent_grain_batch,
                "operator": operator_sig,
                "front_vector": svg_path,
                "status": "MINIMAL_LABEL_COMPILED"
            }
            save_log(entry)
            st.success("🚀 ¡Etiqueta Frontal Minimalista generada con éxito!")
            st.code(f"CLEAN DESIGN -> {svg_path}", language="bash")

# --- Unified Data Engine View ---
db = load_data()
if db:
    st.subheader("📜 Comprehensive Laboratory Ledger")
    st.dataframe(pd.DataFrame(db).sort_values(by="timestamp", ascending=False), use_container_width=True)