---------------------------------------------------------------------------------------------------------------------
-------------------------TRANSACT SQL--------------------------------------------------------------------------------
--Comandos do tipo [Transact] dentro da linguagem sql faz com que ela se assemelhe a um -----------------------------
--[...]C�digo t�cnico, diferentemente dos comandos que foram vistos anteriormente. ----------------------------------
---------------------------------------------------------------------------------------------------------------------

--Exemplos de TSQL:
--Criando uma vari�vel [DECLARE]
declare @contador int  --A linguagem obriga que as vari�veis sejam declaradas com 'Declare @{nome} {tipo}'
--Atribuindo um valor a uma vari�vel [SET]
set @contador = 1      --[...]� poss�vel atribuir um valor no final do Declare

--Abrindo la�os de repeti��o [WHILE]
while (@contador <= 10) 
begin                           --[BEGIN/END] servem como chaves '{}' no C#, e executam blocos de comando

	--Escrevendo na tela [PRINT]
	print 'Valor: ' + cast(@contador as varchar(4)) --[CAST] realiza a convers�o de tipo int para varchar(string)
													--[...] para que ele seja exibido em texto.

	--Realizando incremento no contador
	set @contador += 1
end                             --[...]Da mesma forma, [End] finaliza o bloco de comando

---------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------
--usando TSQL para gerar registros

use funcionarios
create table teste
(
	codigo int primary key,
	descricao varchar(40)
)


declare @contador int
declare @sql varchar(200) --Para conter o comando insert


set @contador = 1

--Abrindo la�os de repeti��o [WHILE]
while (@contador <= 10) 
begin                           

	set @sql = 'INSERT INTO Teste values (' +               --Nesse comando se atribui a uma vari�vel um comando
				cast (@contador as varchar(2)) +            --[...] INSERT para adicionar registros a tabela teste
				', ' + char(39) + 'Texto Qualquer' +        --(perceba que � um comando normal de Sql atribu�do em
				char(39) + ')'                              --[...] formato de texto (varchar) a vari�vel sql)


	--Para executar os comandos presentes dentro de uma vari�vel
	--[EXEC]
	exec(@sql)

	--Realizando incremento no contador
	set @contador += 1
end  

select * from teste

drop table teste

---------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------
--Listando todos os funcionarios que possuam o sal�rio menor que a m�dia salarial de todos os funcion�rios

declare @media decimal(10,2)
--calcular a m�dia atribuindo ela a @media
set @media = (select avg(func_salario) from funcionarios)

print 'M�dia: '+ Cast(@media as varchar(12))

--listando os funcion�rios
select * from funcionarios
where func_salario < @media

---------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------
--[CASE] (n�o pode ser utilizado sozinho) Existem dois tipos de CASE

--Simple Case N�O RODAR, SIMPLESMENTE DID�TICO
case {'variavel'}
	when {'variavel'} = {'express�o l�gica'}
		then {'quando express�o l�gica anterior verdadeira'}
	else {'default, se n�o for nenhuma das express�es ateriores'}
end --Lembrar que Case n�o possui BEGIN, mas possui END

--Searched Case (para cada when ele vai buscar uma express�o verdadeira)
case
	when {'expres�o booleana'}  --Perceba que no Case anterior, existe uma vari�vel para ser comparada nesse teste.
		then {'quando express�o booleana � verdadeira'}
	else {'quando nenhuma � verdadeira'}
end

---------------------------------------------------------------------------------------------------------------------
--Exemplo de 'SimpleCase'
select f.func_nome, case f.gerente_id
						when 1 then 'Este � funcion�rio do gerente 1'
						when 2 then 'Este � funcion�rio do gerente 2'
						when 3 then 'Este � funcion�rio do gerente 3'
						else 'N�o possui gerente'
					end as tipoGerente    --Os THENS de cada WHEN s�o atribu�dos como valores a uma nova coluna que �
										  --[...]Criada na finaliza��o do CASE
from funcionarios f

---------------------------------------------------------------------------------------------------------------------
--Exemplo de 'SearchedCase'
--diferentemente do SimpleCase, esse n�o necessita de uma vari�vel para compara��o, somente uma express�o booleana

declare @media decimal(10,2)
--calcular a m�dia atribuindo ela a @media
set @media = (select avg(func_salario) from funcionarios)

select *, case
			  when func_salario < @media then 'Abaixo da M�dia'
			  when func_salario > @media then 'Acima da M�dia'
			  when func_salario is NULL then NULL
			  else 'Ganha na M�dia'
		  end tipoSalario
from funcionarios