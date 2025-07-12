import request from 'supertest';
import jwt from 'jsonwebtoken';
import dotenv from 'dotenv';
dotenv.config();

import { app, server } from './src/app.js';  // Ajusta ruta si fuese necesario

const validApiKey = process.env.API_KEY;
const jwtSecret   = process.env.JWT;
const validToken  = jwt.sign({ trx: Date.now() }, jwtSecret);

afterAll(() => {
  server.close();
});

describe('Microservicio /DevOps', () => {
  const payload = {
    message: "This is a test",
    to:      "Juan Perez",
    from:    "Rita Asturia",
    timeToLifeSec: 45
  };

  describe('POST /DevOps', () => {
    test('200 OK con payload válido y headers correctos', async () => {
      const res = await request(app)
        .post('/DevOps')
        .set('X-Parse-REST-API-Key', validApiKey)
        .set('X-JWT-KWY', validToken)
        .send(payload);

      expect(res.status).toBe(200);
      expect(res.body).toEqual({
        message: `Hello ${payload.to} your message will be send`
      });
    });

    test('401 si falta API Key', async () => {
      const res = await request(app)
        .post('/DevOps')
        .set('X-JWT-KWY', validToken)
        .send(payload);

      expect(res.status).toBe(401);
      expect(res.text).toMatch(/API Key inválida/);
    });

    test('401 si falta JWT', async () => {
      const res = await request(app)
        .post('/DevOps')
        .set('X-Parse-REST-API-Key', validApiKey)
        .send(payload);

      expect(res.status).toBe(401);
      expect(res.text).toMatch(/JWT faltante/);
    });

    test('401 si el JWT está mal firmado', async () => {
      const badToken = jwt.sign({ trx: Date.now() }, 'otro_secreto');
      const res = await request(app)
        .post('/DevOps')
        .set('X-Parse-REST-API-Key', validApiKey)
        .set('X-JWT-KWY', badToken)
        .send(payload);

      expect(res.status).toBe(401);
      expect(res.text).toMatch(/JWT inválido/);
    });

    test('401 si el JWT es un string cualquiera', async () => {
      const res = await request(app)
        .post('/DevOps')
        .set('X-Parse-REST-API-Key', validApiKey)
        .set('X-JWT-KWY', 'no-es-un-jwt')
        .send(payload);

      expect(res.status).toBe(401);
      expect(res.text).toMatch(/JWT inválido/);
    });

    test('400 si payload incompleto', async () => {
      const { message, ...incomplete } = payload;
      const res = await request(app)
        .post('/DevOps')
        .set('X-Parse-REST-API-Key', validApiKey)
        .set('X-JWT-KWY', validToken)
        .send(incomplete);

      expect(res.status).toBe(400);
      expect(res.text).toBe('ERROR');
    });
  });

  describe('GET /DevOps y otros métodos', () => {
    test('400 ERROR en GET pese a headers correctos', async () => {
      const res = await request(app)
        .get('/DevOps')
        .set('X-Parse-REST-API-Key', validApiKey)
        .set('X-JWT-KWY', validToken);

      expect(res.status).toBe(400);
      expect(res.text).toBe('ERROR');
    });

    test('400 ERROR en PUT pese a headers correctos', async () => {
      const res = await request(app)
        .put('/DevOps')
        .set('X-Parse-REST-API-Key', validApiKey)
        .set('X-JWT-KWY', validToken)
        .send(payload);

      expect(res.status).toBe(400);
      expect(res.text).toBe('ERROR');
    });
  });
});
