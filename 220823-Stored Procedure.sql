-----------------------------------------------------------------------------------------------------------------------
---------------------STORED PROCEDURES---------------------------------------------------------------------------------
--Ou simplesmente [SP] � uma cole��o de instru��es (diferentemente das VIEWS que cont�m apenas um �nico SELECT)
--[...] implementadas na linguagem T-SQL que uma vez armazenada ou salva, ficam dentro do servidor de forma pr�
--[...] compilada aguardando que um usu�rio fa�a sua execu��o. Em contrapartida, enquanto as VIEWS funcionam
--[...] como tabelas, podendo ser utilizadas dentro de joins ou selects, as SP's n�o podem, elas s�o basicamente
--[...] comandos armazenados para facilitar tarefas repetitivas, como INSERTS, levando par�metros em considera��o
-----------------------------------------------------------------------------------------------------------------------
use funcionarios

--Como exemplo, criemos uma VIEW simples:
create view vw_testeDado as
	select * from funcionarios
	where func_salario > 1500

select * from vw_testeDado --Chamando a VIEW


--Agora Criando uma sp simples
create procedure sp_testeDado as
begin
	select * from funcionarios
	where func_salario > 1500
end

exec sp_testeDado --Executando a Procedure

--Perceba que visualmente, ambas a VIEW e a STORED PROCEDURE trazem a mesma coisa, por�m a SP apenas demonstra os
--[...] dados, enquanto a VIEW pode ser navegada e utilizada como uma tabela.
-----------------------------------------------------------------------------------------------------------------------

--STORED PROCEDURE COM PAR�METROS

create procedure sp_funcSalario (@limite decimal(10,2)) as --Se define o(s) par�metro(s) dentro da cria��o
begin
	select * from funcionarios
	where func_salario > @limite
end

exec sp_funcSalario 1000 --Perceba que na passagem do par�metro no momento da execu��o ocorre fora de '()'
exec sp_funcSalario 500  --[...] Com a utiliza��o de par�metros obtemos uma maior versatilidade do c�digo executado

--Com mais de um Par�metro

create procedure sp_SalarioEntre (@inicio decimal(10,2),
								  @final decimal (10,2)) as
begin
	if (@final < @inicio)
		print 'Par�metros Incorretos'
		--select 'Par�metros incorretos' tamb�m funciona, por�m o texto � exibido como resultado da busca
	else
		select * from funcionarios
		where func_salario between @inicio and @final
end

exec sp_SalarioEntre 1000, 2000
-----------------------------------------------------------------------------------------------------------------------
--Stored Procedure Retornando apenas um resultado

--Sem um par�metro OUTPUT, a SP pode retornar apenas um �nico valor, e do tipo inteiro
create procedure sp_ExisteSetor (@setor_id int) as
begin
	if (exists(select setor_nome from setores --Se esse subselect devolve algum registro, o setor Existe
			   where setor_id = @setor_id))
		return 1 --indica a EXIST�NCIA de um setor
	else
		return 0 --indica a INEXIST�NCIA de um setor
end

-----------------------------------------------------------------------------------------------------------------------
--SP retornando mais que um resultado, ou retornando um resultado diferente do tipo int

--Com OUTPUT
--A procedure que recebe o c�digo do funcion�rio e devolve o nome do setor onde ele trabalha e o valor da
--[...] somat�ria de todos os sal�rios dos funcionarios que trabalham nesse setor
-----------------------------------------------------------------------------------------------------------------------

create procedure sp_setorSalario                       --DEVE-SE respeitar a ordem:
				 (@func_id int,                        --[...] primeiramente declaramos os par�metros de entrada
				 @setor_nome varchar(50) output,       --[...] ent�o todos os par�metros de sa�da
				 @total_salario decimal(10,2) out) as  -- out e output t�m a mesma fun��o
begin
    --Declara o setor em que o funcion�rio trabalha
	declare @setor_id int = (select setor_id from funcionarios
							 where func_id = @func_id)
	--Buscar o nome do setor da tabela setores
	set @setor_nome = (select setor_nome from setores
					   where setor_id = @setor_id)
	--Somar os sal�rios desse setor pela tabela funcionarios
	set @total_salario = (select sum(func_salario) from funcionarios
						  where setor_id = @setor_id)



	--termina a SP, n�o � necess�rio utilizar o RETURN
	return
end

--Durante a chamada, se a SP tem dados de OUTPUT, deve-se declarar vari�veis para receber esses valores
declare @setor_nome varchar(50)
declare @total_salario decimal (10,2)
--chama a SP                                                   --Perceba que se voc� apresentar um func_id inv�lido
exec sp_setorSalario 8, @setor_nome out, @total_salario out    --[...] ele retorna NADA, nesse caso, se pode utilizar
print 'Nome Setor: ' + isnull(@setor_nome, 'N�o encontrado')   --[...] outra procedure que verifica a exist�ncia dele.
print 'Total Sal�rio: ' + cast(@total_salario as varchar(15))  --[...] OU pode-se utilizar a fun��o isNULL({parametro})
------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------

