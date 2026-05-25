# Relatório - Sistema de Monitorização de Equipamentos

## Informações Gerais

**Data:** 25 de Maio de 2026  
**Projeto:** Sistema de Monitorização de Equipamentos (IoT)  
**Baseado em:** trabalho-pratico.pdf  
**Status:** ✅ **COMPLETO E VALIDADO**

---

## 1. Resumo Executivo

Este projeto implementa um **Sistema de Monitorização de Equipamentos** com arquitetura cliente-servidor, utilizando:
- **Backend:** Python/Flask com API REST completa
- **Banco de Dados:** SQLite3 com integridade referencial
- **Frontend:** HTML5/CSS3/JavaScript com interface responsiva
- **Autenticação:** JWT (JSON Web Tokens) HS256
- **Documentação:** Swagger/OpenAPI em `/api/docs`
- **Processamento:** Threading para alertas assíncrono

O sistema permite a gestão dinâmica de equipamentos, clientes e monitorização ativa de alertas térmicos com interface web intuitiva.

---

## 2. Requisitos Implementados

### ✅ A. Gestão do Ciclo de Vida (API REST)

| Funcionalidade | Método | Endpoint | Status |
|---|---|---|---|
| Listar Equipamentos | GET | `/api/equipamentos` | ✅ Implementado |
| Obter Equipamento | GET | `/api/equipamento/<id>` | ✅ Implementado |
| Criar Equipamento | POST | `/api/equipamento` | ✅ Implementado (JWT) |
| Mudar Cliente | PATCH | `/api/equipamento/<id>` | ✅ Implementado (JWT) |
| Remover Equipamento | DELETE | `/api/equipamento/<id>` | ✅ Implementado (JWT) |
| Validação HTTP | - | 404, 401, 400 | ✅ Implementado |

**Rotas Adicionais (CRUD Completo):**
- `GET /api/clientes` - Listar todos os clientes
- `GET /api/cliente/<nif>` - Obter cliente específico
- `POST /api/cliente` - Criar cliente (JWT)
- `POST /temperatura` - Registar temperatura (JWT)
- `GET /api/temperaturas/<equipamento_id>` - Histórico de leituras

### ✅ B. Persistência e Integridade (SQLite)

| Requisito | Status |
|---|---|
| Relacionamentos com Foreign Keys | ✅ Implementado |
| Validação de integridade referencial | ✅ Implementado |
| `connection.commit()` em alterações | ✅ Implementado |
| `PRAGMA foreign_keys = ON` | ✅ Ativado |
| Histórico de propriedade (DataInicio/DataFim) | ✅ Implementado |

**Tabelas Criadas:**
- `Cliente` - Informações dos clientes (NIF, Nome, Localidade, etc)
- `Equipamento` - Equipamentos registados (ID, NumeroSerie)
- `PropriedadeEquipamento` - Relacionamento com histórico de datas
- `Temperatura` - Registos de leitura (Temp0, Temp1, Temp2)
- `limites_sensores` - Limites de alerta por tipo de sensor
- `alertas_sensores` - Histórico de anomalias detetadas

### ✅ C. Sistema de Alertas

| Funcionalidade | Status |
|---|---|
| Monitorização ativa de temperaturas | ✅ Implementado |
| Comparação com limites de sensores | ✅ Implementado |
| Registo de alertas em anomalias | ✅ Implementado |
| Processamento assíncrono (threading) | ✅ Implementado |
| Rota GET `/api/alertas` protegida com JWT | ✅ Implementado |
| Interface web dedicada `alertas.html` | ✅ Implementado |
| Fetch API com async/await | ✅ Implementado |
| Try/catch para tratamento de erros | ✅ Implementado |
| Manipulação dinâmica do DOM | ✅ Implementado |
| Design responsivo com Cards visuais | ✅ Implementado |

### ✅ D. Intercâmbio de Informação

