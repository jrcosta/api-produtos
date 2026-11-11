## PÓS-GRADUAÇÃO • PROJETO E IMPLEMENTAÇÃO ORIENTADA A OBJETOS

## Desafio Prático Final Evolução da API de Produtos

Tema: Implementação de Controle de Estoque com Java, Javalin, JDBC e H2

| Modalidade | Prazo | Pontuação |
| --- | --- | --- |
| Individual • fork e Pull | 7 dias após a disponibilização 10,0 pontos |   |
| Request |   |   |

## 1. Contextualização

A API de Produtos já disponibiliza operações REST de cadastro, consulta, atualização e exclusão, organizadas em Controller, Service e Repository, com persistência em H2 via JDBC e documentação Swagger. Entretanto, não há controle de unidades disponíveis. Sua missão é evoluir a aplicação existente, preservando a arquitetura e implementando regras de estoque.

## 2. Objetivo

Aplicar orientação a objetos, interfaces, SOLID, separação de responsabilidades, REST, SQL e JDBC em uma melhoria funcional verificável da API, sem reconstruir o projeto do zero.

## 3. Requisitos funcionais

| Código | Requisito |
| --- | --- |
| RF01 | Adicionar quantidadeEstoque ao Produto e |
|   | persistir esse atributo. |
| RF02 | Permitir informar estoque inicial no cadastro |
|   | (valor inteiro ≥ 0). |
| RF03 | Registrar entrada de unidades em produto |
|   | existente. |
| RF04 | Registrar saída de unidades em produto |
|   | existente. |
| RF05 | Rejeitar movimentações com quantidade ≤ 0. |
| RF06 | Impedir saída maior que o estoque disponível. |
| RF07 | Listar produtos com estoque abaixo ou igual |
|   | ao limite informado. |
| RF08 | Manter o estoque persistido após reiniciar a |
|   | API. |

## 4. Endpoints a implementar

| Método | Rota | Comportamento |
| --- | --- | --- |
| POST | /produtos/{id}/estoque/entrada Somar unidades ao estoque. |   |
| POST | /produtos/{id}/estoque/saida | Subtrair unidades do estoque. |
| GET | /produtos/estoque-baixo?limit | Listar produtos com estoque |
|   | e=5 | ≤ limite. |


Corpo JSON das movimentações: { "quantidade": 10 }. Utilizar códigos HTTP coerentes: 200 para operação bem-sucedida, 400 para entrada inválida e 404 para produto inexistente. O cadastro existente deve continuar respondendo 201.

## 5. Regras técnicas e critérios de qualidade

- Manter Controller responsável por HTTP, Service pelas regras de negócio e Repository pelo acesso a dados.

- Utilizar ProdutoRepository como abstração e implementar o acesso no ProdutoRepositoryJDBC com PreparedStatement.

- Preservar o funcionamento dos endpoints já existentes e documentar os novos no Swagger.

- Tratar dados inválidos e produto inexistente sem expor detalhes internos de exceções ao cliente.

- Garantir consistência do estoque; considerar que uma saída não deve gerar saldo negativo, inclusive em acessos concorrentes.

- Atualizar o esquema do banco com segurança. CREATE TABLE IF NOT EXISTS não adiciona colunas em tabelas já existentes. Documentar a estratégia utilizada (ex.: ALTER TABLE ou banco novo de desenvolvimento).

## 6. Entrega pelo GitHub

- 1. Realizar fork do repositório-base informado pelo professor.

- 2. Implementar a solução no próprio fork, com commits descritivos.

- 3. Entregar o link do repositório onde a solução foi implementada.
