# 📦 API de Produtos com Controle de Estoque

Uma API REST desenvolvida em **Java** com **Javalin**, **JDBC** e **H2**, implementando operações CRUD de produtos e controle de estoque com persistência em banco de dados.

## 🎯 Visão Geral

Este projeto implementa uma API de gerenciamento de produtos com funcionalidades avançadas de controle de estoque, seguindo princípios de **Arquitetura em Camadas** (MVC), **SOLID** e **Separação de Responsabilidades**.

### ✨ Funcionalidades Principais

- ✅ CRUD completo de produtos
- ✅ Controle de estoque (entrada e saída)
- ✅ Listagem de produtos com estoque baixo
- ✅ Persistência com JDBC + H2
- ✅ Documentação automática com Swagger/OpenAPI
- ✅ Tratamento robusto de erros
- ✅ Console H2 para gerenciamento do banco

---

## 🏗️ Arquitetura

```
┌─────────────────────────────────────────┐
│         ProdutoController               │  ← Camada HTTP
│    (Requisições e Respostas)            │
└────────────────┬────────────────────────┘
                 │
┌────────────────▼────────────────────────┐
│         ProdutoService                  │  ← Camada de Negócio
│  (Validações e Regras de Estoque)       │
└────────────────┬────────────────────────┘
                 │
┌────────────────▼────────────────────────┐
│     ProdutoRepository (Interface)       │  ← Camada de Persistência
│  ├─ ProdutoRepositoryJDBC               │
│  └─ ProdutoRepositoryMemória            │
└────────────────┬────────────────────────┘
                 │
┌────────────────▼────────────────────────┐
│      Database (H2 + JDBC)               │  ← Banco de Dados
└─────────────────────────────────────────┘
```

---

## 🚀 Quick Start

### Pré-requisitos

- **Java 21+** ☕
- **Maven 3.8+** 📦
- Maven deve estar configurado no PATH

### Opção 1: Usar o Script (Recomendado)

#### Windows (PowerShell)
```powershell
cd c:\Users\Eneri Junior\api-produtos
.\run.ps1
```

#### Windows (Batch)
```cmd
cd c:\Users\Eneri Junior\api-produtos
run.bat
```

#### Linux/Mac
```bash
cd ~/api-produtos
chmod +x run.sh
./run.sh
```

### Opção 2: Rodar Manualmente

```bash
# Compilar
mvn clean compile

# Executar
mvn exec:java -Dexec.mainClass="br.edu.pos.apiprodutos.Main"
```

---

## 📍 URLs de Acesso

Após iniciar a aplicação:

| Recurso | URL |
|---------|-----|
| **API** | http://localhost:7000 |
| **Swagger** 📚 | http://localhost:7000/swagger |
| **OpenAPI** 📋 | http://localhost:7000/openapi |
| **Console H2** 🗄️ | http://localhost:8082 |

---

## 🔌 Endpoints da API

### Produtos (CRUD)

#### Listar todos os produtos
```http
GET /produtos
```

**Resposta:**
```json
[
  {
    "id": 1,
    "nome": "Notebook",
    "preco": 3500.0,
    "quantidadeEstoque": 10
  }
]
```

---

#### Buscar produto por ID
```http
GET /produtos/{id}
```

**Exemplo:**
```http
GET /produtos/1
```

**Resposta (200):**
```json
{
  "id": 1,
  "nome": "Notebook",
  "preco": 3500.0,
  "quantidadeEstoque": 10
}
```

**Resposta (404):**
```json
{
  "mensagem": "Produto não encontrado: 1"
}
```

---

#### Criar novo produto
```http
POST /produtos
Content-Type: application/json

{
  "nome": "Teclado Mecânico",
  "preco": 450.00,
  "quantidadeEstoque": 25
}
```

**Resposta (201):**
```json
{
  "id": 2,
  "nome": "Teclado Mecânico",
  "preco": 450.0,
  "quantidadeEstoque": 25
}
```

**Resposta (400):**
```json
{
  "mensagem": "O nome do produto é obrigatório."
}
```

---

#### Atualizar produto
```http
PUT /produtos/{id}
Content-Type: application/json

{
  "nome": "Teclado Gamer",
  "preco": 550.00,
  "quantidadeEstoque": 25
}
```

**Resposta (200):**
```json
{
  "id": 2,
  "nome": "Teclado Gamer",
  "preco": 550.0,
  "quantidadeEstoque": 25
}
```

---

#### Deletar produto
```http
DELETE /produtos/{id}
```

**Resposta (204):** Sem conteúdo

---

### Estoque (Novos)

#### Adicionar unidades ao estoque
```http
POST /produtos/{id}/estoque/entrada
Content-Type: application/json

{
  "quantidade": 10
}
```

