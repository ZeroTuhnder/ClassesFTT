def funcao_f(x):
    #Entrada: valor de x para o qual desejamos obter o valor de f(x)
    
    #Importação da biblioteca numpy
    import numpy as np
    #Calculo da função f(x) - x^3 + exp(-x^2)    
    f = x**3-np.exp(-(x**2))
    #Retorna o valor da função f para o valor de x recebido na entrada
    return f