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

st.title("🛡️ Z-ARPA: Laboratory Ledger & Solar Resonance Auditor")

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

def update_order_status(order_id, new_status):
    db = load_data()
    updated = False
    for entry in db:
        if entry.get("type") == "PULSOR_ORDER" and entry.get("order_id") == order_id:
            entry["status"] = new_status
            updated = True
            break
    if updated:
        with open('data/zenergia_db.json', 'w') as f:
            json.dump(db, f, indent=4)
    return updated

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

# --- Navigation Architecture ---
module_select = st.sidebar.radio("Select Active Module", [
    "Substrate Audit (Amero)", 
    "Media Formulation (Agar)", 
    "Capsule Packaging (Pulsor)",
    "Z-Dial Orders & Escrow (RWA)"
])

computed_solar_dial = calculate_z_dial_v8()

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
            active_dial = st.text_input("Z-Dial Resonance", value=computed_solar_dial)
            resonance_root = st.number_input("Daily Root", min_value=1, max_value=9, value=5)
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
    st.header("⚡ Adaptogen Packaging Ledger")
    st.metric(label="Calculated Solar Engine v8.0 Pulse", value=computed_solar_dial)
    
    adaptogen_select = st.selectbox("Active Adaptogen Node", ["Reishi", "Melena de Leon", "Cordyceps", "Cola de Pavo"])
    
    matrix_lotes = {
        "Reishi": ["REI_GRAIN_B01", "REI_GRAIN_B02", "REI_AMERO_EXT04"],
        "Melena de Leon": ["MDL_GRAIN_B01", "MDL_GRAIN_B02"],
        "Cordyceps": ["COR_BIOMASS_C01", "COR_BIOMASS_C02"],
        "Cola de Pavo": ["CDP_MATRIX_A01", "CDP_MATRIX_A02"]
    }
    lotes_disponibles = matrix_lotes.get(adaptogen_select, ["GENERIC_B_01"])

    with st.form("pulsor_entry"):
        col1, col2 = st.columns(2)
        with col1:
            pack_id = st.text_input("Package Batch ID", value=f"PULS_{datetime.now().strftime('%m%d_%H%M')}")
            cap_weight = st.number_input("Capsule Core Weight (mg)", value=500.0)
            parent_grain_batch = st.selectbox("Source Matrix Batch ID (Lote)", options=lotes_disponibles)
        with col2:
            final_dial = st.text_input("Active Z-Dial Code Validation (For Illustrator sync)", value=computed_solar_dial)
            unit_count = st.number_input("Units per Container", value=45)
            operator_sig = st.text_input("Operator Signature", value="JALKO")
            
        notes = st.text_area("Manufacturing notes (Traceability parameters)")
        
        if st.form_submit_button("Lock Manufacturing Cycle"):
            dial_target = final_dial if final_dial else computed_solar_dial
            entry = {
                "timestamp": datetime.now().isoformat(), "type": "ADAPTOGEN_PACK", "batch_id": pack_id, "adaptogen": adaptogen_select,
                "capsule_mg": cap_weight, "units": unit_count, "resonance_dial": dial_target.upper(), "parent_biomass": parent_grain_batch,
                "operator": operator_sig, "status": "BATCH_LOCKED_AUDITED"
            }
            save_log(entry)
            st.success(f"🚀 Lote {pack_id} guardado con trazabilidad amarrada a {parent_grain_batch}. Código Z-Dial para Illustrator: {dial_target.upper()}")

