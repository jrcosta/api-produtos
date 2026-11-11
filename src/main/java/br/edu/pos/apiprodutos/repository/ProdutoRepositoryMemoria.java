package br.edu.pos.apiprodutos.repository;

import br.edu.pos.apiprodutos.model.Produto;

import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

public class ProdutoRepositoryMemoria implements ProdutoRepository {

    private final List<Produto> produtos = new ArrayList<>();

    @Override
    public void salvar(Produto produto) {

        produtos.removeIf(p -> p.getId().equals(produto.getId()));

        produtos.add(produto);
    }

    @Override
    public List<Produto> listarTodos() {
        return new ArrayList<>(produtos);
    }

    @Override
    public Optional<Produto> buscarPorId(Long id) {

        return produtos.stream()
                .filter(p -> p.getId().equals(id))
                .findFirst();
    }

    @Override
    public void excluir(Long id) {

        produtos.removeIf(p -> p.getId().equals(id));
    }

    @Override
    public void adicionarEstoque(Long id, int quantidade) {

        Optional<Produto> produto = buscarPorId(id);

        if (produto.isEmpty()) {
            throw new RuntimeException("Produto não encontrado: " + id);
        }

        produto.get().setQuantidadeEstoque(produto.get().getQuantidadeEstoque() + quantidade);
    }

    @Override
    public void removerEstoque(Long id, int quantidade) {

        Optional<Produto> produto = buscarPorId(id);

        if (produto.isEmpty()) {
            throw new RuntimeException("Produto não encontrado: " + id);
        }

        int novoEstoque = produto.get().getQuantidadeEstoque() - quantidade;
        if (novoEstoque < 0) {
            throw new RuntimeException("Produto não encontrado ou estoque insuficiente: " + id);
        }

        produto.get().setQuantidadeEstoque(novoEstoque);
    }

    @Override
    public List<Produto> listarProdutosComEstoqueBaixo(int limite) {

        return produtos.stream()
                .filter(p -> p.getQuantidadeEstoque() <= limite)
                .toList();
    }
}