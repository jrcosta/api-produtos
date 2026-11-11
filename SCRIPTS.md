# 🚀 Scripts de Execução - API de Produtos

## Opções para rodar a aplicação

### **Windows (PowerShell) ⚡**

```powershell
# Abra o PowerShell na raiz do projeto e execute:
.\run.ps1
```

**Ou se preferir, use o arquivo .bat:**

```cmd
run.bat
```

### **Linux/Mac 🐧**

```bash
# Dê permissão de execução e rode:
chmod +x run.sh
./run.sh
```

---

## ✨ O que os scripts fazem

✅ Compila o projeto Maven  
✅ Inicia a aplicação em background  
✅ Aguarda a API estar pronta  
✅ Abre automaticamente o **Swagger** no navegador  
✅ Exibe as URLs de acesso  

---

## 📍 URLs após iniciar

| Recurso | URL |
|---------|-----|
| **API** | http://localhost:7000 |
| **Swagger** 📚 | http://localhost:7000/swagger |
| **OpenAPI** 📋 | http://localhost:7000/openapi |
| **Console H2** 🗄️ | http://localhost:8082 |

---

## 🎯 Endpoints Implementados

### Produtos (CRUD)
- `GET /produtos` - Listar todos
- `GET /produtos/{id}` - Buscar por ID
- `POST /produtos` - Criar novo produto
- `PUT /produtos/{id}` - Atualizar produto
- `DELETE /produtos/{id}` - Deletar produto

### Estoque (Novos)
- `POST /produtos/{id}/estoque/entrada` - Adicionar ao estoque
- `POST /produtos/{id}/estoque/saida` - Remover do estoque
- `GET /produtos/estoque-baixo?limite=5` - Listar com estoque baixo

---

## 💡 Exemplo de Requisição

```bash
# Criar um produto com estoque inicial
curl -X POST http://localhost:7000/produtos \
  -H "Content-Type: application/json" \
  -d '{
    "nome": "Notebook",
    "preco": 3500.00,
    "quantidadeEstoque": 10
  }'

# Adicionar ao estoque
curl -X POST http://localhost:7000/produtos/1/estoque/entrada \
  -H "Content-Type: application/json" \
  -d '{"quantidade": 5}'

# Remover do estoque
curl -X POST http://localhost:7000/produtos/1/estoque/saida \
  -H "Content-Type: application/json" \
  -d '{"quantidade": 3}'

# Listar produtos com estoque baixo
curl http://localhost:7000/produtos/estoque-baixo?limite=5
```

---

## 🛑 Parar a aplicação

- **Windows (PowerShell)**: Pressione `Ctrl+C` ou feche a janela
- **Linux/Mac**: Pressione `Ctrl+C`

---

## 🔧 Requisitos

- ✅ Java 21+
- ✅ Maven 3.8+
- ✅ Maven deve estar no PATH

Pronto! A API está pronta para ser usada! 🎉
