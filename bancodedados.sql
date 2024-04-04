SELECT
O.fname AS Nome_Administrador ,
O.lname AS Sobrenome_Administrador , 
B.name AS Nome_Empresa , 
C.city AS Cidade 
FROM
officer O 
JOIN business B ON
O.cust_id = B.cust_id
JOIN customer C ON
B.cust_id = C.cust_id 
WHERE 
O.title IS NOT NULL;

. Estamos selecionando as colunas fname e Iname da tabela officer para obter o nome
e sobrenome do administrador.

. Estamos selecionando a coluna name da tabela business para obter o nome da empresa.

. Estamos selecionando a coluna city da tabela customer para obter a cidade onde a
empresa está presente.

. Estamos usando JOIN para combinar as tabelas officer, business, e customer com base nas chaves cust_id.
. Estamos usando a Cláusula WHERE para garantir que estamos apenas selecionando os ad-
ministradores que têm um título (Q. title IS NOT NULL), ou seja, estamos excluindo aqueles sem título.

SELECT
    CASE
        WHEN c.cust_type_cd = 'I' THEN CONCAT (i.fname, ' ' , i.lname)
        WHEN c.cust_type_cd = 'B' THEN b.name
    END AS customer_name
FROM 
    account a 
JOIN customer c ON 
a.cust_id = c.cust_id
LEFT JOIN individual i ON
    c.cust_id = i.cust_id
    AND c.cust_type_cd = 'I'
LEFT JOIN business b ON 
c.cust_id = b.cust_id
    AND c.cust_type_cd = 'B'
JOIN branch br ON
    a.open_branch_id = br.branch_id
WHERE
    br.city <> c.city;

. O script usa uma instrução SELECT para criar uma lista de nomes de clientes.
. Ele usa a clánsula CASE para verificar o tipo de cliente (cust type cd) e, com base nisso, construir o nome do cliente. Se o tipo de cliente for 
'I' (individual), ele concatena o primeiro nome (fname) c o sobrenome (Iname) do cliente. Se o tipo de cliente for B (business), ele usa o nome da empresa (name).
. A consulta está vinculando as tabelas account, customer, individual. business e branch usando várias junções (JOIN)
. O JOIN entre a tabela account e customer é feito com base no campo cust id. que é
comun as duas tabelas e relaciona uma conta a um cliente.
. As tabelas individual e business são vinculadas à Labela customer usaudo junções
LEFT JOIN. Isso permite que o seript traga informações sobre clientes individuais e comerciais, dependendo do valor de cust_type-ca.
. Além disso, o script vincula a tabela branch para verificar se a cidade da agência (br. city) 
é diferente da cidade do cliente (c. city). Isso é feito para encontrar clientes que possuem uma conta em na cidade diferente da cidade de estabelecimento.
. A clánsula WHERE impõe a coudição em que a cidade da agência (br.city) deve ser
diferente da cidade do cliente (c.city)


SELECT
    e.fname,
    e.lname,
    YEAR (t.txn_date) AS ano,
    COUNT (t.txn_id) AS num_transacoes
FROM
    employee e
LEFT JOIN account a ON
    e.emp_id = a. open_emp_id
LEFT JOIN 'transaction' t ON
    a. account_id = t.account_id
 GROUP BY
    e.emp_id,
    ano
ORDER BY
    e.lname ,
    e.fname,
    ano; 


SELECT
    b. branch_id AS agencia_id,
    b.name AS nome_agencia,
    a.account_id AS conta_id,
CASE
    WHEN c.cust_type_cd = 'I' THEN CONCAT(i.fname, ' ', i.lname)
    WHEN c.cust_type_cd = 'B' THEN b2.name
END AS nome_titular,
a.avail balance AS saldo
FROM
    account AS a
INNER JOIN branch AS b ON
    a.open_branch_id = b.branch_id
INNER JOIN customer AS c ON
    a. cust_id = c.cust id
LEFT JOIN individual AS i ON
    c.cust_type_cd = 'I'
    AND c.cust_id = i.cust_id
LEFT JOIN business AS b2 ON
c.cust_type_cd = 'B'
    AND c.cust_id = b2.cust_id
WHERE
    a.avail_balance = (
SELECT
  MAX(avail_balance)
FROM
   account
WHERE
  open_branch_id = b.branch_id
);


. Selecionamos as colunas que queremos na saída, incluindo o identificador da agência (branch id), 
o nome da agência (name), o identificador da conta (account id), o nome do titular (nome_titular), e o saldo disponível da conta (avail balance).
. Usamos uma junção interna (INNER JOIN) para combinar as tabelas account e branch com base no identificador da agência
. Usamos outra junção interna para combinar a tabela account com a tabela customer com base no identificador do cliente (cust_id).
. Usamos junções à esquerda (LEFT JOIN) para combinar a tabela customer com as tabelas individual e 
business com base no tipo de cliente (cust_type_cd). Isso nOs permite obter o nome do titular, que pode ser uma pessoa física ou uma empresa.
. Na cláusula WHERE selecionamos apenas as linhas em que o saldo disponível da conta é igual ao maior 
saldo disponível daquela agência. Isso nos dá a conta com o maior saldo de dinheiro em cada agência.

/* 2 Modularizada */
CREATE VIEW customer_names_view AS
SELECT
CASE
    WHEN c.cust_type_cd = 'I' THEN CONCAT(i. fname, ' ', i.lname)
    WHEN c.cust_type_cd = 'B' THEN b.name
END AS customer_name
FROM
    account a
JOIN customer c ON a.cust_id = c.cust_id
LEFT JOIN individual i ON c.cust_id = i.cust_id AND c.cust_type_cd = 'I'
LEFT JOIN business b ON c.cust_id = b.cust_id AND c.cust_type_cd = 'B'
JOIN branch br ON a.open_branch_id = br.branch_id
WHERE
    br.city <> c.city;
/* 4 Modularizada */
CREATE VIEW view_saldo_max_agencia AS

SELECT 
    b.branch_id AS agencia_id,
    b.name AS nome_agencia,
    a.account_id AS conta_id,
CASE
    WHEN c.cust_type_cd = 'I' THEN CONCAT (i.fname, ' ', i.lname)
    WHEN c.cust_type_cd = 'B' THEN b2.name
END AS nome_titular, 
a.avail_balance AS saldo
FROM account AS a
INNER JOIN branch AS b ON a.open_branch_id = b.branch_id
INNER JOIN customer AS c ON a.cust_id = c.cust_id
LEFT JOIN individual AS i ON c.cust_type_cd = 'I' AND c.cust_id = i.cust_id
LEFT JOIN business AS b2 ON c.cust_type_cd = 'B' AND c. cust_id = b2.cust_id
WHERE a.avail balance = (
    SELECT MAX (avail_balance)
    FROM account
    WHERE open_branch_id - b.branch_id
);