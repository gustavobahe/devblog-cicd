import os
from app import create_app

# Crear aplicación
app = create_app()

if __name__ == '__main__':
    # Configuración para producción
    port = int(os.environ.get('PORT', 5000))
    debug = os.environ.get('FLASK_ENV') != 'production'
    
    print(f"🚀 Iniciando DevBlog...")
    print(f"📡 Puerto: {port}")
    print(f"🐛 Debug: {debug}")
    print(f"🌍 Entorno: {os.environ.get('FLASK_ENV', 'development')}")
    
    app.run(
        host='0.0.0.0',
        port=port,
        debug=debug
    )