| Requisito | Status |
|---|---|
| JSON em todas as mensagens | ✅ Implementado |
| Content-Type: application/json | ✅ Implementado |
| Validação de payloads | ✅ Implementado |
| GeoJSON (opcional) | ⏳ Não obrigatório |

### ✅ E. Registo da Leitura de Sensores

| Funcionalidade | Status |
|---|---|
| Script `temp_rand_main.py` | ✅ Operacional |
| Suporte a JWT no script | ✅ Implementado |
| Rota `/temperatura` com validação | ✅ Implementado |
| Trigger de alertas ao registar | ✅ Implementado |

### ✅ F. Ferramentas de Teste e CLI

| Ferramenta | Status |
|---|---|
| Swagger/OpenAPI em `/api/docs` | ✅ Implementado (Flasgger) |
| Script de teste Python (`script_automacao.py`) | ✅ Implementado |
| Teste automatizado de operações CRUD | ✅ Implementado |
| Teste de proteção JWT | ✅ Implementado |

### ✅ G. Interface Cliente Web

| Aspecto | Status |
|---|---|
| Mobile (Browser otimizado) | ✅ Responsivo |
| PC/Desktop (Web Browser) | ✅ Otimizado |
| Abas de navegação | ✅ Equipamentos, Clientes, Alertas |
| Validação de inputs | ✅ Implementada |
| Confirmação de ações destrutivas | ✅ Implementada |

### ✅ H. Autenticação e Segurança

| Requisito | Status |
|---|---|
| JWT com HS256 | ✅ Implementado |
| Gerador de tokens (`/api/gerar-token`) | ✅ Operacional |
| Decorador `@verificar_jwt` | ✅ Em todas as rotas de modificação |
| Validação de campos obrigatórios | ✅ Implementada |
| Códigos de erro HTTP apropriados | ✅ 400, 401, 404, 500 |

---

## 3. Estrutura de Ficheiros

```
web-project-1/
├── server_main/
│   ├── server_main.py              # Servidor Flask com API REST completa
│   ├── static/
│   │   ├── index.html              # Frontend principal (equipamentos e clientes)
│   │   ├── alertas.html            # Página dedicada para alertas
│   │   └── css/
│   │       └── styles.css          # Estilos CSS
│   └── templates/                  # Templates HTML adicionais
├── client_temp/
│   └── temp_rand_main.py           # Script de leitura de sensores (com JWT)
├── scripts/
│   └── create_db.py                # Script de criação de base de dados
├── sql/
│   └── 5_IMPLEMENTACAO_v3.sql      # Schema de referência
├── script_automacao.py             # Suite de testes automatizados
├── requirements.txt                # Dependências Python
├── db/
│   └── test_database.db            # Base de dados SQLite
├── doc/                            # Documentação adicional
└── RELATORIO.md                    # Este documento
```

---

## 4. Funcionalidades Principais

### 4.1 Backend (server_main.py)

**Decorador JWT para Proteção:**
```python
@verificar_jwt
def funcao_protegida():
    # Apenas acessível com token JWT válido no header
    # Authorization: Bearer <TOKEN>
```

**Processamento Assíncrono de Alertas:**
```python
def processar_alertas_assincrono(equipamento_id, temp0, temp1, temp2):
    # Thread separada (daemon) que:
    # 1. Aguarda 5 segundos
    # 2. Busca limites da tabela limites_sensores
    # 3. Compara leituras com limites
    # 4. Registra anomalias na tabela alertas_sensores
```

**Rotas Implementadas:**
- `GET /` - Servidor (index.html)
- `GET /api/equipamentos` - Listar todos
- `GET /api/equipamento/<id>` - Obter um
- `POST /api/equipamento` - Criar (JWT)
- `PATCH /api/equipamento/<id>` - Mudar cliente (JWT)
- `DELETE /api/equipamento/<id>` - Remover (JWT)
- `GET /api/clientes` - Listar clientes
- `GET /api/cliente/<nif>` - Obter cliente
- `POST /api/cliente` - Criar cliente (JWT)
- `POST /temperatura` - Registar temperatura (JWT)
- `GET /api/alertas` - Listar alertas (JWT)
- `GET /api/temperaturas/<id>` - Histórico por equipamento
- `POST /api/gerar-token` - Gerar novo JWT
- `GET /api/docs` - Documentação Swagger

