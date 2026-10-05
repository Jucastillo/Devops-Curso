# ==========================================
# Etapa 1: Builder (Instalación de dependencias)
# ==========================================
FROM python:3.11-slim AS builder

WORKDIR /app

# Instalar herramientas necesarias si hiciera falta compilar
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
 && rm -rf /var/lib/apt/lists/*

COPY requirements.txt .

# Instalar dependencias en una carpeta aislada
RUN pip install --no-cache-dir --prefix=/install -r requirements.txt


# ==========================================
# Etapa 2: Runner (Imagen final de producción)
# ==========================================
FROM python:3.11-slim AS runner

WORKDIR /app

# Crear usuario sin privilegios por seguridad
RUN groupadd -r appgroup && useradd -r -g appgroup appuser

# Copiar dependencias instaladas desde la etapa builder
COPY --from=builder /install /usr/local

# Copiar el código fuente
COPY app.py .

# Cambiar al usuario no-root
USER appuser

# Exponer el puerto
EXPOSE 5000

# Variables de entorno recomendadas para Python en contenedores
ENV PYTHONUNBUFFERED=1

CMD ["gunicorn", "--bind", "0.0.0.0:5000", "--workers", "2", "--threads", "4", "--access-logfile", "-", "app:app"]
