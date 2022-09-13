---------------------------------------------------------------------------------------------------------------------
----------------------------------------VIEWS / VISÕES / EXIBIÇÕES---------------------------------------------------
--Visões são utilizadas para esconder códigos complexos, eliminando a necessidade de reescrever SELECTS para ter os
--[...] valores trazidos por esses comandos. De forma grosseira, VIEWS contém múltiplas linhas de códigos se compor-
--[...] tando como uma TABELA para executar um comando de forma mais simples e eficiente.

--Além disso, o fato de uma VIEW ser capaz de guardar processamentos armazenando planilhas de execução torna o código
--[...] mais veloz e eficiente, pois a máquina poderá iniciar sua execução a partir daquele pré-processamento gerado.
---------------------------------------------------------------------------------------------------------------------
use funcionarios

--CRIANDO A VIEW selecionando colunas
create view vw_ListaFunc as             --(também é possível dar ALTER e DROP nas VIEWS)
	select func_id, func_nome, setor_id --Perceba que as Views recebem valores de um select, portanto é impossível
	from funcionarios                   --[...] adicionar ou remover dados dela, por isso o nome VIEW, é READ ONLY

--CHAMANDO A VIEW
select * from vw_ListaFunc

--Ligando uma VIEW com outra tabela
select * from vw_ListaFunc vwLF
inner join setores s on s.setor_id = vwLF.setor_id

--CRIANDO A VIEW selecionando linhas
create view vw_ListaFuncSalariomaior1500 as  --(importante lembrar que o "as" nesse caso é obrigatório)
	select * from funcionarios               --Nesse caso se selecionam apenas linhas, sendo apenas os registros
	where func_salario > 1500                --[...] onde os salários dos funcionários são maiores que 1500

---------------------------------------------------------------------------------------------------------------------
--Criar uma view que contém tudo dos funcionários e tudo dos setores aos quais eles pertencem
create view vw_ListaFuncSetor as                      --ERRADO!
	select * from funcionarios f                      --Na tabela gerada por esse Select, temos duas colunas
	inner join setores s on s.setor_id = f.setor_id   --[...]setor_id, isso impede a criação de uma view válida

--Para resolver esse problema temos que limitar os campos de uma das tabelas
create view vw_ListaFuncSetor as
	select f.*, s.setor_nome from funcionarios f      --Nesse caso, não haverão duas tabelas com setor_id
	inner join setores s on s.setor_id = f.setor_id   --[...] pois limitamos as campos inclusos da tabela setores
---------------------------------------------------------------------------------------------------------------------

--Também é possível colocar VIEWS como parámetros de outras VIEWS (uma dentro da outra)
create view vw_ListaFuncSalarioSetorO as
	select vwLFS.*, setor_nome from vw_ListaFuncSalariomaior1500 vwLFS
	inner join setores s on s.setor_id = vwLFS.setor_id
	where s.setor_nome like '%o'

--APAGAR UMA VIEW
drop view vw_ListaFuncSalarioSetorO

--ALTERAR UMA VIEW     (é mais correto dizer que se cria uma view em cima da préviamente criada)
alter view vw_ListaFuncSetor as
	--Novo Select

--É possível ver os comandos que compõem uma view pelo comando
sp_helptext vw_ListaFuncSetor
--É possível ATUALIZAR os valores dentro de uma view rodando o SELECT dentro dela novamente pelo comando
sp_refreshview vw_ListaFuncSetor --Se a tabela foi modificada, esse comando atuaiza a view com os novos resultados
--É possível, utilizando Stored Procedure, consultar a estrutura de uma tabela com:
use funcionarios
sp_help funcionarios