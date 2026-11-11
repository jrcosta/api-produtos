#!/bin/bash

# Script para rodar a API de Produtos e abrir o Swagger no navegador

echo ""
echo "================================"
echo "API de Produtos - Iniciando..."
echo "================================"
echo ""

# Diretório do script
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Verificar se está no diretório correto
if [ ! -f "$SCRIPT_DIR/pom.xml" ]; then
    echo "❌ Erro: arquivo pom.xml não encontrado!"
    echo "Execute este script a partir da raiz do projeto."
    exit 1
fi

echo "📁 Diretório: $SCRIPT_DIR"
echo ""

# Compilar o projeto
echo "🔨 Compilando o projeto..."
cd "$SCRIPT_DIR"
mvn clean compile -q

if [ $? -ne 0 ]; then
    echo "❌ Erro ao compilar!"
    exit 1
fi

echo "✅ Projeto compilado com sucesso!"
echo ""
echo "🚀 Iniciando a API..."
echo ""

# Iniciar a aplicação em background
mvn exec:java -Dexec.mainClass="br.edu.pos.apiprodutos.Main" &
API_PID=$!

# Aguardar a API iniciar
echo "⏳ Aguardando a API iniciar (5 segundos)..."
sleep 5

# Verificar se a API está rodando
API_URL="http://localhost:7000"
MAX_ATTEMPTS=10
ATTEMPT=0
API_RUNNING=false

while [ $ATTEMPT -lt $MAX_ATTEMPTS ]; do
    if curl -s "$API_URL" > /dev/null 2>&1; then
        API_RUNNING=true
        break
    fi
    ATTEMPT=$((ATTEMPT + 1))
    if [ $ATTEMPT -lt $MAX_ATTEMPTS ]; then
        echo "⏳ Tentativa $ATTEMPT/$MAX_ATTEMPTS..."
        sleep 1
    fi
done

if [ "$API_RUNNING" = true ]; then
    echo ""
    echo "================================"
    echo "✅ API INICIADA COM SUCESSO!"
    echo "================================"
    echo ""
    echo "📍 URLs Disponíveis:"
    echo "   🔗 API:         http://localhost:7000"
    echo "   📚 Swagger:     http://localhost:7000/swagger"
    echo "   📋 OpenAPI:     http://localhost:7000/openapi"
    echo "   🗄️  Console H2:  http://localhost:8082"
    echo ""
    echo "💡 Abrindo Swagger no navegador..."
    echo ""
    
    # Abrir o Swagger no navegador padrão (compatível com Linux/Mac)
    if command -v xdg-open &> /dev/null; then
        xdg-open "http://localhost:7000/swagger" &
    elif command -v open &> /dev/null; then
        open "http://localhost:7000/swagger" &
    else
        echo "⚠️  Não foi possível abrir o navegador automaticamente."
        echo "Abra manualmente: http://localhost:7000/swagger"
    fi
    
    echo "✨ Swagger aberto! A API está pronta para usar."
    echo ""
    echo "📌 Para parar a aplicação, pressione Ctrl+C ou feche este terminal."
    echo ""
    
    # Manter o script rodando
    wait $API_PID
else
    echo ""
    echo "❌ Erro: Não foi possível iniciar a API!"
    echo ""
    echo "Verifique se há erros acima."
    kill $API_PID 2>/dev/null
    exit 1
fi
