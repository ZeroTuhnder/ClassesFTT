#Importação das bibliotecas de interesse:
import numpy as np
import matplotlib.pyplot as plt
#Importação da função "funcao_f" definida no arquivo de mesmo nome:
from funcao_f import funcao_f

#Extremo inferior do intervalo onde vamos olhar para o gráfico da função f
x_min = -2
#Extremo superior do intervalo onde vamos olhar para o gráfico da função f
x_max = 2
#Número de pontos intermediários usados ´p/ gerar o gráfico
numero_de_pontos = 400

#Geração de um vetor x com elementos linearmente espaçados entre x_min e x_max
#com número de elementos igual ao valor da variável numero_de_pntos
x = np.linspace(x_min,x_max,numero_de_pontos)

#Cálculo do valor da função f para cada elemento do vetor x:
y = funcao_f(x)

#Valores máximos e mínimos do vetor y (serão usados para definir os eixos
#da figura)
y_max = np.amax(y)
y_min = np.amin(y)

#Resolução da figura:
dpi = 1000
#Criação da figura, com tamanho e resolução especificados
fig, ax = plt.subplots()
fig.set_size_inches(3, 2)
fig.set_dpi(dpi)

#Gera o gráfico, com o vetor x no eixo x e o vetor y no eixo y
ax.plot(x, y)
#Definição dos eixos
ax.axis([x_min, x_max, y_min, y_max])
#Gera a grade para facilitar a leitura do gráfico
ax.grid()
#Nomes de cada eixo:
plt.xlabel(r'$x$')
plt.ylabel(r'$f(x)$')

#Mostra a figura na tela e salva a imagem em formato pdf.
plt.show()
plt.savefig('grafico.pdf', format='pdf', dpi=dpi)