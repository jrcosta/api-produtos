package br.edu.pos.apiprodutos.service;

import br.edu.pos.apiprodutos.model.Produto;
import br.edu.pos.apiprodutos.repository.ProdutoRepository;

import java.util.List;
import java.util.NoSuchElementException;

public class ProdutoService {

    private final ProdutoRepository repository;

    // Injeção de dependência pelo construtor
    public ProdutoService(ProdutoRepository repository) {
        this.repository = repository;
    }

    public Produto cadastrar(String nome, double preco) {
        return cadastrar(nome, preco, 0);
    }

    public Produto cadastrar(String nome, double preco, int quantidadeEstoque) {

        validarProduto(nome, preco);
        validarQuantidade(quantidadeEstoque);

        Produto produto = new Produto(null, nome, preco, quantidadeEstoque);

        repository.salvar(produto);

        return produto;
    }

    public List<Produto> listar() {
        return repository.listarTodos();
    }

    public Produto buscarPorId(Long id) {

        return repository.buscarPorId(id)
                .orElseThrow(() ->
                        new NoSuchElementException(
                                "Produto não encontrado: " + id
                        )
                );
    }

    public Produto atualizar(Long id, String nome, double preco) {

        validarProduto(nome, preco);

        Produto produto = buscarPorId(id);

        produto.setNome(nome);
        produto.setPreco(preco);

        repository.salvar(produto);

        return produto;
    }

    public void excluir(Long id) {

        buscarPorId(id);

        repository.excluir(id);
    }

    public Produto adicionarEstoque(Long id, int quantidade) {

        if (quantidade <= 0) {
            throw new IllegalArgumentException(
                    "A quantidade deve ser maior que zero."
            );
        }

        repository.adicionarEstoque(id, quantidade);

        return buscarPorId(id);
    }

    public Produto removerEstoque(Long id, int quantidade) {

        if (quantidade <= 0) {
            throw new IllegalArgumentException(
                    "A quantidade deve ser maior que zero."
            );
        }

        repository.removerEstoque(id, quantidade);

        return buscarPorId(id);
    }

    public List<Produto> listarEstoqueBaixo(int limite) {
        return repository.listarProdutosComEstoqueBaixo(limite);
    }

    private void validarProduto(String nome, double preco) {

        if (nome == null || nome.isBlank()) {
            throw new IllegalArgumentException(
                    "O nome do produto é obrigatório."
            );
        }

        if (!Double.isFinite(preco) || preco <= 0) {
            throw new IllegalArgumentException(
                    "O preço deve ser maior que zero."
            );
        }
    }

    private void validarQuantidade(int quantidade) {
        if (quantidade < 0) {
            throw new IllegalArgumentException(
                    "A quantidade do estoque não pode ser negativa."
            );
        }
    }
}