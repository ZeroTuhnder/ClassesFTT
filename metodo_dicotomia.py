def metodo_dicotomia(a,b,precisao_desejada):
    #Entradas: a: extremo inferior do intervalo inicial
    #          b: extremo superior fo intervalo inicial
    #          precisao_desejada: precisão com que se deseja conhecer a raiz

    #Importação da função "funcao_f":
    from funcao_f import funcao_f
    
    #Calculo do erro maximo considerando o intervalo inicial:
    erro_max = b - a

    #Inicialização do numero de iteracoes:
    numero_iteracoes = 0
    #Enquanto o erro maximo cometido for maior que a precisão desejada, faça:
    while erro_max > precisao_desejada:
        #A partir daqui, vocês devem completar
        #Variável fa recebe o valor da função f calculada em a:
        fa = funcao_f(a)
        x = (a+b)/2
        fx = funcao_f(x)
        
        if (fa * fx) > 0:
            a = x
        else:
            b = x
            
        if (erro_max > precisao_desejada):
            numero_iteracoes = numero_iteracoes + 1
            
        erro_max = b - a

    #Calculo da estimativa final
    estimativa_final = (a + b)/2
    #Impressão do número de iterações na tela    
    print('Número de iterações: ', numero_iteracoes)
    #Função retorna o valor da estimativa final:
    return estimativa_final