### 4.2 Frontend Principal (index.html)

**Abas de Navegação:**
1. **Equipamentos** - CRUD completo de equipamentos
2. **Clientes** - CRUD completo de clientes
3. **Alertas** - Visualização de histórico (integrada)

**Características:**
- Interface responsiva (mobile-friendly)
- Validação de input em tempo real
- Tratamento de erros com mensagens claras
- Atualização dinâmica sem reload completo
- Confirmação obrigatória em ações destrutivas
- Autenticação via token JWT

### 4.3 Página de Alertas (alertas.html)

**Interface Dedicada:**
- Campo para entrada de token JWT
- Botão "Atualizar Alertas"
- Visualização em grid de cards visuais
- Cada card mostra:
  - ID do alerta
  - Tipo de sensor afetado
  - ID do equipamento
  - Valor da leitura anómala
  - Data e hora da anomalia
  - Mensagem de alerta
- Tratamento visual diferenciado para anomalias
- Mensagens de status (sucesso, erro, vazio)
- Design responsivo com cores alertantes

### 4.4 Script de Testes Automatizados (script_automacao.py)

**Testes Executados:**
1. ✅ Listar equipamentos
2. ✅ Criar clientes (com validação de NIF)
3. ✅ Criar equipamentos
4. ✅ Registar temperaturas normais
5. ✅ Registar temperaturas anómalas (gera alertas)
6. ✅ Listar alertas
7. ✅ Obter equipamento específico
8. ✅ Mudar cliente de equipamento (PATCH)
9. ✅ Apagar equipamento (DELETE)
10. ✅ Validar respostas HTTP

**Resultado:** Valida automaticamente todo o pipeline

---

## 5. Instruções de Uso

### 5.1 Instalação Inicial

```bash
# Ativar ambiente virtual
python -m venv .venv
source .venv/bin/activate        # Linux/Mac
.venv\Scripts\activate           # Windows

# Instalar dependências
pip install -r requirements.txt
```

### 5.2 Criar Base de Dados

```bash
# Executar o script de criação (deve-se fazer uma vez)
cd scripts
python create_db.py
cd ..

# Ou se já existir base de dados antiga:
rm db/test_database.db           # Remover antiga
cd scripts
python create_db.py              # Criar nova
cd ..
```

### 5.3 Iniciar o Servidor

```bash
cd server_main
python server_main.py
```

**Saída esperada:**
```
======================================================================
SERVIDOR INICIADO - Sistema de Monitorização de Equipamentos
======================================================================
BD: c:\ProjetoWeb\web-project-1\db\test_database.db
Acesso: http://localhost:5000
Swagger: http://localhost:5000/api/docs
======================================================================
```

### 5.4 Acessar Interface Web

**Frontend Principal:**
```
http://localhost:5000
```

**Página de Alertas:**
```
http://localhost:5000/alertas.html
```

**Documentação Swagger:**
```
http://localhost:5000/api/docs
```

### 5.5 Gerar Token JWT

```bash
# Via curl
curl http://localhost:5000/api/gerar-token

# Resultado:
# {"token": "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9..."}
```

### 5.6 Executar Testes Automatizados

```bash
python script_automacao.py

# Executa todos os testes automaticamente:
# - Cria clientes
# - Cria equipamentos
# - Registra temperaturas
# - Valida alertas
# - Testa operações CRUD
# - Verifica proteção JWT
```

### 5.7 Registar Temperaturas Simuladas

```bash
# Gerar token primeiro
TOKEN=$(curl -s http://localhost:5000/api/gerar-token | grep -o '"[^"]*"' | sed -n '2p' | tr -d '"')

# Registar temperatura para equipamento ID 1
python client_temp/temp_rand_main.py 1

# Registar para equipamento ID 2
python client_temp/temp_rand_main.py 2

# Consultar alertas gerados
curl -X GET http://localhost:5000/api/alertas \
  -H "Authorization: Bearer $TOKEN"
```

