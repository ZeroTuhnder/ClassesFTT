-----------------------------------------------------------------------------------------------
/*1)	Utilizando o banco de ve�culos, crie uma stored procedure chamada sp_ex_1 que receba
como par�metro um c�digo de UF qualquer, e devolva em uma tabela a m�dia dos rendimentos das
pessoas agrupadas por estado civil desta UF.*/

create procedure sp_ex_1(@uf varchar(2)) as
begin
	select avg(rendimento) 'rendimento m�dio', cod_estado_civil 
	from tb_clientes
	where cod_uf = @uf
	group by cod_estado_civil
end

exec sp_ex_1 RJ
-----------------------------------------------------------------------------------------------
/*2)	Crie uma SP que permita a inclus�o dos dados para uma marca, na tabela de marcas.
Receba como par�metros todos os dados da tabela.*/

create procedure sp_insere_marca(@cod int, @desc nvarchar(50)) as
begin
	insert into tb_marcas(cod_marca, desc_marca)
				           values (@cod, @desc)
end

select * from tb_marcas

exec sp_insere_marca 90, 'PORTARI BRASIL'
-----------------------------------------------------------------------------------------------
/*3)	Baseada na sp criada no exerc�cio 2, fa�a uma altera��o para que o c�digo da marca seja
gerado automaticamente dentro de sua SP*/

create procedure sp_insere_marca2(@desc nvarchar(50)) as
begin
	declare @cod int = (select isnull(max(cod_marca),0) from tb_marcas) + 1

	insert into tb_marcas(cod_marca, desc_marca)
				           values (@cod, @desc)
end

select * from tb_marcas

exec sp_insere_marca2 'PORTARI M�NACO'
-----------------------------------------------------------------------------------------------
/*4)	Crie uma sp que receba como par�metro a marca de um ve�culo, e devolva, tamb�m atrav�s
de par�metros a quantidade de ve�culos que essa marca possui, bem como a quantidade distinta de
UF que os ve�culos dessa marca possuem.*/

create procedure sp_quant_veiculos(@marca nvarchar(50),
									@qtdVeiculos int out,
									@qtdUf int out) as
begin
	declare @cod_marca int = (select cod_marca from tb_marcas
							  where @marca = desc_marca)

	set @qtdVeiculos = (select count(modelo) from tb_alienacao
					    where @cod_marca = cod_marca)

	set @qtdUf = (select count(distinct cod_uf_placa) from tb_alienacao
				  where @cod_marca = cod_marca)
end

select * from tb_alienacao
select * from tb_marcas

declare @qtdVeiculos int
declare @qtdUf int
exec sp_quant_veiculos 'VOLKSWAGEN', @qtdVeiculos out, @qtdUf out
print 'VOLKSWAGEN => Quantidade de ve�culos: ' + isnull(cast(@qtdVeiculos as varchar(10)),0) +
	  ' Quantidades de UFs distintas: ' + isnull(cast(@qtdUf as varchar(10)), 0)
-----------------------------------------------------------------------------------------------
/*5)	Crie uma SP de inclus�o para a tabela de clientes, nela voc� ter� que receber todos os 
dados do cliente. Para que a inclus�o possa ocorrer voc� dever� verificar se os dados de estado
civil e UF existem nas tabelas fortes de estado civil e UF. Caso algum problema ocorra uma 
mensagem dever� ser emitida e a opera��o abortada.*/

create procedure sp_inclusao_clientes(@cod int, @nome varchar(50), @dt_nascimento datetime, 
									  @genero nvarchar(1), @estado_civil nvarchar(1), @rendimento real,
									  @codUf nvarchar(2)) as
begin
	if(exists(select cod_estado_civil from tb_clientes where @estado_civil = cod_estado_civil))
		if(exists(select cod_uf from tb_clientes where @codUf = cod_uf))
			insert into tb_clientes
				values (@cod, @nome, @dt_nascimento, 
									  @genero, @estado_civil, @rendimento,
									  @codUf)
		else
			return -1
	else
		return -1
end