elif module_select == "Z-Dial Orders & Escrow (RWA)":
    st.header("📡 Z-Dial Ledger & Escrow Account (RWA Puente Genético)")
    st.subheader("Balances Globales de Bioconstrucción Colectiva")
    
    db = load_data()
    orders = [e for e in db if e.get("type") == "PULSOR_ORDER"]
    
    # 1. Processing User Balances (The Genetic Bridge Matrix)
    user_balances = {}
    for o in orders:
        if o.get("status") in ["PAID_LOCKED", "PENDING_PAYMENT"]:
            email = o.get("client_email")
            val = o.get("fraction_value", 1.0)
            if email not in user_balances:
                user_balances[email] = {"dials": 0.0, "whatsapp": o.get("client_whatsapp", "N/A")}
            # Only count fully paid tokens towards active RWA ownership
            if o.get("status") == "PAID_LOCKED":
                user_balances[email]["dials"] += val

    # Render metrics for total ecosystem participation
    total_active_dials = sum(u["dials"] for u in user_balances.values())
    total_bricks = total_active_dials / 50.0  # 50 Dials = 1 Solid Z-Brick
    
    c1, c2, c3 = st.columns(3)
    with c1: st.metric("Total Z-Dials Emitidos y Pagados", f"{total_active_dials} Units")
    with c2: st.metric("Pool de Bioladrillos Equivalentes (Z-Bricks)", f"{round(total_bricks, 2)} Bricks")
    with c3: st.metric("Mecenases Activos (Santa Elena Pool)", f"{len(user_balances)} Users")
    
    st.markdown("---")
    
    # 2. Manual Order Ingestion Simulator (Simulates incoming traffic from WhatsApp Webhook)
    with st.expander("🛠️ Ingestor Manual de Órdenes (Simulador de Entrada)"):
        with st.form("manual_order"):
            col_o1, col_o2 = st.columns(2)
            with col_o1:
                sim_email = st.text_input("Client Email", value="interesado@santaelena.art")
                sim_wa = st.text_input("WhatsApp Number", value="+573001234567")
                sim_node = st.selectbox("Product Node Variant", ["PULSOR FOCUS", "PULSOR ZEN", "PULSOR VITAL", "PULSOR ESCUDO"])
            with col_o2:
                sim_order_id = st.text_input("Order ID Hash", value=f"ORD_{datetime.now().strftime('%H%M%S')}")
                sim_dial = st.text_input("Captured Pulse Resonance", value=computed_solar_dial)
                sim_status = st.selectbox("Initial Escrow Status", ["PENDING_PAYMENT", "PAID_LOCKED"])
            
            if st.form_submit_button("Ingestar Orden al Ledger"):
                new_order = {
                    "timestamp": datetime.now().isoformat(), "type": "PULSOR_ORDER", "order_id": sim_order_id,
                    "client_email": sim_email, "client_whatsapp": sim_wa, "product_node": sim_node,
                    "resonance_dial": sim_dial.upper(), "fraction_value": 1.0, "z_brick_pool_participation": 0.02, "status": sim_status
                }
                save_log(new_order)
                st.success(f"Orden {sim_order_id} inyectada con éxito. Puente Genético actualizado.")
                st.rerun()

    # 3. Active Escrow Audit View
    st.subheader("📦 Órdenes en Custodia Temporal (Escrow)")
    if orders:
        df_orders = pd.DataFrame(orders).sort_values(by="timestamp", ascending=False)
        st.dataframe(df_orders, use_container_width=True)
        
        # Admin action zone to trigger laser vector preparation
        st.subheader("⚡ Auditoría de Estatus y Activación Industrial")
        pending_orders = [o["order_id"] for o in orders if o["status"] == "PENDING_PAYMENT"]
        
        if pending_orders:
            col_a1, col_a2 = st.columns([1, 2])
            with col_a1:
                target_ord = st.selectbox("Seleccionar Orden por Validar", pending_orders)
            with col_a2:
                st.write("") # Spacer
                if st.button("Aprobar Pago y Liberar Z-Dial para Grabado Láser"):
                    if update_order_status(target_ord, "PAID_LOCKED"):
                        st.success(f"Orden {target_ord} asegurada. Hash bloqueado en la base de datos.")
                        st.rerun()
        else:
            st.info("No hay órdenes pendientes de pago en este ciclo solar.")
    else:
        st.info("No se registran órdenes de Pulsors en el sistema de archivos actual.")

# --- Unified Data Engine View ---
db = load_data()
if db:
    st.subheader("📜 Comprehensive Laboratory Ledger")
    st.dataframe(pd.DataFrame(db).sort_values(by="timestamp", ascending=False), use_container_width=True)