---

## 6. Endpoints da API

### 6.1 Equipamentos

| Método | Endpoint | Descrição | Auth | Resposta |
|---|---|---|---|---|
| GET | `/api/equipamentos` | Listar todos | ❌ | Array de equipamentos |
| GET | `/api/equipamento/<id>` | Obter um | ❌ | Equipamento específico |
| POST | `/api/equipamento` | Criar novo | ✅ JWT | ID do novo equipamento |
| PATCH | `/api/equipamento/<id>` | Mudar cliente | ✅ JWT | Mensagem de sucesso |
| DELETE | `/api/equipamento/<id>` | Remover | ✅ JWT | Confirmação de remoção |

### 6.2 Clientes

| Método | Endpoint | Descrição | Auth | Resposta |
|---|---|---|---|---|
| GET | `/api/clientes` | Listar todos | ❌ | Array de clientes |
| GET | `/api/cliente/<nif>` | Obter um | ❌ | Cliente específico |
| POST | `/api/cliente` | Criar novo | ✅ JWT | NIF do novo cliente |

### 6.3 Temperaturas e Alertas

| Método | Endpoint | Descrição | Auth | Resposta |
|---|---|---|---|---|
| POST | `/temperatura` | Registar temperatura | ✅ JWT | Confirmação + trigger de alerta |
| GET | `/api/alertas` | Listar alertas | ✅ JWT | Array de alertas históricos |
| GET | `/api/temperaturas/<id>` | Histórico por equipamento | ❌ | Últimas 50 leituras |

### 6.4 Autenticação e Documentação

| Método | Endpoint | Descrição | Resposta |
|---|---|---|---|
| POST | `/api/gerar-token` | Gerar novo JWT | Token válido HS256 |
| GET | `/api/docs` | Documentação Swagger | Interface OpenAPI |

---

## 7. Exemplos de Requisições

### 7.1 Gerar Token JWT

```bash
curl -X POST http://localhost:5000/api/gerar-token
```

**Resposta:**
```json
{
  "token": "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyIjoiYWRtaW4iLCJyb2xlIjoidXNlciJ9...."
}
```

### 7.2 Criar Cliente

```bash
curl -X POST http://localhost:5000/api/cliente \
  -H "Authorization: Bearer TOKEN_AQUI" \
  -H "Content-Type: application/json" \
  -d '{
    "nif": "123456789012",
    "nome": "Empresa XYZ",
    "morada": "Rua Principal, 123",
    "codigo_postal": "1000-001",
    "localidade": "Lisboa",
    "area": "Temperatura",
    "zona": "Centro"
  }'
```

### 7.3 Criar Equipamento

```bash
curl -X POST http://localhost:5000/api/equipamento \
  -H "Authorization: Bearer TOKEN_AQUI" \
  -H "Content-Type: application/json" \
  -d '{
    "numero_serie": "SER_001_ABC",
    "cliente_nif": "123456789012"
  }'
```

### 7.4 Registar Temperatura

```bash
curl -X POST http://localhost:5000/temperatura \
  -H "Authorization: Bearer TOKEN_AQUI" \
  -H "Content-Type: application/json" \
  -d '{
    "equipamento_id": 1,
    "temp0": 25.5,
    "temp1": 26.0,
    "temp2": 24.5
  }'
```

### 7.5 Mudar Cliente (PATCH)

```bash
curl -X PATCH http://localhost:5000/api/equipamento/1 \
  -H "Authorization: Bearer TOKEN_AQUI" \
  -H "Content-Type: application/json" \
  -d '{"cliente_nif": "999999999999"}'
```

### 7.6 Apagar Equipamento

```bash
curl -X DELETE http://localhost:5000/api/equipamento/1 \
  -H "Authorization: Bearer TOKEN_AQUI"
```

### 7.7 Listar Alertas

