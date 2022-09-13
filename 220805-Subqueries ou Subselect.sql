use funcionarios
-------------------------------------------------------------------------------------------------------------------------------------------------
--SUBSELECT
--Esse tipo de subconsulta s� pode retornar um registro e uma coluna.
--Com o atual SELECT, n�o � poss�vel retornar dois valores com caracteristicas distintas
--[...]Nesse caso eu n�o posso, por exemplo, listar uma pessoa e seu sal�rio juntamente com o maior sal�rio da empresa.
-------------------------------------------------------------------------------------------------------------------------------------------------

--Listar o nome do funcion�rio, seu sal�rio e o maior sal�rio de seu setor
--Para Listar o maior sal�rio de um setor temos:
select max(func_salario) 
from funcionarios
where setor_id = 3
--Para listar os funcion�rios de um setor e seus sal�rios temos:
select func_nome, func_salario 
from funcionarios

--Nesse caso, n�o podemos colocar o primeiro SELECT MAX como um par�metro para ser buscado no segundo Select, ent�o precisamos fazer
--[...] Um Subselect. Para cada registro que for feito dentro do select externo, o Subselect vai ser executado. Perceba:
select func_nome, func_salario,
	(select max(func_salario)						  --Perceba a exist�ncia desse Select interno, conhecido como subselect
	from funcionarios								  --[...]Ele roda sempre que um registro do primeiro select � feito
	where setor_id = f.setor_id) maior_salario		  --[...]Esse comando vai pegar o maior sal�rio do setor daquele funcion�rio
from funcionarios f                                   --[...]O apelido nesse caso � obrigat�rio para n�o ocorrer problemas relacionando

-------------------------------------------------------------------------------------------------------------------------------------------------
--Listar o nome do setor e a quantidade de funcion�rios que trabalham nesse setor
--Com Join e Group By
select setor_nome, count(func_id) from funcionarios f
right join setores s on s.setor_id = f.setor_id
group by setor_nome

--Com Subselect
select s.setor_nome, 
	(select count(f.func_id)                --Diferentemente da forma acima (com Join e Group By), essa forma � extremamente
	from funcionarios f                     --[...]ineficiente, j� que o "Looping" do Subselect � executado v�rias vezes
	where s.setor_id = f.setor_id)          
from setores s

--------------------------------------------------------------------------------------------------------------------------------------------------
--Listar o nome do funcion�rio e o nome de seu setor
--Com Join
select func_nome, setor_nome from funcionarios f
left join setores s on f.setor_id = s.setor_id

--Com SubQuery
select func_nome,
	(select setor_nome from setores s
	where s.setor_id = f.setor_id) setor
from funcionarios f

--------------------------------------------------------------------------------------------------------------------------------------------------
--O subselect n�o precisa ser utilizado dentro da cl�usula Select.
--Listar todos os funcion�rios que ganham abaixo da m�dia salarial da empresa
select * from funcionarios f
where f.func_salario < (select avg(func_salario)--Nesse caso o subselect est� encapsulado e sendo utilizado dentro de uma cl�usula where
                        from funcionarios)      --[...] assim podemos comparar o sal�rio de um funcion�rio a m�dia sal�rial da empresa

--------------------------------------------------------------------------------------------------------------------------------------------------
--listar todos os funcion�rios que n�o trabalham em setores que come�am com a letra 'c'
select * from funcionarios f
where f.setor_id not in (select setor_id from setores s --Perceba que nesse caso, se cria dentro do Subselect uma lista com diversos registros
						 where s.setor_nome like 'C%')  --[...]de setores que se iniciam com a letra C, ent�o compara o setor do func com a lista

