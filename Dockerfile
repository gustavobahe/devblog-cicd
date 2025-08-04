# Dockerfile 
 
# ================================ 
# ETAPA 1: IMAGEN BASE 
# ================================ 
 
# Usar Python 3.11 slim como imagen base 
# ¿Por qué Python 3.11-slim? 
# - Versión estable y moderna de Python 
# - "slim" = imagen más pequeña (sin herramientas innecesarias) 
# - Reduce el tamaño final del contenedor 
FROM python:3.11-slim 
 
# ================================ 
# ETAPA 2: METADATOS 
# ================================ 
 
# Información sobre la imagen (buenas prácticas) 
LABEL maintainer="tu-email@ejemplo.com" 
LABEL description="DevBlog - Aplicación de blog para aprender DevOps" 
LABEL version="1.0" 
 
# ================================ 
# ETAPA 3: CONFIGURACIÓN DEL SISTEMA 
# ================================ 
 
# Establecer variables de entorno 
# PYTHONUNBUFFERED=1: Hace que Python muestre logs en tiempo real 
# PYTHONDONTWRITEBYTECODE=1: Evita crear archivos .pyc (optimización) 
ENV PYTHONUNBUFFERED=1 
ENV PYTHONDONTWRITEBYTECODE=1 
 
# Establecer el directorio de trabajo dentro del contenedor 
# Todo el código de la aplicación estará en /app 
WORKDIR /app 
 
# ================================
# ETAPA 4: INSTALACIÓN DE DEPENDENCIAS
# ================================

# INSTALAR PARA PRODUCCION
RUN apt-get update && apt-get install -y \
    curl \
    && rm -rf /var/lib/apt/lists/*

COPY requirements.txt .
# ================================ 
# ETAPA 5: COPIAR CÓDIGO DE LA APLICACIÓN 
# ================================ 
 
# Copiar todo el código de la aplicación al contenedor 
# El . significa "todo en el directorio actual" 
# Se copia al directorio /app (definido en WORKDIR) 
COPY . . 
 
# ================================ 
# ETAPA 6: CONFIGURACIÓN DE USUARIO 
# ================================ 
 
# Crear un usuario no-root para seguridad 
# ¿Por qué no usar root? 
# - Principio de menor privilegio 
# - Si alguien compromete el contenedor, no tiene acceso root 
# - Buena práctica de seguridad 
RUN adduser --disabled-password --gecos '' appuser && \ 
    chown -R appuser:appuser /app 
USER appuser 
# PARA PRODUCCION
# Health check
HEALTHCHECK --interval=30s --timeout=30s --start-period=5s --retries=3 \
    CMD curl -f http://localhost:$PORT/api/health || exit 1
 
# ================================
# ETAPA 7: CONFIGURACIÓN DE RED
# ================================
# CAMBIAR PARA PRODUCCION
EXPOSE $PORT
 
# ================================ 
# ETAPA 8: COMANDO DE INICIO 
# ================================ 
 
# Comando que se ejecuta cuando inicia el contenedor 
# Inicia la aplicación Flask 
CMD ["python", "app.py"] 

# AGREGAR PARA PRODUCCION
ENV FLASK_ENV=production
ENV PORT=5000