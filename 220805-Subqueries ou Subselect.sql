use funcionarios
-------------------------------------------------------------------------------------------------------------------------------------------------
--SUBSELECT
--Esse tipo de subconsulta só pode retornar um registro e uma coluna.
--Com o atual SELECT, não é possível retornar dois valores com caracteristicas distintas
--[...]Nesse caso eu não posso, por exemplo, listar uma pessoa e seu salário juntamente com o maior salário da empresa.
-------------------------------------------------------------------------------------------------------------------------------------------------

--Listar o nome do funcionário, seu salário e o maior salário de seu setor
--Para Listar o maior salário de um setor temos:
select max(func_salario) 
from funcionarios
where setor_id = 3
--Para listar os funcionários de um setor e seus salários temos:
select func_nome, func_salario 
from funcionarios

--Nesse caso, não podemos colocar o primeiro SELECT MAX como um parâmetro para ser buscado no segundo Select, então precisamos fazer
--[...] Um Subselect. Para cada registro que for feito dentro do select externo, o Subselect vai ser executado. Perceba:
select func_nome, func_salario,
	(select max(func_salario)						  --Perceba a existência desse Select interno, conhecido como subselect
	from funcionarios								  --[...]Ele roda sempre que um registro do primeiro select é feito
	where setor_id = f.setor_id) maior_salario		  --[...]Esse comando vai pegar o maior salário do setor daquele funcionário
from funcionarios f                                   --[...]O apelido nesse caso é obrigatório para não ocorrer problemas relacionando

-------------------------------------------------------------------------------------------------------------------------------------------------
--Listar o nome do setor e a quantidade de funcionários que trabalham nesse setor
--Com Join e Group By
select setor_nome, count(func_id) from funcionarios f
right join setores s on s.setor_id = f.setor_id
group by setor_nome

--Com Subselect
select s.setor_nome, 
	(select count(f.func_id)                --Diferentemente da forma acima (com Join e Group By), essa forma é extremamente
	from funcionarios f                     --[...]ineficiente, já que o "Looping" do Subselect é executado várias vezes
	where s.setor_id = f.setor_id)          
from setores s

--------------------------------------------------------------------------------------------------------------------------------------------------
--Listar o nome do funcionário e o nome de seu setor
--Com Join
select func_nome, setor_nome from funcionarios f
left join setores s on f.setor_id = s.setor_id

--Com SubQuery
select func_nome,
	(select setor_nome from setores s
	where s.setor_id = f.setor_id) setor
from funcionarios f

--------------------------------------------------------------------------------------------------------------------------------------------------
--O subselect não precisa ser utilizado dentro da cláusula Select.
--Listar todos os funcionários que ganham abaixo da média salarial da empresa
select * from funcionarios f
where f.func_salario < (select avg(func_salario)--Nesse caso o subselect está encapsulado e sendo utilizado dentro de uma cláusula where
                        from funcionarios)      --[...] assim podemos comparar o salário de um funcionário a média salárial da empresa

--------------------------------------------------------------------------------------------------------------------------------------------------
--listar todos os funcionários que não trabalham em setores que começam com a letra 'c'
select * from funcionarios f
where f.setor_id not in (select setor_id from setores s --Perceba que nesse caso, se cria dentro do Subselect uma lista com diversos registros
						 where s.setor_nome like 'C%')  --[...]de setores que se iniciam com a letra C, então compara o setor do func com a lista

