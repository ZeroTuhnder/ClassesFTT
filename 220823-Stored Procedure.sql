-----------------------------------------------------------------------------------------------------------------------
---------------------STORED PROCEDURES---------------------------------------------------------------------------------
--Ou simplesmente [SP] é uma coleção de instruções (diferentemente das VIEWS que contém apenas um único SELECT)
--[...] implementadas na linguagem T-SQL que uma vez armazenada ou salva, ficam dentro do servidor de forma pré
--[...] compilada aguardando que um usuário faça sua execução. Em contrapartida, enquanto as VIEWS funcionam
--[...] como tabelas, podendo ser utilizadas dentro de joins ou selects, as SP's não podem, elas são basicamente
--[...] comandos armazenados para facilitar tarefas repetitivas, como INSERTS, levando parâmetros em consideração
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

--Perceba que visualmente, ambas a VIEW e a STORED PROCEDURE trazem a mesma coisa, porém a SP apenas demonstra os
--[...] dados, enquanto a VIEW pode ser navegada e utilizada como uma tabela.
-----------------------------------------------------------------------------------------------------------------------

--STORED PROCEDURE COM PARÂMETROS

create procedure sp_funcSalario (@limite decimal(10,2)) as --Se define o(s) parâmetro(s) dentro da criação
begin
	select * from funcionarios
	where func_salario > @limite
end

exec sp_funcSalario 1000 --Perceba que na passagem do parâmetro no momento da execução ocorre fora de '()'
exec sp_funcSalario 500  --[...] Com a utilização de parâmetros obtemos uma maior versatilidade do código executado

--Com mais de um Parâmetro

create procedure sp_SalarioEntre (@inicio decimal(10,2),
								  @final decimal (10,2)) as
begin
	if (@final < @inicio)
		print 'Parâmetros Incorretos'
		--select 'Parâmetros incorretos' também funciona, porém o texto é exibido como resultado da busca
	else
		select * from funcionarios
		where func_salario between @inicio and @final
end

exec sp_SalarioEntre 1000, 2000
-----------------------------------------------------------------------------------------------------------------------
--Stored Procedure Retornando apenas um resultado

--Sem um parâmetro OUTPUT, a SP pode retornar apenas um único valor, e do tipo inteiro
create procedure sp_ExisteSetor (@setor_id int) as
begin
	if (exists(select setor_nome from setores --Se esse subselect devolve algum registro, o setor Existe
			   where setor_id = @setor_id))
		return 1 --indica a EXISTÊNCIA de um setor
	else
		return 0 --indica a INEXISTÊNCIA de um setor
end

-----------------------------------------------------------------------------------------------------------------------
--SP retornando mais que um resultado, ou retornando um resultado diferente do tipo int

--Com OUTPUT
--A procedure que recebe o código do funcionário e devolve o nome do setor onde ele trabalha e o valor da
--[...] somatória de todos os salários dos funcionarios que trabalham nesse setor
-----------------------------------------------------------------------------------------------------------------------

create procedure sp_setorSalario                       --DEVE-SE respeitar a ordem:
				 (@func_id int,                        --[...] primeiramente declaramos os parâmetros de entrada
				 @setor_nome varchar(50) output,       --[...] então todos os parâmetros de saída
				 @total_salario decimal(10,2) out) as  -- out e output têm a mesma função
begin
    --Declara o setor em que o funcionário trabalha
	declare @setor_id int = (select setor_id from funcionarios
							 where func_id = @func_id)
	--Buscar o nome do setor da tabela setores
	set @setor_nome = (select setor_nome from setores
					   where setor_id = @setor_id)
	--Somar os salários desse setor pela tabela funcionarios
	set @total_salario = (select sum(func_salario) from funcionarios
						  where setor_id = @setor_id)



	--termina a SP, não é necessário utilizar o RETURN
	return
end

--Durante a chamada, se a SP tem dados de OUTPUT, deve-se declarar variáveis para receber esses valores
declare @setor_nome varchar(50)
declare @total_salario decimal (10,2)
--chama a SP                                                   --Perceba que se você apresentar um func_id inválido
exec sp_setorSalario 8, @setor_nome out, @total_salario out    --[...] ele retorna NADA, nesse caso, se pode utilizar
print 'Nome Setor: ' + isnull(@setor_nome, 'Não encontrado')   --[...] outra procedure que verifica a existência dele.
print 'Total Salário: ' + cast(@total_salario as varchar(15))  --[...] OU pode-se utilizar a função isNULL({parametro})
------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------