**Resposta (200):**
```json
{
  "id": 1,
  "nome": "Notebook",
  "preco": 3500.0,
  "quantidadeEstoque": 20
}
```

**Resposta (400):**
```json
{
  "mensagem": "A quantidade deve ser maior que zero."
}
```

**Resposta (404):**
```json
{
  "mensagem": "Produto não encontrado: 1"
}
```

---

#### Remover unidades do estoque
```http
POST /produtos/{id}/estoque/saida
Content-Type: application/json

{
  "quantidade": 5
}
```

**Resposta (200):**
```json
{
  "id": 1,
  "nome": "Notebook",
  "preco": 3500.0,
  "quantidadeEstoque": 15
}
```

**Resposta (400):**
```json
{
  "mensagem": "A quantidade deve ser maior que zero."
}
```

**Resposta (404):**
```json
{
  "mensagem": "Produto não encontrado ou estoque insuficiente: 1"
}
```

---

#### Listar produtos com estoque baixo
```http
GET /produtos/estoque-baixo?limite=5
```

**Resposta (200):**
```json
[
  {
    "id": 1,
    "nome": "Mouse",
    "preco": 89.90,
    "quantidadeEstoque": 3
  },
  {
    "id": 3,
    "nome": "Monitor",
    "preco": 1200.0,
    "quantidadeEstoque": 5
  }
]
```

---

## 💻 Exemplos de Uso

### cURL

```bash
# Criar um produto
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
  -d '{"quantidade": 2}'

# Listar produtos com estoque baixo
curl http://localhost:7000/produtos/estoque-baixo?limite=5

# Listar todos
curl http://localhost:7000/produtos
```

### PowerShell

```powershell
# Criar um produto
$produto = @{
    nome = "Monitor 27 polegadas"
    preco = 1200.00
    quantidadeEstoque = 8
} | ConvertTo-Json

Invoke-RestMethod -Uri "http://localhost:7000/produtos" `
    -Method Post `
    -ContentType "application/json" `
    -Body $produto

# Adicionar ao estoque
$entrada = @{ quantidade = 3 } | ConvertTo-Json

Invoke-RestMethod -Uri "http://localhost:7000/produtos/1/estoque/entrada" `
    -Method Post `
    -ContentType "application/json" `
    -Body $entrada
```

### JavaScript (Fetch API)

```javascript
// Criar um produto
const produto = {
  nome: "SSD 500GB",
  preco: 450.00,
  quantidadeEstoque: 15
};

fetch('http://localhost:7000/produtos', {
  method: 'POST',
  headers: { 'Content-Type': 'application/json' },
  body: JSON.stringify(produto)
})
  .then(res => res.json())
  .then(data => console.log(data));

// Adicionar ao estoque
const entrada = { quantidade: 5 };

fetch('http://localhost:7000/produtos/1/estoque/entrada', {
  method: 'POST',
  headers: { 'Content-Type': 'application/json' },
  body: JSON.stringify(entrada)
})
  .then(res => res.json())
  .then(data => console.log(data));
```

---

## 📊 Modelo de Dados

### Tabela: `produtos`

| Coluna | Tipo | Constraints |
|--------|------|-------------|
| `id` | BIGINT | PRIMARY KEY, AUTO INCREMENT |
| `nome` | VARCHAR(150) | NOT NULL |
| `preco` | DOUBLE PRECISION | NOT NULL |
| `quantidade_estoque` | INT | DEFAULT 0, NOT NULL |

---

## 🔍 Validações Implementadas

### Produto
- ✅ Nome é obrigatório e não pode ser vazio
- ✅ Preço deve ser maior que zero
- ✅ Quantidade de estoque não pode ser negativa

### Estoque
- ✅ Quantidade deve ser maior que zero
- ✅ Saída não pode ser maior que o estoque disponível
- ✅ Produto deve existir

### HTTP
- ✅ **200**: Operação bem-sucedida
- ✅ **201**: Recurso criado
- ✅ **204**: Sem conteúdo (sucesso)
- ✅ **400**: Entrada inválida ou erro de negócio
- ✅ **404**: Produto não encontrado

---

## 📁 Estrutura do Projeto

```
api-produtos/
├── src/
│   └── main/
│       ├── java/
│       │   └── br/edu/pos/apiprodutos/
│       │       ├── Main.java                    # Ponto de entrada
│       │       ├── config/
│       │       │   └── Database.java            # Conexão com H2
│       │       ├── controller/
│       │       │   └── ProdutoController.java   # Endpoints HTTP
│       │       ├── model/
│       │       │   └── Produto.java             # Entidade
│       │       ├── repository/
│       │       │   ├── ProdutoRepository.java   # Interface
│       │       │   ├── ProdutoRepositoryJDBC.java
│       │       │   └── ProdutoRepositoryMemória.java
│       │       └── service/
│       │           └── ProdutoService.java      # Regras de negócio
│       └── resources/
│           └── openapi.yaml                     # Documentação OpenAPI
├── dados/                                       # Banco H2 (gerado)
├── pom.xml                                      # Dependências Maven
├── run.ps1                                      # Script PowerShell
├── run.bat                                      # Script Batch
├── run.sh                                       # Script Shell
├── README.md                                    # Este arquivo
└── SCRIPTS.md                                   # Guia de scripts
```

