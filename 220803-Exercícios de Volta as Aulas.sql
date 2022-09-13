use funcionarios --Selecona o banco de dados

select func_nome, setor_nome from funcionarios f            --Mostra os funcionarios e seus respectivos setores
	inner join setores s on s.setor_id = f.setor_id         --[...]somente os que tem setores

select setor_nome, count (f.func_id) qtdFunc from funcionarios f  -- contar os funcionarios
	right join setores s on s.setor_id = f.setor_id               --[...]de cada setor (0 se o setor não possui funcionarios)
	group by s.setor_nome                                         --[...]agrupados pelo nome do setor

select setor_nome, count (f.func_id) as qtdFunc from funcionarios f -- contar os funcionarios
	right join setores s on s.setor_id = f.setor_id                 --[...]que possuem setores (porém todos os setores)
	group by s.setor_nome                                           --[...]agrupados pelo nome do setor
	having count(f.func_id) > 0                                     --[...]só os setores que possuem funcionários

select s.setor_nome, f.func_nome from funcionarios f       --Listar todos os funcionarios e seus setores
	inner join setores s on s.setor_id = f.setor_id		   --[...] somente os que possuem setores
	where s.setor_nome like '%o%'						   --[...] e cujos setores possuem a letra "o"

	------------------------------------------------------------------------------------------------------------------------