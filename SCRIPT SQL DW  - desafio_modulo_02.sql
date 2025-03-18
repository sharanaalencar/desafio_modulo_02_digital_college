-- Objetivo: O objetivo é criar um Data Warehouse (DW) que permita analisar as vendas de produtos por cliente 
-- a por categoria. Isso ajudará a empresa a identificar tendências de vendas, clientes mais valiosos e produtos 
-- mais vendidos em diferentes períodos.

-- 01. Criação da tabela Dim_Cliente

CREATE TABLE data_warehouse.dim_cliente (
    id_cliente CHARACTER PRIMARY KEY,
    nome_cliente VARCHAR(40),
    pais_cliente VARCHAR(15)
);


-- 02. Criação da tabela dim_categoria

CREATE TABLE data_warehouse.dim_categoria (
    id_categoria SMALLINT PRIMARY KEY,
    categoria VARCHAR (40)
);


-- 03. Criação da tabela dim_pedidos

CREATE TABLE data_warehouse.dim_pedidos (
    id_pedido SMALLINT PRIMARY KEY,
    id_cliente CHARACTER,
    data_pedido date,
    FOREIGN KEY (id_cliente) REFERENCES data_warehouse.dim_cliente (id_cliente)
	);

-- 04. Criação da tabela fato_vendas

CREATE TABLE data_warehouse.fato_vendas (
    id_pedido SMALLINT PRIMARY KEY,
    id_cliente CHARACTER,
	id_categoria SMALLINT,
	preco_unit REAL,
    quantidade SMALLINT,
    FOREIGN KEY (id_cliente) REFERENCES data_warehouse.dim_cliente (id_cliente),
	FOREIGN KEY (id_categoria) REFERENCES data_warehouse.dim_categoria (id_categoria)
	);


-- TABLE INPUT CLIENTES

SELECT customer_id, company_name, country
FROM public.customers

-- TABLE INPUT CATEGORIA

SELECT category_id, category_name
FROM public.categories

-- TABLE INPUT PEDIDOS

SELECT p.order_id, c.customer_id, p.order_date
FROM public.orders p
JOIN public.customers c ON p.customer_id = c.customer_id;

-- TABLE INPUT FATO VENDAS

SELECT pd.order_id, c.customer_id, ca.category_id, pd.unit_price, pd.quantity
FROM public.order_details pd
JOIN public.orders o ON pd.order_id = o.order_id 
JOIN public.customers c ON o.customer_id = c.customer_id 
JOIN public.categories ca ON ca.category_id = ca.category_id;

ALTER TABLE data_warehouse.fato_vendas 
DROP CONSTRAINT fato_vendas_id_produto_fkey;


ALTER TABLE data_warehouse.dim_pedidos 
ALTER COLUMN id_cliente TYPE CHARACTER(10);

ALTER TABLE data_warehouse.fato_vendas 
ALTER COLUMN id_cliente TYPE CHARACTER(10);

COMMIT;

INSERT INTO data_warehouse.fato_vendas (id_pedido, preco_unit)
VALUES (10248, 500.00)
ON CONFLICT (id_pedido) DO NOTHING;

ALTER TABLE data_warehouse.fato_vendas DROP CONSTRAINT fato_vendas_pkey;