```bash
curl -X GET http://localhost:5000/api/alertas \
  -H "Authorization: Bearer TOKEN_AQUI"
```

---

## 8. Segurança e Validação

### 8.1 Autenticação JWT

- **Algoritmo:** HS256
- **Secret Key:** `chave_secreta_projeto`
- **Validade:** Permanente até novo gerador
- **Aplicação:** Decorador `@verificar_jwt` em todas as rotas de modificação
- **Transmissão:** Header `Authorization: Bearer <TOKEN>`

### 8.2 Validação de Input

**Servidor:**
- Campos obrigatórios verificados
- NIF validado (12 caracteres)
- Série de equipamento única
- Integridade referencial via Foreign Keys
- Tipos de dados validados

**Cliente:**
- Validação em tempo real (HTML5)
- Confirmação obrigatória em DELETE
- Mensagens de erro claras
- Rejeição de campos vazios

### 8.3 Base de Dados

- `PRAGMA foreign_keys = ON` ativado
- `connection.commit()` em cada operação
- Transações garantidas
- Integridade referencial obrigatória
- Restrições de PRIMARY KEY

### 8.4 Tratamento de Erros

**Códigos HTTP:**
- **200** - OK
- **201** - Criado com sucesso
- **400** - Requisição inválida
- **401** - Não autorizado / Token inválido
- **404** - Recurso não encontrado
- **500** - Erro interno do servidor

---

## 9. Testes Realizados

### 9.1 Testes Funcionais ✅

✅ Criar cliente com validação de NIF (12 dígitos)  
✅ Criar equipamento com validação de série única  
✅ Registar temperatura e gerar alerta automaticamente  
✅ Listar todos os equipamentos (GET /api/equipamentos)  
✅ Obter equipamento específico (GET /api/equipamento/<id>)  
✅ Atualizar cliente de equipamento (PATCH)  
✅ Remover equipamento (DELETE)  
✅ Proteger rotas com JWT  
✅ Gerar e validar tokens  

### 9.2 Testes de Validação ✅

✅ Erro 400 - Dados obrigatórios faltando  
✅ Erro 401 - Token inválido ou faltando  
✅ Erro 404 - Equipamento não encontrado  
✅ Erro 404 - Cliente não encontrado  
✅ Integridade referencial respeitada  
✅ Rejeição de duplicatas (NIF, Série)  

### 9.3 Testes de Interface ✅

✅ Criar novo cliente via formulário  
✅ Criar novo equipamento  
✅ Ver lista de alertas em tempo real  
✅ Responsividade em dispositivos móveis  
✅ Atualização dinâmica sem reload  
✅ Validação de tokens na interface  

### 9.4 Testes de Alertas ✅

✅ Processamento assíncrono (threading)  
✅ Comparação com limites de sensores  
✅ Registo de anomalias na BD  
✅ Rota de alertas protegida com JWT  
✅ Interface visual atraente para alertas  
✅ Histórico de 100 alertas mais recentes  

---

## 10. Melhorias Implementadas

**Além dos requisitos mínimos:**

1. ✅ **Swagger/OpenAPI em `/api/docs`** - Documentação interativa com Flasgger
2. ✅ **CRUD Completo** - Todas as operações de Create, Read, Update, Delete
3. ✅ **Frontend Aprimorado** - Interface com abas e design profissional
4. ✅ **Página de Alertas Dedicada** - `alertas.html` com cards visuais
5. ✅ **Script de Testes Automatizados** - Validação completa do pipeline
6. ✅ **Validação Robusta** - Input validation no cliente e servidor
7. ✅ **Documentação API** - Docstrings em todas as rotas (Swagger-ready)
8. ✅ **Tratamento de Erros** - Try/catch em todos os endpoints
9. ✅ **Design Responsivo** - Mobile-friendly em todas as páginas
10. ✅ **Processamento Assíncrono** - Threading para não bloquear servidor
11. ✅ **Histórico de Propriedade** - DataInicio/DataFim em PropriedadeEquipamento
12. ✅ **Tabelas de Alertas** - limites_sensores e alertas_sensores

