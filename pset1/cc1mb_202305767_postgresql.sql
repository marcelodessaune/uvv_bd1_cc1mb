--comando para apagar banco de dados e os usuários, se eles já existirem.
DROP DATABASE if exists uvv;
DROP USER if exists marcelo;

--comando para criar o usário
CREATE USER marcelo WITH PASSWORD '123' CREATEDB CREATEROLE;

--comando para criar o banco de dados
CREATE DATABASE uvv 
WITH 
OWNER marcelo
template template0
encoding UTF8
lc_collate "pt_BR.UTF-8"
lc_ctype   "pt_BR.UTF-8"
ALLOW_CONNECTIONS true;

--comando para trocar a conexão do usuário com o banco de dados
\c 'dbname=uvv user=marcelo password=123';

--comando para criar o schema com autorização do meu usuário
CREATE SCHEMA lojas AUTHORIZATION marcelo;

--comando para tornar o meu esquema como padrão
ALTER USER marcelo
SET SEARCH_PATH TO lojas, "$user", public;

--comando para criar as tabelas
CREATE TABLE produtos (
                produto_id                NUMERIC(38)  NOT NULL,
                nome                      VARCHAR(255) NOT NULL,
                preco_unitario            NUMERIC(10,2),
                detalhes                  BYTEA,
                imagem                    BYTEA,
                imagem_mime_type          VARCHAR(512),
                imagem_arquivo            VARCHAR(512),
                imagem_charset            VARCHAR(512),
                imagem_ultima_atualizacao DATE,
                CONSTRAINT produtos_pk PRIMARY KEY (produto_id)
);

--comando para adicionar comentários
COMMENT ON TABLE  produtos                           IS 'Informações sobre os produtos.';
COMMENT ON COLUMN produtos.produto_id                IS 'Id do produto é um número que serve para diferenciar os produtos um dos outros.';
COMMENT ON COLUMN produtos.nome                      IS 'Serve para informar os nomes dos produtos.';
COMMENT ON COLUMN produtos.preco_unitario            IS 'Preço unitário de cada produto.';
COMMENT ON COLUMN produtos.detalhes                  IS 'Detalhes sobre os produtos';
COMMENT ON COLUMN produtos.imagem                    IS 'Imagens dos produtos.';
COMMENT ON COLUMN produtos.imagem_mime_type          IS 'O tipo de arquivo da imagem do produto';
COMMENT ON COLUMN produtos.imagem_arquivo            IS 'O arquivo das imagens dos produtos.';
COMMENT ON COLUMN produtos.imagem_charset            IS 'Arquivo da imagem dos produtos codificado para ser armazenado.';
COMMENT ON COLUMN produtos.imagem_ultima_atualizacao IS 'Data da última atualização das imagens dos produtos.';


CREATE TABLE lojas (
                loja_id                 NUMERIC(38)  NOT NULL,
                nome                    VARCHAR(255) NOT NULL,
                endereco_web            VARCHAR(100),
                endereco_fisico         VARCHAR(512),
                latitude                NUMERIC,
                longitude               NUMERIC,
                logo                    BYTEA,
                logo_mime_type          VARCHAR(512),
                logo_arquivo            VARCHAR(512),
                logo_charset            VARCHAR(512),
                logo_ultima_atualizacao DATE,
                CONSTRAINT lojas_pk PRIMARY KEY (loja_id)
);
COMMENT ON TABLE  lojas                         IS 'Informações sobre a loja.';
COMMENT ON COLUMN lojas.loja_id                 IS 'Id da loja é um número que diferencia ela das outras lojas.';
COMMENT ON COLUMN lojas.nome                    IS 'Nome da loja.';
COMMENT ON COLUMN lojas.endereco_web            IS 'Site da loja que funciona como uma vitrine de produtos e serviços, e facilita o contato.';
COMMENT ON COLUMN lojas.endereco_fisico         IS 'Localização da loja';
COMMENT ON COLUMN lojas.latitude                IS 'Ajuda a encontrar a localização da loja.';
COMMENT ON COLUMN lojas.longitude               IS 'Ajuda a encontrar a localização da loja.';
COMMENT ON COLUMN lojas.logo                    IS 'Logo da loja.';
COMMENT ON COLUMN lojas.logo_mime_type          IS 'O tipo de arquivo da logo da loja';
COMMENT ON COLUMN lojas.logo_arquivo            IS 'O arquivo da logo da loja.';
COMMENT ON COLUMN lojas.logo_charset            IS 'Arquivo da logo codificado para ser armazenado.';
COMMENT ON COLUMN lojas.logo_ultima_atualizacao IS 'Data da última modificação que fizeram na logo da loja.';


