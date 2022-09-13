-------------------------------------------------------------------------------------------------------------------------------
------------------------------------------TUNNING------------------------------------------------------------------------------
--Pensando que o comando FROM é um comando que se apresenta para limitar uma busca de dados a um conjunto de dados, como
--[...]Uma Tabela ou uma Coluna. O Subselect, por sua vez é normalmente um comando que retorna um único registro para
--[...]Cada vez que ele é rodado, porém ele também pode ser utilizado dentro de um FROM para retornar o conjunto de dados
--[...]Necessários dentro do FROM para limitar o select principal ou outros Subselects, aumentando sua EFICIÊNCIA.
-------------------------------------------------------------------------------------------------------------------------------
use funcionarios

--Por exemplo, o código a seguir irá trazer apensas os campos nome e id de todos os funcionários:
select *
from (select f.func_nome, f.func_id      --Dentro do FROM, temos uma criação de uma tabela em memória contendo apenas nome e id
	  from funcionarios f) as tabTeste   --[...]nesse caso é necessário dar um apelido para a tabela "Sem Nome".

--Agora selecionando apenas registros com salário superior a 1000
select *
from (select f.func_nome, f.func_id, f.func_salario         --Nesse caso, a tabela formada contém apenas os funcionários             
	  from funcionarios f                                   --[...]que ganham + de 1000, esse meio é mais eficiente ao
	  where f.func_salario > 1000) as funcMaior10k          --[...]realizar joins, pois ocupa um espaço considerávelmente menor
