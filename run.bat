@echo off
REM Script para rodar a API de Produtos e abrir o Swagger

setlocal enabledelayedexpansion

echo.
echo ================================
echo API de Produtos - Iniciando...
echo ================================
echo.

REM Verificar se está no diretório correto
if not exist pom.xml (
    echo Erro: arquivo pom.xml nao encontrado!
    echo Execute este script a partir da raiz do projeto.
    pause
    exit /b 1
)

echo 🔨 Compilando o projeto...
call mvn clean compile -q

if !errorlevel! neq 0 (
    echo.
    echo Erro ao compilar!
    pause
    exit /b 1
)

echo ✅ Projeto compilado com sucesso!
echo.
echo 🚀 Iniciando a API...
echo.

REM Iniciar a aplicação em uma nova janela
start "API de Produtos" mvn exec:java -Dexec.mainClass="br.edu.pos.apiprodutos.Main"

REM Aguardar a API iniciar
echo ⏳ Aguardando a API iniciar (5 segundos)...
timeout /t 5 /nobreak

echo.
echo ================================
echo ✅ API INICIADA COM SUCESSO!
echo ================================
echo.
echo 📍 URLs Disponíveis:
echo    🔗 API:         http://localhost:7000
echo    📚 Swagger:     http://localhost:7000/swagger
echo    📋 OpenAPI:     http://localhost:7000/openapi
echo    🗄️  Console H2:  http://localhost:8082
echo.
echo 💡 Abrindo Swagger no navegador...
echo.

REM Abrir o Swagger no navegador padrão
timeout /t 2 /nobreak
start "" "http://localhost:7000/swagger"

echo ✨ Swagger aberto! A API está pronta para usar.
echo.
echo 📌 A janela da API continuará rodando naquela aba.
echo    Feche-a quando quiser parar a aplicação.
echo.

pause
