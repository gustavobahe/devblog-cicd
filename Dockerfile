# ================================
# ETAPA 1: IMAGEN BASE
# ================================
FROM python:3.11-slim

# ================================
# ETAPA 2: METADATOS
# ================================
LABEL maintainer="tu-email@ejemplo.com"
LABEL description="DevBlog - Aplicación de blog para aprender DevOps"
LABEL version="1.0"

# ================================
# ETAPA 3: VARIABLES Y DIRECTORIO
# ================================
ENV PYTHONUNBUFFERED=1
ENV PYTHONDONTWRITEBYTECODE=1
ENV FLASK_ENV=production
ENV PORT=5000

WORKDIR /app

# ================================
# ETAPA 4: DEPENDENCIAS DEL SISTEMA
# ================================
RUN apt-get update && apt-get install -y \
    curl \
    && rm -rf /var/lib/apt/lists/*

# ================================
# ETAPA 5: DEPENDENCIAS PYTHON
# ================================
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# ================================
# ETAPA 6: COPIAR CÓDIGO
# ================================
COPY . .

# ================================
# ETAPA 7: USUARIO NO ROOT
# ================================
RUN adduser --disabled-password --gecos '' appuser && \
    chown -R appuser:appuser /app
USER appuser

# ================================
# ETAPA 8: HEALTHCHECK Y EXPOSICIÓN
# ================================
HEALTHCHECK --interval=30s --timeout=30s --start-period=5s --retries=3 \
    CMD curl -f http://localhost:5000/api/health || exit 1

EXPOSE 5000

# ================================
# ETAPA 9: COMANDO DE INICIO
# ================================
CMD ["python", "app.py"]
