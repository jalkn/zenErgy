import streamlit as st
import json
import os
import pandas as pd
from datetime import datetime

# Technical Configuration for Scientific Rigor
st.set_page_config(page_title="Z-ARPA | Lab Auditor", page_icon="🛡️", layout="wide")

st.markdown("""
    <style>
    body { background-color: #0a0a0a; color: #f4f4f4; }
    .stMetric { border-bottom: 1px solid #3b82f6; }
    </style>
    """, unsafe_allow_html=True)

st.title("🛡️ Z-ARPA: Laboratory & Resonance Auditor")

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

# --- Navigation Architecture ---
module_select = st.sidebar.radio("Select Active Module", ["Substrate Audit (Amero)", "Media Formulation (Agar)"])

if module_select == "Substrate Audit (Amero)":
    st.header("🔬 Substrate Audit: Quality Sorting & Biomass Yield")
    with st.form("lab_entry"):
        col1, col2, col3 = st.columns(3)
        with col1:
            batch_id = st.text_input("Batch ID", value=f"AMERO_{datetime.now().strftime('%m%d_%H%M')}")
            dry_method = st.selectbox("Dehydration Method", ["Direct Solar", "Controlled Thermal (35°C)", "Hybrid"])
            total_raw_weight = st.number_input("Total Sack Input Weight (g)", min_value=0.0)
        with col2:
            matrix_topology = st.selectbox("Matrix Topology", ["1x1cm Fragmented Grid", "Continuous Longitudinal Strips"])
            useful_dry_weight = st.number_input("Accepted Clean Fiber Weight (g)", min_value=0.0)
            rejected_weight = st.number_input("Rejected Material Weight (g)", min_value=0.0)
        with col3:
            active_dial = st.text_input("Z-Dial Resonance")
            resonance_root = st.number_input("Daily Root", min_value=1, max_value=9)
            est_moisture = st.number_input("Estimated Final Moisture (%)", value=12.0)

        uploaded_file = st.file_uploader("Upload Substrate Quality Photo", type=['jpg', 'jpeg', 'png'])
        contamination_risk = st.select_slider("Observed Raw Contamination Hazard", options=["None", "Low", "Medium", "High"])
        notes = st.text_area("Observations (Sack status, leaf stains, cloud index)")
        
        if st.form_submit_button("Execute Quality Audit"):
            img_path = f"data/img/{batch_id}.jpg" if uploaded_file else "None"
            if uploaded_file and not os.path.exists('data/img'): os.makedirs('data/img')
            if uploaded_file:
                with open(img_path, "wb") as f: f.write(uploaded_file.getbuffer())
            
            total_processed = useful_dry_weight + rejected_weight
            rejection_rate = (rejected_weight / total_processed * 100) if total_processed > 0 else 0.0
            efficiency = (useful_dry_weight / total_processed * 100) if total_processed > 0 else 0.0

            entry = {
                "timestamp": datetime.now().isoformat(),
                "type": "SUBSTRATE",
                "batch_id": batch_id,
                "method": dry_method,
                "topology": matrix_topology,
                "raw_input_g": total_raw_weight,
                "accepted_clean_g": useful_dry_weight,
                "rejected_dirty_g": rejected_weight,
                "rejection_rate_pct": round(rejection_rate, 2),
                "process_efficiency_pct": round(efficiency, 2),
                "hazard_rating": contamination_risk,
                "moisture_pct": est_moisture,
                "resonance": active_dial,
                "root": resonance_root,
                "image_ref": img_path,
                "status": "QC_PASSED" if est_moisture <= 15.0 and rejection_rate < 30.0 else "QC_WARNING"
            }
            save_log(entry)
            st.success(f"Substrate Audit Logged: {batch_id} ({efficiency}% Clean Yield)")

elif module_select == "Media Formulation (Agar)":
    st.header("🧬 Media Formulation & Batch Rectification")
    
    is_rectification = st.checkbox("Is this a Batch Rectification? (Re-cooking a liquid agar error)")
    
    with st.form("agar_entry"):
        col1, col2, col3 = st.columns(3)
        with col1:
            media_id = st.text_input("Media Batch ID", value=f"AGAR_{datetime.now().strftime('%m%d_%H%M')}")
            water_source = st.selectbox("Water Base Source", ["Pure Distilled", "Amero Decoction Extract", "Filtered Spring"])
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
            parent_batch_error = st.text_input("Parent Batch ID (If rectification)", value="None")
        with col5:
            sterilization_psi = st.number_input("Sterilization Pressure (PSI)", value=15.0)
            chlorella_mix_temp = st.number_input("Chlorella Addition Temp (°C)", value=60.0)

        notes = st.text_area("Media Prep Notes (Agar correction notes or consistency shifts)")
        
        if st.form_submit_button("Log Media Metrics"):
            temp_safeguard = "SAFE" if chlorella_mix_temp <= 65.0 else "NUTRIENT_DENATURED_RISK"
            
            entry = {
                "timestamp": datetime.now().isoformat(),
                "type": "MEDIA_RECTIFIED" if is_rectification else "MEDIA_BASE",
                "batch_id": media_id,
                "parent_batch": parent_batch_error,
                "water_source": water_source,
                "water_vol_ml": water_volume,
                "agar_g": agar_mass,
                "honey_g": honey_mass,
                "chlorella_g": chlorella_mass,
                "containers": container_count,
                "vol_per_container_ml": vol_per_container,
                "psi": sterilization_psi,
                "duration_min": sterilization_time,
                "strain": target_strain,
                "mix_temp_c": chlorella_mix_temp,
                "thermal_status": temp_safeguard,
                "status": "RECTIFIED_AND_STERILIZED" if is_rectification else "STERILIZED_READY"
            }
            save_log(entry)
            st.success(f"Logged Batch {media_id}. Status: {entry['status']} | Safeguard: {temp_safeguard}")

# --- Unified Data Engine View ---
db = load_data()
if db:
    st.subheader("📜 Comprehensive Laboratory Ledger")
    st.dataframe(pd.DataFrame(db).sort_values(by="timestamp", ascending=False), use_container_width=True)