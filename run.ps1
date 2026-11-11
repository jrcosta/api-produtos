# Script para rodar a API de Produtos e abrir o Swagger no navegador

Write-Host "================================" -ForegroundColor Cyan
Write-Host "API de Produtos - Iniciando..." -ForegroundColor Cyan
Write-Host "================================" -ForegroundColor Cyan
Write-Host ""

# Diretório do projeto
$projectDir = Split-Path -Parent $MyInvocation.MyCommand.Path

# Verificar se está no diretório correto
if (-not (Test-Path "$projectDir\pom.xml")) {
    Write-Host "Erro: arquivo pom.xml não encontrado!" -ForegroundColor Red
    Write-Host "Execute este script a partir da raiz do projeto." -ForegroundColor Red
    exit 1
}

Write-Host "📁 Diretório: $projectDir" -ForegroundColor Green
Write-Host ""

# Compilar o projeto
Write-Host "🔨 Compilando o projeto..." -ForegroundColor Yellow
mvn clean compile -q

if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ Erro ao compilar!" -ForegroundColor Red
    exit 1
}

Write-Host "✅ Projeto compilado com sucesso!" -ForegroundColor Green
Write-Host ""

# Iniciar a aplicação em background
Write-Host "🚀 Iniciando a API..." -ForegroundColor Yellow
Write-Host ""

# Criar um job para rodar a aplicação
$job = Start-Job -ScriptBlock {
    $projectDir = $args[0]
    Set-Location $projectDir
    mvn exec:java -Dexec.mainClass="br.edu.pos.apiprodutos.Main" -q
} -ArgumentList $projectDir

# Aguardar a API iniciar (aguarda alguns segundos)
Write-Host "⏳ Aguardando a API iniciar (5 segundos)..." -ForegroundColor Yellow
Start-Sleep -Seconds 5

# Verificar se a API está rodando
$apiUrl = "http://localhost:7000"
$maxAttempts = 10
$attempt = 0
$apiRunning = $false

while ($attempt -lt $maxAttempts) {
    try {
        $response = Invoke-WebRequest -Uri $apiUrl -ErrorAction Stop
        $apiRunning = $true
        break
    }
    catch {
        $attempt++
        if ($attempt -lt $maxAttempts) {
            Write-Host "⏳ Tentativa $attempt/$maxAttempts..." -ForegroundColor Yellow
            Start-Sleep -Seconds 1
        }
    }
}

if ($apiRunning) {
    Write-Host ""
    Write-Host "================================" -ForegroundColor Green
    Write-Host "✅ API INICIADA COM SUCESSO!" -ForegroundColor Green
    Write-Host "================================" -ForegroundColor Green
    Write-Host ""
    Write-Host "📍 URLs Disponíveis:" -ForegroundColor Cyan
    Write-Host "   🔗 API:         http://localhost:7000" -ForegroundColor White
    Write-Host "   📚 Swagger:     http://localhost:7000/swagger" -ForegroundColor White
    Write-Host "   📋 OpenAPI:     http://localhost:7000/openapi" -ForegroundColor White
    Write-Host "   🗄️  Console H2:  http://localhost:8082" -ForegroundColor White
    Write-Host ""
    Write-Host "💡 Abrindo Swagger no navegador..." -ForegroundColor Yellow
    Write-Host ""
    
    # Abrir o Swagger no navegador padrão
    Start-Process "http://localhost:7000/swagger"
    
    Write-Host "✨ Swagger aberto! A API está pronta para usar." -ForegroundColor Green
    Write-Host ""
    Write-Host "📌 Para parar a aplicação, feche esta janela ou pressione Ctrl+C" -ForegroundColor Cyan
    Write-Host ""
    
    # Manter a janela aberta
    Wait-Job -Job $job
}
else {
    Write-Host ""
    Write-Host "❌ Erro: Não foi possível iniciar a API!" -ForegroundColor Red
    Write-Host ""
    Write-Host "Verifique se há erros acima." -ForegroundColor Yellow
    Stop-Job -Job $job
    exit 1
}
