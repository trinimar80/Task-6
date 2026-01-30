import os
import time
import logging
import requests
from vault_client import obtener_credenciales_db  # Importamos tu configuracion de AppRole

# Configuración de Logging
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(levelname)s - %(message)s'
)

def main():
    logging.info("--- Iniciando Pinger Service (Tarea 6 - Vault AppRole) ---")
    
    while True:
        # Requisito: Obtener secretos ANTES de cada operación
        user, password = obtener_credenciales_db()
        
        if user and password:
            logging.info(f"✅ Secreto obtenido de Vault. Usuario DB: {user}")
            
            # Aquí ya puedes usar 'user' y 'password' para tu conexión a Postgres
            target_url = "https://google.com" 
            try:
                resp = requests.get(target_url, timeout=5)
                logging.info(f"PING {target_url} - Status: {resp.status_code}")
            except Exception as e:
                logging.error(f"Error en el ping: {e}")
        else:
            logging.error("❌ No se pudieron obtener las credenciales de Vault.")
        # Esperar 10 segundos antes de volver a consultar Vault
        time.sleep(10)

if __name__ == "__main__":
    main()