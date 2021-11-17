# PFL - Trabalho Prático 1

## Resposta ao exercício 4

Comparando os diferentes tipos, (Int -> Int), (Integer -> Integer) e (BigNumber -> BigNumber) observamos que o tipo (Int -> Int) está limitado entre os limites [minBound :: Int, maxBound :: Int] = [-9223372036854775808, 9223372036854775807] e que os tipos (Integer -> Integer) e (BigNumber -> BigNumber) apenas está limitado ao tamanho da memória da máquina.

Comparativamente à resolução das alíneas 1 e 3, a resolução com listas infinitas (alínea 3) é muito mais rápida, independentemente dos tipos, devido à **lazy evaluation** da liguagem haskell. Uma forma fácil de ver é comparando os tempos:  
 -> execução de fibRec 32 demora cerca de **6 segundos**  
 -> execução de fibListaInfinita 32 é **instantâneo**

### (Int -> Int)

Neste tipo o cálculo do enésimo número de Fibonacci está limitado até ao indice 94, pois é o último valor até ocorrer overflow do Int

### (Integer -> Integer) e (BigNumber -> BigNumber)

Comparando estes dois tipos, observamos alguma diferença de tempos até calcular o valor para valores muito grandes, sendo que o cálculo com BigNumbers demora sempre mais do que com Integers, devido a alguma falta de eficiencia das funções que implementam as operações com os BigNumbers. Comparando os tempos:  
 -> execução de fibListaInfinitaINTEGER 10000 é **instantâneo**  
 -> execução de fibListaInfinitaBN (scanner "10000")  demora cerca de **11 segundos**  