---

## 📚 Dependências

```xml
<!-- Framework REST -->
<dependency>
    <groupId>io.javalin</groupId>
    <artifactId>javalin</artifactId>
    <version>6.7.0</version>
</dependency>

<!-- Logging -->
<dependency>
    <groupId>org.slf4j</groupId>
    <artifactId>slf4j-simple</artifactId>
    <version>2.0.17</version>
</dependency>

<!-- JSON -->
<dependency>
    <groupId>com.fasterxml.jackson.core</groupId>
    <artifactId>jackson-databind</artifactId>
    <version>2.18.3</version>
</dependency>

<!-- Swagger/OpenAPI -->
<dependency>
    <groupId>io.javalin.community.openapi</groupId>
    <artifactId>javalin-openapi-plugin</artifactId>
    <version>6.7.0</version>
</dependency>

<dependency>
    <groupId>io.javalin.community.openapi</groupId>
    <artifactId>javalin-swagger-plugin</artifactId>
    <version>6.7.0</version>
</dependency>

<!-- Banco de Dados -->
<dependency>
    <groupId>com.h2database</groupId>
    <artifactId>h2</artifactId>
    <version>2.3.232</version>
</dependency>
```

---

## 🛠️ Desenvolvimento

### Compilar
```bash
mvn clean compile
```

### Empacotar
```bash
mvn clean package
```

### Rodar testes
```bash
mvn test
```

### Limpar build
```bash
mvn clean
```

---

## 🔒 Tratamento de Erros

A API retorna erros estruturados em JSON:

```json
{
  "mensagem": "Descrição do erro"
}
```

Exemplos:
- `"O nome do produto é obrigatório."`
- `"O preço deve ser maior que zero."`
- `"A quantidade deve ser maior que zero."`
- `"Produto não encontrado: 1"`
- `"Produto não encontrado ou estoque insuficiente: 1"`

---

## 📝 Requisitos Funcionais Implementados

| Código | Requisito | Status |
|--------|-----------|--------|
| RF01 | Adicionar quantidadeEstoque ao Produto | ✅ |
| RF02 | Permitir informar estoque inicial no cadastro | ✅ |
| RF03 | Registrar entrada de unidades em produto existente | ✅ |
| RF04 | Registrar saída de unidades em produto existente | ✅ |
| RF05 | Rejeitar movimentações com quantidade ≤ 0 | ✅ |
| RF06 | Impedir saída maior que o estoque disponível | ✅ |
| RF07 | Listar produtos com estoque abaixo ou igual ao limite | ✅ |
| RF08 | Manter o estoque persistido após reiniciar a API | ✅ |

---

## 🎓 Conceitos Aplicados

- ✅ **Orientação a Objetos**: Classes, herança, polimorfismo
- ✅ **Design Patterns**: Repository, DAO, Service Layer
- ✅ **SOLID**: Single Responsibility, Open/Closed, Interface Segregation
- ✅ **Arquitetura em Camadas**: Controller → Service → Repository
- ✅ **REST**: Métodos HTTP corretos, Status codes semânticos
- ✅ **JDBC**: PreparedStatement, ResultSet, Connection Pooling
- ✅ **SQL**: DDL (CREATE TABLE, ALTER TABLE), DML (INSERT, UPDATE, DELETE, SELECT)
- ✅ **Documentação**: Swagger/OpenAPI automático

---

## 🐛 Solução de Problemas

### A API não inicia

**Causa:** Maven não está instalado ou não está no PATH

**Solução:**
```bash
# Verificar versão do Maven
mvn --version

# Se não funcionar, instale Maven:
# Windows: chocolatey install maven
# Linux/Mac: brew install maven
```

### Porta 7000 já está em uso

**Solução:** Feche a aplicação anterior ou altere a porta em `Main.java`:

```java
app.start(7001); // Altere para outra porta
```

### Erro ao conectar ao banco H2

**Solução:** Delete a pasta `dados/` e reinicie:

```bash
rm -rf dados/    # Linux/Mac
rmdir /s dados   # Windows
```

---

## 📞 Contato

Desenvolvido como projeto final da Pós-Graduação em Projeto e Implementação Orientada a Objetos.

---

## 📄 Licença

Projeto educacional.

---

**Pronto para usar! 🚀**

Dúvidas? Consulte o arquivo `SCRIPTS.md` para instruções de execução.
