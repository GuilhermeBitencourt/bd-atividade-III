CREATE VIEW vw_funcionarios_departamento AS
SELECT nome, cargo
FROM tb_funcionarios
WHERE departamento = 'Administrativo';

SELECT * FROM vw_funcionarios_departamento;

CREATE VIEW vw_estoque_insuficiente AS
SELECT nome_produto, quantidade_estoque
FROM tb_produtos
WHERE quantidade_estoque < 5;

SELECT * FROM vw_estoque_insuficiente;

CREATE VIEW vw_relacionamento_cliente_vendedor AS
SELECT c.nome AS nome_cliente, v.nome AS nome_vendedor
FROM tb_clientes c
JOIN tb_vendedores v ON c.id_vendedor = v.id;

SELECT * FROM vw_relacionamento_cliente_vendedor;

CREATE VIEW vw_produtos_caros AS
SELECT nome_produto, preco
FROM tb_produtos
WHERE preco > 100;

SELECT * FROM vw_produtos_caros;

CREATE VIEW vw_pedidos_pendentes AS
SELECT numero_pedido, status
FROM tb_pedidos
WHERE status = 'Pendente';

SELECT * FROM vw_pedidos_pendentes;


DELIMITER //
CREATE TRIGGER tg_validar_data_validade
BEFORE INSERT ON tb_produtos
FOR EACH ROW
BEGIN
    IF NEW.data_validade < CURDATE() THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Data de validade vencida';
    END IF;
END //
DELIMITER ;

DELIMITER //
CREATE TRIGGER tg_aumentar_preco
BEFORE UPDATE ON tb_produtos
FOR EACH ROW
SET NEW.preco = NEW.preco * 1.1;
DELIMITER ;

DELIMITER //
CREATE TRIGGER tg_atualizar_estoque
AFTER INSERT ON tb_vendas
FOR EACH ROW
UPDATE tb_produtos
SET quantidade_estoque = quantidade_estoque - NEW.quantidade
WHERE id_produto = NEW.id_produto;
DELIMITER ;

DELIMITER //
CREATE TRIGGER tg_excluir_funcionario
AFTER DELETE ON tb_funcionarios
FOR EACH ROW
INSERT INTO tb_funcionarios_demitidos (id, nome, email, data_nascimento)
VALUES (OLD.id, OLD.nome, OLD.email, OLD.data_nascimento);
DELIMITER ;

DELIMITER //
CREATE TRIGGER tg_excluir_dependente
AFTER DELETE ON tb_funcionarios
FOR EACH ROW
DELETE FROM tb_dependentes WHERE id_funcionario = OLD.id;
DELIMITER ;


