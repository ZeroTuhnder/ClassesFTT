------------------------------------------------------------------------------------------------------------
--------------------------------STORED PROCEDURE SUBSTITUTIVA-----------------------------------------------
--Essas SP's fazem parte de um conjunto de stored procedures feitas para substituir diversos comandos para
--[...]realizar valida��es ou padronizar blocos de comandos substituindo os comandos INSERT, DELETE e UPDATE
------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------
--Criando uma procedure para inserir setores na tabela de setores.
use funcionarios

create procedure sp_insere_setor (@setor_id int,
								  @setor_nome varchar(50)) as
begin
	insert into setores (setor_id, setor_nome) values --Um comando INSERT simples que cria um registro
						(@setor_id, @setor_nome)      --[...]Na tabela Setores com os par�metros.

	--Verificando se ocorreu algum erro no processo (n�o obrigat�rio, mas ajuda nos tratamentos de erro)
	if @@ERROR > 0 begin
		print 'Ocorreu um erro na grava��o'
		return -1
	end
	else
		return 0
end

--Chamada
declare @ret int
exec @ret = sp_insere_setor 11, 'Manuten��o'
print @ret

select * from setores
------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------
--Melhorando a SP anterior para n�o ser necess�rio parametrizar o setor_id
--ou seja, o sp definir� o pr�ximo valor para a chave prim�ria

create procedure sp_insere_setor2 (@setor_nome varchar(50)) as
begin
	--Procura o pr�ximo id dos setores
	declare @setor_id int = (Select isnull(max(setor_Id),0) from setores) + 1
	--Esse comando possui o problema de que se dois usu�rios enviarem requisi��es ao mesmo tempo, ocorre
	--[...] um erro no tratamento desses dados, pois h� concorr�ncia entre eles.
	--[...] para evitar esse erro, ter�amos a utiliza��o de uma tabela cujo campo incrementado � identity
	--[...] esse tipo de campo EX: setor_id int primary key identity (1,1) � de autonumera��o
	--[...] iniciando no id 1 e realizando incremento de 1 em 1. Valor encontrado em @@identity.

	insert into setores (setor_id, setor_nome) values --Dessa vez, o setor id � definido por um Select
						(@setor_id, @setor_nome)      

	--Verificando se ocorreu algum erro no processo
	if @@ERROR > 0 begin
		print 'Ocorreu um erro na grava��o'
		return -1
	end
	else
		return 0
end

--Chamada
declare @ret int
exec @ret = sp_insere_setor2 'Manuten��o'
print @ret

select * from setores
------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------
