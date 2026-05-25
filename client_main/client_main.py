import requests

BASE_URL = "http://localhost:5000"

resposta_token = requests.get(f"{BASE_URL}/api/gerar-token")
meu_token = resposta_token.json()["token"]

cabecalhos = {"Authorization": f"Bearer {meu_token}"}

payload = {
    "numero_serie": "ABC-NOVO-123",
    "cliente_nif": "123456789012"
}

response_post = requests.post(f"{BASE_URL}/api/equipamento", json=payload, headers=cabecalhos)
print(response_post.json())

response_get = requests.get(f"{BASE_URL}/api/equipamentos")
print(response_get.json())