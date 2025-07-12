# ─── ETAPA 1: Build & Test ─────────────────────────────────────────────
FROM node:18-alpine AS builder

# Crear usuario sin privilegios
RUN addgroup -S appgroup && adduser -S appuser -G appgroup

WORKDIR /usr/src/app

# Copiar archivos para instalar dependencias
COPY package*.json ./

# Instala todas las dependencias (incluyendo devDependencies)
RUN npm ci

# Copiar el resto del código fuente
COPY . .

# Ejecutar pruebas automáticas
RUN npm test

# Ejecutar revisión estática (linter)
RUN npm run lint || true

# ─── ETAPA 2: Producción ───────────────────────────────────────────────
FROM node:18-alpine

# Crear usuario sin privilegios
RUN addgroup -S appgroup && adduser -S appuser -G appgroup

WORKDIR /usr/src/app

# Solo dependencias de producción
COPY package*.json ./
RUN npm ci --omit=dev

# Copiar el código y cambiar propietario
COPY --from=builder /usr/src/app ./
RUN chown -R appuser:appgroup /usr/src/app

# Usar usuario sin privilegios
USER appuser

# Variables de entorno
ENV NODE_ENV=production
ENV PORT=3000
EXPOSE ${PORT}

# Comando de inicio
CMD ["node", "src/app.js"]
