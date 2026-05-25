# 🧪 Guia Prático de Testes - Sistema de Monitorização

## ✅ ANTES DE COMEÇAR
```bash
rm db/test_database.db
cd scripts && python create_db.py && cd ..
cd server_main && python server_main.py
```

---

## 🧪 TESTE 1: Página de Alertas (alertas.html)

Abrir no browser: `http://localhost:5000/alertas.html`

Deve aparecer página roxa com campo para token JWT e botão "Atualizar Alertas"

Gerar token em outro terminal:
```bash
curl http://localhost:5000/api/gerar-token
```

Colar token na página → clicar "Atualizar Alertas" → deve mostrar "Nenhum alerta"

---

## 🧪 TESTE 2: Swagger Documentation (/api/docs/)

Abrir: `http://localhost:5000/api/docs/`

Deve aparecer documentação interativa com todas as rotas

Procurar rota `/api/alertas` - deve ter cadeado 🔒 (JWT obrigatório)

---

## 🧪 TESTE 3: PropriedadeEquipamento (com datas)

Terminal:
```bash
TOKEN=$(curl -s http://localhost:5000/api/gerar-token | grep -o '"token":"[^"]*"' | cut -d'"' -f4)

# Criar cliente
curl -X POST http://localhost:5000/api/cliente \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"nif":"123456789012", "nome":"Teste"}'

# Criar equipamento
curl -X POST http://localhost:5000/api/equipamento \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"numero_serie":"TEST_001", "cliente_nif":"123456789012"}'

# Verificar BD
sqlite3 db/test_database.db "SELECT * FROM PropriedadeEquipamento LIMIT 1"
```

Resultado esperado: Linha com DataInicio preenchida, DataFim NULL

---

## 🧪 TESTE 4: Proteção JWT em /api/alertas

Terminal:
```bash
# SEM token (erro 401)
curl http://localhost:5000/api/alertas

# COM token válido (sucesso 200)
TOKEN=$(curl -s http://localhost:5000/api/gerar-token | grep -o '"token":"[^"]*"' | cut -d'"' -f4)
curl http://localhost:5000/api/alertas -H "Authorization: Bearer $TOKEN"
```

Resultado esperado: 401 sem token, 200 com token

---

## 🧪 TESTE 5: Sistema de Alertas (Temp Anómala)

Terminal:
```bash
TOKEN=$(curl -s http://localhost:5000/api/gerar-token | grep -o '"token":"[^"]*"' | cut -d'"' -f4)

# Criar cliente e equipamento
curl -X POST http://localhost:5000/api/cliente \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"nif":"999999999999", "nome":"Alerta Test"}' > /dev/null

EQUIP=$(curl -s -X POST http://localhost:5000/api/equipamento \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"numero_serie":"ALERTA_TEST", "cliente_nif":"999999999999"}' | grep -o '"id":[0-9]*' | cut -d':' -f2)

# Registar temperatura ANÓMALA (>50, fora do limite)
curl -X POST http://localhost:5000/temperatura \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json" \
  -d "{\"equipamento_id\":$EQUIP, \"temp0\":100, \"temp1\":30, \"temp2\":20}"

# Aguardar 6 segundos (processamento assíncrono)
sleep 6

# Listar alertas
curl http://localhost:5000/api/alertas -H "Authorization: Bearer $TOKEN" | python -m json.tool
```

Resultado esperado: Alerta com temp0=100, mensagem "Anomalia detetada"

---

## 🧪 TESTE 6: ON DELETE CASCADE

Terminal:
```bash
# Ver equipamentos
sqlite3 db/test_database.db "SELECT ID FROM Equipamento LIMIT 1"
# Resultado: 1 (por exemplo)

# Ver temperaturas ANTES de apagar
sqlite3 db/test_database.db "SELECT COUNT(*) FROM Temperatura WHERE Equipamento_ID=1"

TOKEN=$(curl -s http://localhost:5000/api/gerar-token | grep -o '"token":"[^"]*"' | cut -d'"' -f4)

# APAGAR equipamento
curl -X DELETE http://localhost:5000/api/equipamento/1 \
  -H "Authorization: Bearer $TOKEN"

# Ver temperaturas DEPOIS
sqlite3 db/test_database.db "SELECT COUNT(*) FROM Temperatura WHERE Equipamento_ID=1"
```

Resultado esperado: Antes=2, Depois=0 (deletadas em cascata)

---

## 🧪 TESTE 7: Todos os Testes Juntos (Recomendado)

Terminal:
```bash
PYTHONIOENCODING=utf-8 python script_automacao.py
```

Resultado esperado: Todos os testes com ✓

---

## 📋 Checklist Rápido

- [ ] Página alertas.html carrega
- [ ] Token JWT funciona
- [ ] Swagger acessível em /api/docs/
- [ ] PropriedadeEquipamento tem DataInicio
- [ ] Rota /api/alertas protegida com JWT
- [ ] Temperatura anómala gera alerta
- [ ] Apagar equipamento remove temperaturas
- [ ] Script automação passa 100%

