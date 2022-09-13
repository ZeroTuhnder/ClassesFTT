------------------------------------------------------------------------------------------------------------
--------------------------------STORED PROCEDURE SUBSTITUTIVA-----------------------------------------------
--Essas SP's fazem parte de um conjunto de stored procedures feitas para substituir diversos comandos para
--[...]realizar validações ou padronizar blocos de comandos substituindo os comandos INSERT, DELETE e UPDATE
------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------
--Criando uma procedure para inserir setores na tabela de setores.
use funcionarios

create procedure sp_insere_setor (@setor_id int,
								  @setor_nome varchar(50)) as
begin
	insert into setores (setor_id, setor_nome) values --Um comando INSERT simples que cria um registro
						(@setor_id, @setor_nome)      --[...]Na tabela Setores com os parâmetros.

	--Verificando se ocorreu algum erro no processo (não obrigatório, mas ajuda nos tratamentos de erro)
	if @@ERROR > 0 begin
		print 'Ocorreu um erro na gravação'
		return -1
	end
	else
		return 0
end

--Chamada
declare @ret int
exec @ret = sp_insere_setor 11, 'Manutenção'
print @ret

select * from setores
------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------
--Melhorando a SP anterior para não ser necessário parametrizar o setor_id
--ou seja, o sp definirá o próximo valor para a chave primária

create procedure sp_insere_setor2 (@setor_nome varchar(50)) as
begin
	--Procura o próximo id dos setores
	declare @setor_id int = (Select isnull(max(setor_Id),0) from setores) + 1
	--Esse comando possui o problema de que se dois usuários enviarem requisições ao mesmo tempo, ocorre
	--[...] um erro no tratamento desses dados, pois há concorrência entre eles.
	--[...] para evitar esse erro, teríamos a utilização de uma tabela cujo campo incrementado é identity
	--[...] esse tipo de campo EX: setor_id int primary key identity (1,1) é de autonumeração
	--[...] iniciando no id 1 e realizando incremento de 1 em 1. Valor encontrado em @@identity.

	insert into setores (setor_id, setor_nome) values --Dessa vez, o setor id é definido por um Select
						(@setor_id, @setor_nome)      

	--Verificando se ocorreu algum erro no processo
	if @@ERROR > 0 begin
		print 'Ocorreu um erro na gravação'
		return -1
	end
	else
		return 0
end

--Chamada
declare @ret int
exec @ret = sp_insere_setor2 'Manutenção'
print @ret

select * from setores
------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------