CREATE TABLE estoques (
                estoque_id NUMERIC(38) NOT NULL,
                loja_id    NUMERIC(38) NOT NULL,
                produto_id NUMERIC(38) NOT NULL,
                quantidade NUMERIC(38) NOT NULL,
                CONSTRAINT estoques_pk PRIMARY KEY (estoque_id)
);
COMMENT ON TABLE  estoques            IS 'Informações sobre os estoques da lojas.';
COMMENT ON COLUMN estoques.estoque_id IS 'Id do estoque é um número que serve para diferenciar os estoques um dos outros.';
COMMENT ON COLUMN estoques.loja_id    IS 'Id da loja é um número que diferencia ela das outras lojas.';
COMMENT ON COLUMN estoques.produto_id IS 'Id do produto é um número que serve para diferenciar os produtos um dos outros.';
COMMENT ON COLUMN estoques.quantidade IS 'Serve para mostrar a quantidade de coisas que tem no estoque.';


CREATE TABLE clientes (
                cliente_id NUMERIC(38)  NOT NULL,
                email      VARCHAR(255) NOT NULL,
                nome       VARCHAR(255) NOT NULL,
                telefone1  VARCHAR(20),
                telefone2  VARCHAR(20),
                telefone3  VARCHAR(20),
                CONSTRAINT clientes_pk PRIMARY KEY (cliente_id)
);
COMMENT ON TABLE  clientes            IS 'Os dados dos clientes da loja';
COMMENT ON COLUMN clientes.cliente_id IS 'O id do cliente é um número exclusivo usado para identificar cada cliente';
COMMENT ON COLUMN clientes.email      IS 'Email do cliente utilizado para o cadastro, serve para ter contato com o cliente mais facilmente.';
COMMENT ON COLUMN clientes.nome       IS 'Nome do cliente usado para o cadastro dele na loja.';
COMMENT ON COLUMN clientes.telefone1  IS 'Telefone do cliente usado no cadastro para ter contato com a loja.';
COMMENT ON COLUMN clientes.telefone2  IS 'Outro número de telefone caso a loja não consiga contato com o outro.';
COMMENT ON COLUMN clientes.telefone3  IS 'Outro número de telefone caso a loja não consiga contato com os outros.';


CREATE TABLE pedidos (
                pedido_id  NUMERIC(38) NOT NULL,
                data_hora  TIMESTAMP   NOT NULL,
                cliente_id NUMERIC(38) NOT NULL,
                status     VARCHAR(15) NOT NULL,
                loja_id    NUMERIC(38) NOT NULL,
                CONSTRAINT pedidos_pk PRIMARY KEY (pedido_id)
);
COMMENT ON TABLE  pedidos            IS 'Informações sobre os pedidos.';
COMMENT ON COLUMN pedidos.pedido_id  IS 'Id do pedido é um número que serve para diferenciar os pedidos um dos outros.';
COMMENT ON COLUMN pedidos.data_hora  IS 'Informar a data e a hora que o pedido foi feito, entregue e realizado';
COMMENT ON COLUMN pedidos.cliente_id IS 'O id do cliente é um número exclusivo usado para identificar cada cliente';
COMMENT ON COLUMN pedidos.status     IS 'Status do pedido serve para informar onde o pedido está, se ele está chegando, etc..';
COMMENT ON COLUMN pedidos.loja_id    IS 'Id da loja é um número que diferencia ela das outras lojas.';


CREATE TABLE envios (
                envio_id         NUMERIC(38)  NOT NULL,
                loja_id          NUMERIC(38)  NOT NULL,
                cliente_id       NUMERIC(38)  NOT NULL,
                endereco_entrega VARCHAR(512) NOT NULL,
                status           VARCHAR(15)  NOT NULL,
                CONSTRAINT envios_pk PRIMARY KEY (envio_id)
);
COMMENT ON TABLE  envios                  IS 'Informações sobre os envios.';
COMMENT ON COLUMN envios.envio_id         IS 'Id do envio é um número que serve para diferenciar os envios um dos outros.';
COMMENT ON COLUMN envios.loja_id          IS 'Id da loja é um número que diferencia ela das outras lojas.';
COMMENT ON COLUMN envios.cliente_id       IS 'O id do cliente é um número exclusivo usado para identificar cada cliente';
COMMENT ON COLUMN envios.endereco_entrega IS 'Endereço de entrega é informado para falar onde o pedido irá chegar.';
COMMENT ON COLUMN envios.status           IS 'Status do envio serve para informar onde o envio está, se ele está chegando, etc..';


