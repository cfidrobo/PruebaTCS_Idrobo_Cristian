
import express from 'express';
import dotenv from 'dotenv';
import jwt from 'jsonwebtoken';
import bodyParser from 'body-parser';
dotenv.config();

const app = express();
app.use(bodyParser.json());

// Configuración esperada en variables de entorno
const API_KEY = process.env.API_KEY;                  
const JWT_SECRET = process.env.JWT;

// Middleware: validar API Key
app.use((req, res, next) => {
  const key = req.header('X-Parse-REST-API-Key');
  if (!key || key !== API_KEY) {
    return res.status(401).send('Unauthorized: API Key inválida');
  }
  next();
});

// Middleware: validar JWT
app.use((req, res, next) => {
  const token = req.header('X-JWT-KWY');
  if (!token) {
    return res.status(401).send('Unauthorized: JWT faltante');
  }
  try {
    // Verifica firma y timestamp único por transacción
    const payload = jwt.verify(token, JWT_SECRET);
    // Podrías chequear aquí un nonce o timestamp, según tu lógica.
    next();
  } catch (err) {
    return res.status(401).send('Unauthorized: JWT inválido');
  }
});

// Solo POST /DevOps
app.all('/DevOps', (req, res, next) => {
  if (req.method !== 'POST') {
    return res.status(400).send('ERROR');
  }
  next();
});

app.post('/DevOps', (req, res) => {
  const { message, to, from, timeToLifeSec } = req.body;
  // Validaciones básicas
  if (!message || !to || !from || typeof timeToLifeSec !== 'number') {
    return res.status(400).send('ERROR');
  }
  // Aquí podrías encolar el mensaje, respetar un TTL, etc.
  res.json({
    message: `Hello ${to} your message will be send`
  });
});

// Puerto por ENV o 3000
const PORT = process.env.PORT || 3000;
const server = app.listen(PORT, () => {
  console.log(`Service running on port ${PORT}`);
});
export { app, server };
