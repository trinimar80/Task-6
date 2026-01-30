import hvac
import os
from dotenv import load_dotenv

load_dotenv()

def obtener_credenciales_db():
   
    # 1. Obtener configuración del entorno (inyectadas por Docker o .env)
    vault_url = os.getenv('VAULT_ADDR', 'http://vault:8200')
    role_id = os.getenv('VAULT_ROLE_ID')
    secret_id = os.getenv('VAULT_SECRET_ID')

    # Validación básica de configuración
    if not role_id or not secret_id:
        print("ERROR: VAULT_ROLE_ID o VAULT_SECRET_ID no están configurados.")
        return None, None

    try:
        # 2. Inicializar el cliente de Vault
        client = hvac.Client(url=vault_url)

        # 3. Autenticarse con AppRole (Método recomendado para aplicaciones)
        client.auth.approle.login(role_id=role_id, secret_id=secret_id)

        # 4. Leer el secreto (Motor KV v2)
        # Por defecto buscamos en el mount 'secret' y el path definido
        read_response = client.secrets.kv.v2.read_secret_version(
            mount_point='secret',
            path='library_db'
        )

        # Extraer los datos del diccionario de respuesta
        datos = read_response['data']['data']
        
        # Devolvemos usuario y contraseña
        return datos['username'], datos['password']

    except Exception as e:
        print(f"❌ Error crítico al conectar con Vault: {e}")
        return None, None