CREATE TABLE pedidos_itens (
                pedido_id       NUMERIC(38)   NOT NULL,
                produto_id      NUMERIC(38)   NOT NULL,
                numero_da_linha NUMERIC(38)   NOT NULL,
                preco_unitario  NUMERIC(10,2) NOT NULL,
                quantidade      NUMERIC(38)   NOT NULL,
                envio_id        NUMERIC(38),
                CONSTRAINT pedidos_itens_pk PRIMARY KEY (pedido_id, produto_id)
);
COMMENT ON TABLE  pedidos_itens                 IS 'Informações sobre os pedidos dos itens';
COMMENT ON COLUMN pedidos_itens.pedido_id       IS 'Id do pedido é um número que serve para diferenciar os pedidos um dos outros.';
COMMENT ON COLUMN pedidos_itens.produto_id      IS 'Id do produto é um número que serve para diferenciar os produtos um dos outros.';
COMMENT ON COLUMN pedidos_itens.numero_da_linha IS 'Número da linha dos itens dos pedidos.';
COMMENT ON COLUMN pedidos_itens.preco_unitario  IS 'Preço unitário dos itens dos pedidos.';
COMMENT ON COLUMN pedidos_itens.quantidade      IS 'Quantidade de itens pedidos.';
COMMENT ON COLUMN pedidos_itens.envio_id        IS 'Id do envio é um número que serve para diferenciar os envios um dos outros.';

--comando para criar as PK de cada tabela, e os relacionamentos entre elas
ALTER TABLE estoques ADD CONSTRAINT produtos_estoques_fk
FOREIGN KEY (produto_id)
REFERENCES produtos (produto_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE pedidos_itens ADD CONSTRAINT produtos_pedidos_itens_fk
FOREIGN KEY (produto_id)
REFERENCES produtos (produto_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE envios ADD CONSTRAINT lojas_envios_fk
FOREIGN KEY (loja_id)
REFERENCES lojas (loja_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE pedidos ADD CONSTRAINT lojas_pedidos_fk
FOREIGN KEY (loja_id)
REFERENCES lojas (loja_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE estoques ADD CONSTRAINT lojas_estoques_fk
FOREIGN KEY (loja_id)
REFERENCES lojas (loja_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE envios ADD CONSTRAINT clientes_envios_fk
FOREIGN KEY (cliente_id)
REFERENCES clientes (cliente_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE pedidos ADD CONSTRAINT clientes_pedidos_fk
FOREIGN KEY (cliente_id)
REFERENCES clientes (cliente_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE pedidos_itens ADD CONSTRAINT pedidos_pedidos_itens_fk
FOREIGN KEY (pedido_id)
REFERENCES pedidos (pedido_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE pedidos_itens ADD CONSTRAINT envios_pedidos_itens_fk
FOREIGN KEY (envio_id)
REFERENCES envios (envio_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

--comando de restrições de checagem 
ALTER TABLE produtos ADD CONSTRAINT check_produtos_preco
CHECK (preco_unitario >= 0);

ALTER TABLE pedidos_itens ADD CONSTRAINT check_pedidos_itens_preco
CHECK (preco_unitario >= 0);

ALTER TABLE estoques ADD CONSTRAINT check_estoques_quantidade
CHECK (quantidade >= 0);

ALTER TABLE pedidos_itens ADD CONSTRAINT check_pedidos_itens_quantidade
CHECK (quantidade >= 0);

ALTER TABLE pedidos ADD CONSTRAINT check_pedidos_status 
CHECK (status in('CANCELADO', 'COMPLETO', 'ABERTO', 'PAGO', 'REEMBOLSADO', 'ENVIADO'));

ALTER TABLE envios ADD CONSTRAINT check_envios_status
CHECK (status in('CRIADO', 'ENVIADO', 'TRANSITO', 'ENTREGUE'));

ALTER TABLE lojas ADD CONSTRAINT check_lojas_enderecos
CHECK ((endereco_web IS NOT NULL) or (endereco_fisico IS NOT NULL));