---

## 11. Limitações e Futuras Melhorias

**Não Implementado (Opcional):**
- GeoJSON (requisito opcional)
- Autenticação OAuth/OpenID
- Dashboard com gráficos de tendência
- Notificações em tempo real (WebSocket)
- Exportação de dados (CSV/PDF)
- Paginação em listas muito grandes

**Possíveis Melhorias Futuras:**
- Testes unitários com pytest
- Rate limiting por IP
- Logging estruturado (logs/)
- Cache de consultas frequentes
- Paginação (limit/offset)
- Filtros avançados por data
- Export de alertas
- Dashboard com gráficos
- Integração com serviços de email para notificações

---

## 12. Checklist Final ✅

### Requisitos Obrigatórios

- ✅ Remover equipamento (DELETE)
- ✅ Mudar cliente (PATCH)
- ✅ Autenticação JWT
- ✅ Tabelas com relacionamentos
- ✅ Sistema de alertas com monitorização
- ✅ Rota de alertas protegida
- ✅ Interface web para alertas (HTML + JavaScript)
- ✅ API com documentação Swagger
- ✅ Script de testes automatizados
- ✅ JSON em todas as mensagens

### Validações Técnicas

- ✅ Integridade referencial (FK)
- ✅ Validação de campos obrigatórios
- ✅ Códigos HTTP apropriados
- ✅ Tratamento de exceções
- ✅ Token JWT válido
- ✅ Processamento assíncrono funcionando
- ✅ Interface responsiva
- ✅ Base de dados criada corretamente

---

## 13. Conclusão

O sistema implementa **100% dos requisitos** especificados no trabalho prático:

- ✅ **Gestão do Ciclo de Vida** - CRUD com DELETE e PATCH
- ✅ **Persistência e Integridade Referencial** - SQLite com FK
- ✅ **Sistema de Alertas** - Monitorização ativa com threading
- ✅ **Autenticação JWT** - Token-based access control
- ✅ **API REST** - Endpoints com JSON
- ✅ **Interface Cliente Web** - Responsiva e intuitiva
- ✅ **Documentação Swagger** - Em `/api/docs`
- ✅ **Script de Teste** - Automação completa
- ✅ **Página de Alertas** - Interface dedicada

O projeto está **pronto para apresentação** e segue as melhores práticas de desenvolvimento web.

---

## 14. Ficheiros Entregues

| Ficheiro | Descrição |
|---|---|
| `server_main/server_main.py` | Backend Flask com API REST |
| `server_main/static/index.html` | Frontend principal (equipamentos e clientes) |
| `server_main/static/alertas.html` | Página dedicada para alertas |
| `server_main/static/css/styles.css` | Estilos CSS |
| `client_temp/temp_rand_main.py` | Script de leitura de sensores |
| `scripts/create_db.py` | Script de criação de base de dados |
| `script_automacao.py` | Testes automatizados |
| `sql/5_IMPLEMENTACAO_v3.sql` | Schema de referência |
| `requirements.txt` | Dependências Python |
| `RELATORIO.md` | Este documento |

---

## 15. Como Executar uma Demonstração Completa

```bash
# 1. Preparar ambiente
python -m venv .venv
.venv\Scripts\activate                      # Windows
source .venv/bin/activate                   # Linux/Mac

# 2. Instalar dependências
pip install -r requirements.txt

# 3. Criar base de dados (primeira vez)
cd scripts
python create_db.py
cd ..

# 4. Iniciar servidor
cd server_main
python server_main.py &

# 5. Em outro terminal, executar testes
python ../script_automacao.py

# 6. Acessar no navegador
# - Interface principal: http://localhost:5000
# - Alertas: http://localhost:5000/alertas.html
# - Documentação: http://localhost:5000/api/docs
```

---

**Projeto Completo e Validado**  
**Data:** 25 de Maio de 2026  
**Status:** ✅ PRONTO PARA ENTREGA

---
