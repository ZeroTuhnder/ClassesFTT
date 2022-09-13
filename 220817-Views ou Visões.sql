---------------------------------------------------------------------------------------------------------------------
----------------------------------------VIEWS / VIS�ES / EXIBI��ES---------------------------------------------------
--Vis�es s�o utilizadas para esconder c�digos complexos, eliminando a necessidade de reescrever SELECTS para ter os
--[...] valores trazidos por esses comandos. De forma grosseira, VIEWS cont�m m�ltiplas linhas de c�digos se compor-
--[...] tando como uma TABELA para executar um comando de forma mais simples e eficiente.

--Al�m disso, o fato de uma VIEW ser capaz de guardar processamentos armazenando planilhas de execu��o torna o c�digo
--[...] mais veloz e eficiente, pois a m�quina poder� iniciar sua execu��o a partir daquele pr�-processamento gerado.
---------------------------------------------------------------------------------------------------------------------
use funcionarios

--CRIANDO A VIEW selecionando colunas
create view vw_ListaFunc as             --(tamb�m � poss�vel dar ALTER e DROP nas VIEWS)
	select func_id, func_nome, setor_id --Perceba que as Views recebem valores de um select, portanto � imposs�vel
	from funcionarios                   --[...] adicionar ou remover dados dela, por isso o nome VIEW, � READ ONLY

--CHAMANDO A VIEW
select * from vw_ListaFunc

--Ligando uma VIEW com outra tabela
select * from vw_ListaFunc vwLF
inner join setores s on s.setor_id = vwLF.setor_id

--CRIANDO A VIEW selecionando linhas
create view vw_ListaFuncSalariomaior1500 as  --(importante lembrar que o "as" nesse caso � obrigat�rio)
	select * from funcionarios               --Nesse caso se selecionam apenas linhas, sendo apenas os registros
	where func_salario > 1500                --[...] onde os sal�rios dos funcion�rios s�o maiores que 1500

---------------------------------------------------------------------------------------------------------------------
--Criar uma view que cont�m tudo dos funcion�rios e tudo dos setores aos quais eles pertencem
create view vw_ListaFuncSetor as                      --ERRADO!
	select * from funcionarios f                      --Na tabela gerada por esse Select, temos duas colunas
	inner join setores s on s.setor_id = f.setor_id   --[...]setor_id, isso impede a cria��o de uma view v�lida

--Para resolver esse problema temos que limitar os campos de uma das tabelas
create view vw_ListaFuncSetor as
	select f.*, s.setor_nome from funcionarios f      --Nesse caso, n�o haver�o duas tabelas com setor_id
	inner join setores s on s.setor_id = f.setor_id   --[...] pois limitamos as campos inclusos da tabela setores
---------------------------------------------------------------------------------------------------------------------

--Tamb�m � poss�vel colocar VIEWS como par�metros de outras VIEWS (uma dentro da outra)
create view vw_ListaFuncSalarioSetorO as
	select vwLFS.*, setor_nome from vw_ListaFuncSalariomaior1500 vwLFS
	inner join setores s on s.setor_id = vwLFS.setor_id
	where s.setor_nome like '%o'

--APAGAR UMA VIEW
drop view vw_ListaFuncSalarioSetorO

--ALTERAR UMA VIEW     (� mais correto dizer que se cria uma view em cima da pr�viamente criada)
alter view vw_ListaFuncSetor as
	--Novo Select

--� poss�vel ver os comandos que comp�em uma view pelo comando
sp_helptext vw_ListaFuncSetor
--� poss�vel ATUALIZAR os valores dentro de uma view rodando o SELECT dentro dela novamente pelo comando
sp_refreshview vw_ListaFuncSetor --Se a tabela foi modificada, esse comando atuaiza a view com os novos resultados
--� poss�vel, utilizando Stored Procedure, consultar a estrutura de uma tabela com:
use funcionarios
sp_help funcionarios