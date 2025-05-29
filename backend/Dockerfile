FROM python:3.11-slim

WORKDIR /app

# Instalar dependencias del sistema (netcat para wait-for-it.sh)
RUN apt-get update && apt-get install -y netcat-openbsd

# Copiar requerimientos e instalarlos
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copiar el resto del código
COPY . .

# Asegurar permisos de ejecución
RUN chmod +x wait-for-it.sh

# Comando por defecto
CMD ["./wait-for-it.sh", "db", "3306", "--", "python", "app/main.py"]