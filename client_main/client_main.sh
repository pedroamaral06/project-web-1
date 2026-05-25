#!/bin/bash

BASE_URL="http://localhost:5000"

RESPOSTA=$(curl -s "${BASE_URL}/api/gerar-token")
TOKEN=$(echo $RESPOSTA | grep -o '"token":"[^"]*"' | awk -F'"' '{print $4}')

curl -s -X POST "${BASE_URL}/api/equipamento" \
     -H "Content-Type: application/json" \
     -H "Authorization: Bearer ${TOKEN}" \
     -d '{"numero_serie": "SH-BASH-999", "cliente_nif": "123456789012"}'

echo ""

curl -s -X GET "${BASE_URL}/api/equipamentos"