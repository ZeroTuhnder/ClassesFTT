/* Exercício subselect - Utilize para a solução o banco
de dados de locadora
Para cada exercício resolva-o com JOIN e depois com 
SubSelect*/
use Locadora

---------------------------------------------------------------------------------------------------------------

--1) Liste todos os dados dos filmes e o nome do genero (join)
select m.*, descricao as genero from Midias m
left join Genero g on m.codGenero = g.Codgenero

select m.*, 
	(Select descricao 
	from Genero g 
	where m.codGenero = g.Codgenero) Gênero
from Midias m
---------------------------------------------------------------------------------------------------------------

--2) Liste o nome do cliente e a quantidade de locações feitas por ele (join e group)
select c.Cliente, count(l.CodCli) from Cliente c
left join Locacao l on l.CodCli = c.CodCli
group by c.Cliente

select c.Cliente,
	(select Count(l.CodCli) 
	from Locacao l
	where l.CodCli = c.CodCli) qtdeLocacoes
from Cliente c
---------------------------------------------------------------------------------------------------------------

--3) Resolva o exercicio anterior mostrando somente os clientes que possuem mais que 2 locações 
--(join grouping e having)
select c.Cliente, count(l.CodCli) from Cliente c
left join Locacao l on l.CodCli = c.CodCli
group by c.Cliente
having count(l.CodCli) > 2

select c.Cliente,
	(select Count(l.CodCli) 
	from Locacao l
	where l.CodCli = c.CodCli) qtdeLocacoes
from Cliente c
where (select Count(l.CodCli) 
	from Locacao l
	where l.CodCli = c.CodCli) > 2

---------------------------------------------------------------------------------------------------------------
--4)Liste para cada locação a data da locação, o nome do filme e o nome do cliente (join)
select l.CodLocacao, l.DataLoc, c.Cliente, m.descMidia from locacao l
inner join cliente c on c.CodCli = l.CodCli
inner join ItensLocacao i on i.CodLocacao = l.CodLocacao
inner join Midias m on m.CodMidia = i.CodMidia

select i.CodLocacao,                    
	(select m.descMidia                            --O nome da mídia está diretamente ligado a ItensLocacao
	from midias m
	where m.CodMidia = i.codMidia) nomeMidia,
	(select l.DataLoc                              --A Data de Locacao está diretamente ligado a ItensLocacao
	from locacao l
	where l.CodLocacao = i.CodLocacao) DataLoc,
	(select                                        --O nome do cliente, por outro lado, não está relacionado diretamente a ItensLoc
		(select c.Cliente                          --[...] Por isso precisamos de dois subselects, um dentro do outro, ligando duas tabelas
		from Cliente c
		where c.CodCli = l.CodCli)
	from locacao l
	where l.CodLocacao = i.CodLocacao) NomeCli
from ItensLocacao i

---------------------------------------------------------------------------------------------------------------
--5)Faça a soma de todos os valores unitários de todos os filmes locados para cada locação. 
--Mostrando o numero  da locação e sua somatoria só JOINs

select CodLocacao, Sum(m.ValorUnit) Somatoria from ItensLocacao i
inner join midias m on m.CodMidia = i.CodMidia
group by CodLocacao