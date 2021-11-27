# PFL - Trabalho Prático 1

## Descrição de vários casos de teste para todas as funções

Em cada ficheiro são apresentadas funções relativas aos testes das funções do próprio projeto.

## Explicação sucinta do funcionamento de cada função (exceto as do exercicio 2)

### fibRec

Calcula o resultado da operação Fibonnacci para o valor dado com argumento

### fibLista

Calcula o resultado da operação Fibonnacci para o valor dado com argumento, através da utilização de uma lista finita de valores de Fibonnacci

### fibListaInfinita

Calcula o resultado da operação Fibonnacci para o valor dado com argumento, através da utilização de uma lista infinita de valores de Fibonnacci

### fibRecBN

Calcula o resultado da operação Fibonnacci para o valor dado com argumento do tipo BigNumber

### fibListaBN

Calcula o resultado da operação Fibonnacci para o valor dado com argumento do tipo BigNumber, através da utilização de uma lista finita de valores de Fibonnacci do tipo BigNUmber

### fibListaInfinitaBN

Calcula o resultado da operação Fibonnacci para o valor dado com argumento do tipo BigNumber, através da utilização de uma lista infinita de valores de Fibonnacci do tipo BigNumber

### somaArray

Calcula a soma entre valores de duas listas positivos

### maiorOuIgualModulo

Dados dois valores do tipo BigNumber, verifica se o primeiro é maior ou igual (em módulo) em relação ao segundo

### subArray

Calcula a subtração entre valores de duas listas positivos

### limpaZeros

Remove os zeros há direita do array que são desnecessários para a representação do número

### mulBNCarry

Função auxiliar para fazer a múltiplicação de dois arrays de digitos, independentemente do sinal

### getLista

Função que retorna uma lista de BigNumbers que representam os números de 0 até ao BigNumber passado como argumento

### getIndex

Função que retorna um BigNumber de uma lista de BigNumbers que está num certo índice do array

### lengthBN

Função que retorna um BigNumber que representa o tamanho de uma lista de uma lista de BigNumbers

## Estratégias utilizadas na implementação das funções da alínea 2

### scanner

Verificar se string começa com '-' para obter o sinal do número e depois passar cada caracter correspondente a um número para Int através dos códigos ASCII

### output

Caso for falso começar com o caracter '-' que representa o sinal do número e depois passar cada digito do array para o caracter correspondente através dos códigos ASCII

### somaBN

O algoritmo feito começava por ver os sinais pois caso apenas um dos números fosse negativo (equivalente a uma subtração) então chamava o método subBN, e após essa verificação foi implementado o algoritmo básico da soma que percorre os algoritmos correspondentes e faz a sua adição

### subBN

O algoritmo feito começava por ver os sinais pois caso apenas um dos números fosse negativo (equivalente a uma adição) então chamava o método somaBN, e após essa verificação foi implementado o algoritmo básico da subtração que percorre os algoritmos correspondentes e faz as operações necessárias

### mulBN

O algoritmo desenvolvido para a múltiplicação começava por obter o sinal do valor que irá ser obtido no fim e depois foi implementado o algoritmo básico da multiplicação que faz as operações necessárias

### divBN

O algoritmo desenvolvido para a divisão adiciona 1 ao quociente até que a subtração do acumulador com o divisor seja menor que zero e após isso é calculado o resto utilizando a função mod

### safeDivBN

Foi utilizado o mesmo algoritmo do que a divBN mas este verificava se o divisor era zero, para o qual é impossivel fazer a divisão e por isso retornava Nothing, caso contrário retorna o valor da divisão

## Resposta ao exercício 4

Comparando os diferentes tipos, (Int -> Int), (Integer -> Integer) e (BigNumber -> BigNumber) observamos que o tipo (Int -> Int) está limitado entre os limites [minBound :: Int, maxBound :: Int] = [-9223372036854775808, 9223372036854775807] e que os tipos (Integer -> Integer) e (BigNumber -> BigNumber) apenas está limitado ao tamanho da memória da máquina.

Comparativamente à resolução das alíneas 1 e 3, a resolução com listas infinitas é muito mais rápida, independentemente dos tipos, devido à **lazy evaluation** da liguagem haskell. Uma forma fácil de ver é comparando os tempos:  
 -> execução de fibRec 33 demora cerca de **11 segundos**
 -> execução de fibLista 10000 demora cerca de **5 segundos**  
 -> execução de fibListaInfinita 100000 demora menos de **1 segundo**

### (Int -> Int)

Neste tipo o cálculo do enésimo número de Fibonacci está limitado até ao indice 94, pois é o último valor até ocorrer overflow do Int.

### (Integer -> Integer) e (BigNumber -> BigNumber)

Comparando estes dois tipos, observamos alguma diferença de tempos até calcular o valor para valores muito grandes, sendo que o cálculo com BigNumbers demora sempre mais do que com Integers, devido a alguma falta de eficiencia das funções que implementam as operações com os BigNumbers. Comparando os tempos:  
 -> execução de fibListaInfinitaINTEGER 10000 é **instantâneo**  
 -> execução de fibListaInfinitaBN (scanner "10000")  demora cerca de **11 segundos**  

