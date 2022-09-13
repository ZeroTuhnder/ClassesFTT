-------------------------------------------------------------------------------------------------------------------------------
------------------------------------------TUNNING------------------------------------------------------------------------------
--Pensando que o comando FROM � um comando que se apresenta para limitar uma busca de dados a um conjunto de dados, como
--[...]Uma Tabela ou uma Coluna. O Subselect, por sua vez � normalmente um comando que retorna um �nico registro para
--[...]Cada vez que ele � rodado, por�m ele tamb�m pode ser utilizado dentro de um FROM para retornar o conjunto de dados
--[...]Necess�rios dentro do FROM para limitar o select principal ou outros Subselects, aumentando sua EFICI�NCIA.
-------------------------------------------------------------------------------------------------------------------------------
use funcionarios

--Por exemplo, o c�digo a seguir ir� trazer apensas os campos nome e id de todos os funcion�rios:
select *
from (select f.func_nome, f.func_id      --Dentro do FROM, temos uma cria��o de uma tabela em mem�ria contendo apenas nome e id
	  from funcionarios f) as tabTeste   --[...]nesse caso � necess�rio dar um apelido para a tabela "Sem Nome".

--Agora selecionando apenas registros com sal�rio superior a 1000
select *
from (select f.func_nome, f.func_id, f.func_salario         --Nesse caso, a tabela formada cont�m apenas os funcion�rios             
	  from funcionarios f                                   --[...]que ganham + de 1000, esse meio � mais eficiente ao
	  where f.func_salario > 1000) as funcMaior10k          --[...]realizar joins, pois ocupa um espa�o consider�velmente menor
