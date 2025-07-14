# 📘 Prueba Técnica DevOps TCS

**Autor:** Cristian Fernando Idrobo Montalvo  

**Repositorio:** https://github.com/cfidrobo/PruebaTCS_Idrobo_Cristian

**Actions:** https://github.com/cfidrobo/PruebaTCS_Idrobo_Cristian/actions


---

## 🚀 Introducción

Este proyecto implementa un microservicio en **Node.js + Express** con un endpoint `/DevOps` asegurado por **API Key** y **JWT**, dockerizado y desplegado en **Google Kubernetes Engine (GKE)** usando **Terraform**. La entrega incluye además un **pipeline CI/CD** completo en **GitHub Actions**.

---

## 🔑 Credenciales de prueba

| Clave                   | Valor                                                                 |
|-------------------------|-----------------------------------------------------------------------|
| **API Key**             | `2f5ae96c-b558-4c7b-a590-a501ae1c3f6c`                                 |
| **JWT Secret**          | `eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0cngiOjE3NTIyOTYxODUzNzksImlhdCI6MTc1MjI5NjE4NX0.VYaZn6iAqIZj8vgdlTDYfL826WXz2ibn_sC3yksQe8A`                                                               |
| **Host (IP Pública) + EndPoint**   | `http://35.193.20.145/DevOps`                                                |

---

## 🛠️ Exportar variables de entorno

Desde tu terminal, ejecuta:

```bash
export API_KEY="2f5ae96c-b558-4c7b-a590-a501ae1c3f6c"
export JWT="eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0cngiOjE3NTIyOTYxODUzNzksImlhdCI6MTc1MjI5NjE4NX0.VYaZn6iAqIZj8vgdlTDYfL826WXz2ibn_sC3yksQe8A"
export HOST="http://35.193.20.145"
```


---

## 📝 Probar el endpoint con curl


```bash
curl -X POST -H "X-Parse-REST-API-Key: 2f5ae96c-b558-4c7b-a590-a501ae1c3f6c" -H "X-JWT-KWY: eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0cngiOjE3NTIyOTYxODUzNzksImlhdCI6MTc1MjI5NjE4NX0.VYaZn6iAqIZj8vgdlTDYfL826WXz2ibn_sC3yksQe8A" -H "Content-Type: application/json" -d '{"message":"This is a test","to":"Juan Perez","from":"Rita Asturia","timeToLifeSec":45}' http://35.193.20.145/DevOps
```

o Dinamicamente:
```bash
curl -X POST \-H "X-Parse-REST-API-Key: 2f5ae96c-b558-4c7b-a590-a501ae1c3f6c" \-H "X-JWT-KWY: ${JWT}" \-H "Content-Type: application/json" \-d '{ “message” : “This is a test”, “to”: “Juan Perez”, “from”: “Rita Asturia”, “timeToLifeSec” : 45 }' \
 https://${HOST}/DevOps
 ```
**Respuesta esperada:**

```json
{
  "message": "Hello Juan Perez your message will be send"
}
```

Cualquier otro método (`GET`, `PUT`, etc.) o header inválido devuelve `"ERROR"` o `401 Unauthorized`.

---

## 📦 Ejecutar localmente con Docker

1. **Construir la imagen**  
   ```bash
   docker build -t devops-service .
   ```

2. **Levantar el contenedor**  
   Debe existir archivo `.env` con las variables JWT y Api Key.
   ```bash
   docker run -p 3000:3000 --env-file .env --name devops-service devops-service
   ```

3. **Probar localmente con Windows en PowerShell**  
 ```

Invoke-RestMethod http://localhost:3000/DevOps `
  -Method Post `
  -Headers @{
    "Content-Type" = "application/json";
    "X-Parse-REST-API-Key" = "2f5ae96c-b558-4c7b-a590-a501ae1c3f6c";
    "X-JWT-KWY" = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0cngiOjE3NTIyOTYxODUzNzksImlhdCI6MTc1MjI5NjE4NX0.VYaZn6iAqIZj8vgdlTDYfL826WXz2ibn_sC3yksQe8A"
  } `
  -Body '{"message":"This is a test","to":"Juan Perez","from":"Rita Asturia","timeToLifeSec":45}' `
  -ContentType 'application/json'

 ```
---

## 📈 Pipeline CI/CD (GitHub Actions)

El pipeline corre en cada **push** y consta de 6 etapas:

1. **build** – `npm ci` + `npm run build`  
2. **test** – `npm test` (Jest + Supertest)  
3. **vulnerability** – `npm audit` → artifact JSON  
4. **sonar-analysis** – SonarCloud scan + coverage  
5. **publish** – `docker build` & `docker push` a GHCR (`:sha8`, `:latest`)  
6. **terraform** – `terraform init/plan/` y `/terraform apply` (solo en `main`)

---

## ✔️ Comprobación en GKE

Una vez desplegado en producción:

```bash
kubectl get pods
# debe mostrar 2 pods Running

kubectl get svc devops-service-svc
# EXTERNAL-IP debe ser  35.193.20.145

kubectl get ingress devops-service-ingress
# la IP coincide con la del LoadBalancer
```
