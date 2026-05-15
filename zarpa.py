import streamlit as st
import json
import os
import pandas as pd
from datetime import datetime

st.set_page_config(page_title="Z-ARPA | Lab Auditor", page_icon="🛡️", layout="wide")

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

st.title("🛡️ Z-ARPA: Laboratory & Resonance Auditor")
st.header("🔬 Substrate Audit: Solar & Thermal Technification")

with st.form("lab_entry"):
    col1, col2, col3 = st.columns(3)
    with col1:
        batch_id = st.text_input("Batch ID", value=f"AMERO_{datetime.now().strftime('%m%d_%H%M')}")
        dry_method = st.selectbox("Dehydration Method", ["Direct Solar", "Controlled Thermal (35°C)", "Hybrid"])
        wet_weight = st.number_input("Initial Wet Weight (g)", min_value=0.0)
    with col2:
        initial_width = st.number_input("Fresh Slice Width (cm)", value=1.5, help="Width of the strip before drying")
        fiber_type = st.selectbox("Target Orientation", ["Longitudinal", "Fragmented Grid"])
        dry_weight = st.number_input("Final Dry Weight (g)", min_value=0.0)
    with col3:
        active_dial = st.text_input("Z-Dial Resonance")
        resonance_root = st.number_input("Daily Root", min_value=1, max_value=9)
        est_moisture = st.number_input("Estimated Final Moisture (%)", value=12.0)

    uploaded_file = st.file_uploader("Upload Substrate State Image", type=['jpg', 'jpeg', 'png'])
    notes = st.text_area("Observations (Shrinkage rate, fiber brittleness scale 1-5, cloud cover context)")
    
    if st.form_submit_button("Log Substrate Metrics"):
        img_path = f"data/img/{batch_id}.jpg" if uploaded_file else "None"
        if uploaded_file:
            if not os.path.exists('data/img'): os.makedirs('data/img')
            with open(img_path, "wb") as f: f.write(uploaded_file.getbuffer())

        # Data Science Metrics Calculations
        weight_loss = wet_weight - dry_weight if dry_weight > 0 else 0
        
        entry = {
            "timestamp": datetime.now().isoformat(),
            "batch_id": batch_id,
            "method": dry_method,
            "fresh_width_cm": initial_width,
            "wet_weight_g": wet_weight,
            "dry_weight_g": dry_weight,
            "water_lost_g": weight_loss,
            "moisture_pct": est_moisture,
            "fiber": fiber_type,
            "resonance": active_dial,
            "root": resonance_root,
            "image_ref": img_path,
            "status": "READY_FOR_AGAR" if est_moisture <= 15.0 and dry_weight > 0 else "DEHYDRATING"
        }
        save_log(entry)
        st.success(f"Batch {batch_id} logged via {dry_method}. Status: {entry['status']}")

# Render History Pipeline
db = load_data()
if db:
    st.subheader("📜 Material Lineage Ledger")
    st.dataframe(pd.DataFrame(db).sort_values(by="timestamp", ascending=False), use_container_width=True)