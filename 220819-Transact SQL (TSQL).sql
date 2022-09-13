---------------------------------------------------------------------------------------------------------------------
-------------------------TRANSACT SQL--------------------------------------------------------------------------------
--Comandos do tipo [Transact] dentro da linguagem sql faz com que ela se assemelhe a um -----------------------------
--[...]Código técnico, diferentemente dos comandos que foram vistos anteriormente. ----------------------------------
---------------------------------------------------------------------------------------------------------------------

--Exemplos de TSQL:
--Criando uma variável [DECLARE]
declare @contador int  --A linguagem obriga que as variáveis sejam declaradas com 'Declare @{nome} {tipo}'
--Atribuindo um valor a uma variável [SET]
set @contador = 1      --[...]é possível atribuir um valor no final do Declare

--Abrindo laços de repetição [WHILE]
while (@contador <= 10) 
begin                           --[BEGIN/END] servem como chaves '{}' no C#, e executam blocos de comando

	--Escrevendo na tela [PRINT]
	print 'Valor: ' + cast(@contador as varchar(4)) --[CAST] realiza a conversão de tipo int para varchar(string)
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

--Abrindo laços de repetição [WHILE]
while (@contador <= 10) 
begin                           

	set @sql = 'INSERT INTO Teste values (' +               --Nesse comando se atribui a uma variável um comando
				cast (@contador as varchar(2)) +            --[...] INSERT para adicionar registros a tabela teste
				', ' + char(39) + 'Texto Qualquer' +        --(perceba que é um comando normal de Sql atribuído em
				char(39) + ')'                              --[...] formato de texto (varchar) a variável sql)


	--Para executar os comandos presentes dentro de uma variável
	--[EXEC]
	exec(@sql)

	--Realizando incremento no contador
	set @contador += 1
end  

select * from teste

drop table teste

---------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------
--Listando todos os funcionarios que possuam o salário menor que a média salarial de todos os funcionários

declare @media decimal(10,2)
--calcular a média atribuindo ela a @media
set @media = (select avg(func_salario) from funcionarios)

print 'Média: '+ Cast(@media as varchar(12))

--listando os funcionários
select * from funcionarios
where func_salario < @media

---------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------
--[CASE] (não pode ser utilizado sozinho) Existem dois tipos de CASE

--Simple Case NÃO RODAR, SIMPLESMENTE DIDÁTICO
case {'variavel'}
	when {'variavel'} = {'expressão lógica'}
		then {'quando expressão lógica anterior verdadeira'}
	else {'default, se não for nenhuma das expressões ateriores'}
end --Lembrar que Case não possui BEGIN, mas possui END

--Searched Case (para cada when ele vai buscar uma expressão verdadeira)
case
	when {'expresão booleana'}  --Perceba que no Case anterior, existe uma variável para ser comparada nesse teste.
		then {'quando expressão booleana é verdadeira'}
	else {'quando nenhuma é verdadeira'}
end

---------------------------------------------------------------------------------------------------------------------
--Exemplo de 'SimpleCase'
select f.func_nome, case f.gerente_id
						when 1 then 'Este é funcionário do gerente 1'
						when 2 then 'Este é funcionário do gerente 2'
						when 3 then 'Este é funcionário do gerente 3'
						else 'Não possui gerente'
					end as tipoGerente    --Os THENS de cada WHEN são atribuídos como valores a uma nova coluna que é
										  --[...]Criada na finalização do CASE
from funcionarios f

---------------------------------------------------------------------------------------------------------------------
--Exemplo de 'SearchedCase'
--diferentemente do SimpleCase, esse não necessita de uma variável para comparação, somente uma expressão booleana

declare @media decimal(10,2)
--calcular a média atribuindo ela a @media
set @media = (select avg(func_salario) from funcionarios)

select *, case
			  when func_salario < @media then 'Abaixo da Média'
			  when func_salario > @media then 'Acima da Média'
			  when func_salario is NULL then NULL
			  else 'Ganha na Média'
		  end tipoSalario
from funcionarios