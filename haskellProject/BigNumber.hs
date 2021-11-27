module BigNumber(
    BigNumber,
    scanner,
    output,
    somaBN,
    subBN,
    mulBN,
    divBN,
    safeDivBN,
    getIndex,
    getLista,
    lengthBN,
    limpaZeros
) where

{-
Type BigNumber corresponde a um tuplo em que o primeiro elemento é do tipo Bool que simboliza o sinal do BigNumber (True -> positivo ; False -> negativo) 
e um segundo elemento que é um array de Int que corresponde aos digitos do número a representar

Ter em atenção que o array de Int começa no último digito do número a representar para depois facilitar as operações
-}
type BigNumber = (Bool, [Int]) -- True -> positivo ; False -> negativo

{-
Função que dada uma String converte em BigNumber (armazena os digitos do ínicio para o fim)
 1 -> caso a string comece com o caracter '-' irá returnar um BigNumber com sinal negativo
 2 -> caso contrário irá retornar um BigNumber positivo 

A string é passada para o array de digitos fazendo a conversão de cada caracter para digito através dos códigos ASCII com listas por compreensão
-}
scanner :: String -> BigNumber
scanner s   | head s == '-' = (False ,[fromEnum x - 48 | x <- reverse (tail s)])  --1)
            | otherwise = (True, [fromEnum x - 48 | x <- reverse s]) --2)

{-
Função que dado um BigNumber converte para String para uma melhor leitura do número
 1 -> caso for BigNumber positivo então será construida uma string de números
 2 -> caso contrário irá retornar uma string de números iniciada com o caracter '-' 

O array de digitos é passado para String fazendo a conversão de cada digito para caracter através dos códigos ASCII com listas por compreensão
-}
output :: BigNumber -> String
output a    | fst a = [toEnum (x + 48)::Char | x <- reverse (snd a)] --1)
            | otherwise = '-' : [toEnum (x + 48)::Char | x <- reverse (snd a)] --2)

{-
Função que soma dois BigNumbers e retorna o resultado obtido
 1 -> caso ambos os números sejam positivos é retornado um outro número positivo em que o array de digitos é calculado através da somaArray
 2 -> caso o primeiro número for positivo e o segundo negativo então é retornado o valor da subtração do primeiro pelo segundo, mudando o sinal do segundo para positivo de forma a facilitar o cálculo da subtração
 3 -> caso o primeiro número for negativo e o segundo positivo então é retornado o valor da subtração do segundo pelo primeiro, mudando o sinal do primeiro para positivo de forma a facilitar o cálculo da subtração
 4 -> caso ambos os números sejam negativos é retornado um outro número negativo em que o array de digitos é calculado através da somaArray
-}
somaBN :: BigNumber -> BigNumber -> BigNumber
somaBN a b  | fst a && fst b = (True, somaArray (snd a) (snd b) 0) --1)
            | fst a && not (fst b) = subBN a (True, snd b) --2)
            | not (fst a) && fst b = subBN b (True, snd a) --3)
            | otherwise = (False, somaArray (snd a) (snd b) 0) --4)

{-
Função auxiliar para fazer a soma de dois arrays de digitos independentemente do sinal com um valor adicional nos casos onde a soma dos digitos dá mais que 9 caso seja necessário
 1 -> caso base onde ambas as listas passadas como argumentos são vazias é retornada uma lista vazia
 2 -> caso base onde a segunda lista passada como argumento está vazia é retornada o valor do primeiro argumento
 3 -> caso base onde a primeira lista passada como argumento está vazia é retornada o valor do segundo argumento
 4 -> caso onde a soma dos digitos é maior que 9, então é calculado o resto por 10 que vai ser o digito no indice e passado um carry igual a 1 para o próximo indice da lista a ser calculado
 5 -> caso base onde o digito é a soma dos indices iniciais de cada lista e do valor adicional 
-}
somaArray :: [Int] -> [Int] -> Int -> [Int]
somaArray [] [] c = [] --1)
somaArray a [] c = a --2)
somaArray [] b c = b --3)
somaArray (x:xs) (y:ys) c   | x + y + c > 9 = mod (x + y + c) 10 : somaArray (if null xs then [0] else xs) (if null ys then [0] else ys) 1 --4)
                            | otherwise = x + y + c: somaArray xs ys 0 --5)

{-
Função que compara dois BigBumbers e retorna True no caso de o primeiro ser maior ou igual ao segundo e False caso contrário. 
Antes de executar a função é necessário que ambos os bigNumbers sejam formatados pela função limpaZeros pois pode ocorrer erros devido a zeros adicionais.
 1 -> caso base onde os dois BigNumber são vazios, ou seja, têm valor igual 
 2 -> caso em que o comprimento da lista do primeiro for maior que o segundo
 3 -> caso em que o comprimento da lista do segundo for maior que o primeiro
 4 -> verificação recursiva digito a digito para comparar listas de tamanhos idênticos
-}
maiorOuIgualModulo :: BigNumber -> BigNumber -> Bool
maiorOuIgualModulo (_,[]) (_,[]) = True --1)
maiorOuIgualModulo (a,x) (b,y)  | length x > length y = True --2)
                                | length y > length x = False --3)
                                | otherwise = if last x /= last y then last x >= last y else maiorOuIgualModulo (a,init x) (b, init y) --4)

{-
Função que subtrai dois BigNumbers e retorna o resultado obtido
 1 -> caso base onde o segundo BigNumber é vazio, ou seja, irá ser retornado o primeiro BigNumber
 2 -> caso base onde o primeiro BigNumber é vazia, ou seja, irá ser retornado o segundo BigNumber com o sinal trocado
 3 -> caso ambos os números sejam positivos, os valores dos dois são comparados e feito a conta com o maior no primeiro argumento, o sinal depende de qual for o maior
 4 -> caso o primeiro número for positivo e o segundo negativo então é retornado o valor da soma das listas do primeiro pelo segundo e o sinal é obrigatóriamente positivo
 5 -> caso o primeiro número for negativo e o segundo positivo então é retornado o valor da soma das listas do primeiro pelo segundo e o sinal é obrigatóriamente negativo
 6 -> caso ambos os números sejam negativos, os valores dos dois são comparados e feito a conta com o maior no primeiro argumento, o sinal depende de qual for o maior
-}
subBN :: BigNumber -> BigNumber -> BigNumber --maior em primeiro'
subBN a (_,[]) = a --1)
subBN (_,[]) (b,y) = (not b,y) --2)
subBN a b   | fst a && fst b = if maiorOuIgualModulo (fst a, limpaZeros (snd a)) (fst b, limpaZeros (snd b)) then (True, limpaZeros (subArray (snd a) (snd b) 0)) else (False, limpaZeros (subArray (snd b) (snd a) 0)) --3)
            | fst a && not (fst b) = (True, somaArray (snd a) (snd b) 0) --4)
            | not (fst a) && fst b = (False, somaArray (snd a) (snd b) 0) --5)
            | otherwise = if maiorOuIgualModulo (fst b, limpaZeros (snd b)) (fst a, limpaZeros (snd a)) then (True, limpaZeros (subArray (snd b) (snd a) 0)) else (False, limpaZeros (subArray (snd a) (snd b) 0)) --6)

{-
Função auxiliar para fazer a subtração de dois arrays de digitos independentemente do sinal
Ter em atenção que o número representado pelo primeiro array deve ser maior ou igual do que o módulo do segundo número
 1 -> caso base onde a segunda lista é vazia é retornado o valor do primeiro
 2 -> caso o digito inical seja menor que a soma entre o do segundo com o valor adicional então acrescenta-se 10 ao valor e retira-se 1 ao próximo indice
 3 -> caso contrário é o valor da subtração entre o digito inicial do primeiro com o digito inicial do segundo e o valor adicional
-}
subArray :: [Int] -> [Int] -> Int -> [Int]
subArray a [] c = a --1)
subArray (x:xs) (y:ys) c    | x < y + c = x + 10 - y - c : subArray (if null xs then [0] else xs) (if null ys then [0] else ys) 1 --2)
                            | otherwise = x - y - c: subArray xs ys 0 --3)

{-
Remove os zeros há direita do array que são desnecessários para a representação do número
 1 -> enquanto elemento da direita da lista for zero então é retirado da lista com tail
-}
limpaZeros :: [Int] -> [Int]
limpaZeros l = reverse (until (\x -> (x == [0]) || (head x /= 0)) tail (reverse l)) --1)

{-
Função que multiplica dois BigNumbers e retorna o resultado obtido
 1 -> caso base em que o segundo elemento é vazio então é retornado o BigNumber zero
 2 -> caso base em que o primeiro elemento é vazio então é retornado o BigNumber zero
 3 -> é feita a soma de cada multiplicação entre o primeiro e cada digito do segundo, multiplicando por 10 por cada digito que passa (algoritmo base da multiplicação)
-}
mulBN :: BigNumber -> BigNumber -> BigNumber
mulBN a (_,[]) = (True,[0]) --1
mulBN (_,[]) b = (True,[0]) --2
mulBN (a,x) (b,y:ys) = (not a /= b, somaArray (mulBNCarry x y 0) (0 : snd (mulBN (a,x) (b,ys))) 0) --3

{-
Função auxiliar para fazer a múltiplicação de uma lista correspondente aos dígitos e um digito independentemente do sinal
 1 -> caso base em que o priemiro elemento é vazio então é retornado uma lista vazia
 2 -> caso em que a soma da múltiplicação entre os digitos com o carry é maior que 9 então o digito é calculado através do resto e o carry através da divisão inteira
 3 -> caso base do algoritmo da múltiplicação
-}
mulBNCarry :: [Int] -> Int -> Int -> [Int]
mulBNCarry [] b c = [] --1)
mulBNCarry (x:xs) y c   | x * y + c > 9 = mod (x * y + c) 10 : mulBNCarry (if null xs then [0] else head xs : tail xs) y (div (x*y+c) 10) --2)
                        | otherwise = x * y + c : mulBNCarry xs y 0 --3)

{-
Função que divide dois BigNumbers e retorna o resultado obtido
 1 -> caso base em que o divisor é maior que o dividendo retornando assim o quociente igual a zero e resto irá ser igual ao valor do dividendo
 2 -> é somado 1 ao quociente até o acumulador (subtrações consecutivas do divisor) seja menor que zero, ou seja até ser um BigBumber negativo
-}
divBN :: BigNumber -> BigNumber -> (BigNumber,BigNumber)
divBN a b   | not (maiorOuIgualModulo (fst a, limpaZeros (snd a)) (fst b, limpaZeros (snd b))) = ((True, [0]), a) --1)
            | otherwise = last (until (\[(w,x),(y,z)] -> not (fst (subBN z x))) (\[(w,x),(y,z)] -> [(w,x),(somaBN y (True,[1]), subBN z x)]) [(a,b),((True,[0]),a)]) --2)

{-
Função que divide dois BigNumbers e retorna um tuplo com o quociente e o resto da divisão obtido tendo cuidado com as divisões por zero, as quais retorna Nothing
 1 -> feita a verificação do divisor pois este não pode ser zero, é retornado Nothing
 2 -> caso seja possivel a divisão esta chama a função divBN e retorna o resultado obtido
-}
safeDivBN :: BigNumber -> BigNumber -> Maybe (BigNumber,BigNumber)
safeDivBN a b   | limpaZeros (snd b) == [0] = Nothing --1) 
                | otherwise = Just (divBN a b) --2

{-
Função que retorna uma lista de BigNumbers que representam os números de 0 até ao BigNumber passado como argumento. Pode ser percebida como [0..a] mas com BigNumbers
 1 -> lista formada por números consecutivos somando 1 ao último valor até um certo valor passado como argumento
-}
getLista :: BigNumber -> [BigNumber]
getLista a = until (\x -> last x == a) (\x -> x ++ [somaBN (last x) (True,[1])]) [(True,[0])] --1)

{-
Função que retorna um BigNumber de uma lista de BigNumbers que está num certo indice do array
 1 -> retira o primeiro valor do array quando o indice for zero, a este é lhe subtraido 1 a cada iteração
-}
getIndex :: [BigNumber] -> BigNumber -> BigNumber
getIndex a b = head (fst (until (\(x, y) -> y == (True, [0])) (\(x, y) ->  (tail x, subBN y (True, [1]))) (a,b))) --1)

{-
Função que retorna um BigNumber que representa o tamanho de uma lista de uma lista de BigNumbers
 1 -> é somado 1 por cada elemento na lista, obtendo assim o comprimento da lista em BigNumbers 
-}
lengthBN :: [BigNumber] -> BigNumber
lengthBN = foldr (\_ x -> somaBN x (True, [1])) (True, [0]) --1)

{-
Funções para teste. Foram criadas 2 listas com BigNumbers que representa o primeiro e o segundo operador e para cada operação foi criado um array com o resultado da operação entre os 2 BigNumbers no mesmo índice na lista.
Por fim foi comparado a lista com os resultados feitos manualmente com o resultado usando as funções definidas para os BigNumbers
-}
fibDataBN :: [BigNumber ]
fibDataBN = [(True,[0]),(True,[1]),(True,[2]),(True,[3]),(True,[4]),(True,[5]),(True,[6]),(True,[7]),(True,[8]),(True,[9]),(True,[0,1])]

fibDataLeftBN :: [BigNumber ]
fibDataLeftBN = [(True,[0,3,4,6,2]),(True,[1,2,3,5,9,5]),(False,[2,1,3,5,6,8]),(False,[3,6,5,4,7]),(True,[4,2]),(False,[5,1,3,4])]

fibDataRightBN :: [BigNumber ]
fibDataRightBN = [(True,[1,4,6,4,2]),(False,[2,3]),(True,[4,5,3]),(False,[2,5,7]),(True,[5]),(False,[7,4,5])]

fibDataSomaBN :: [BigNumber ]
fibDataSomaBN = [(True,[1,7,0,1,5]),(True,[9,8,2,5,9,5]),(False,[8,5,9,4,6,8]),(False,[5,1,3,5,7]),(True,[9,2]),(False,[2,6,8,4])]

fibDataSubBN :: [BigNumber ]
fibDataSubBN = [(True,[9,8,7,1]),(True,[3,5,3,5,9,5]),(False,[6,6,6,5,6,8]),(False,[1,1,8,3,7]),(True,[9,1]),(False,[8,6,7,3])]

fibDataMulBN :: [BigNumber ]
fibDataMulBN = [(True,[0,3,6,1,6,2,1,5,6]),(False,[2,7,2,0,5,0,9,1]),(False,[8,4,4,0,2,3,6,0,3]),(True,[6,7,3,1,7,0,6,5]),(True,[0,2,1]),(True,[5,0,3,0,6,3,2])]

fibDataDivBN :: [(BigNumber,BigNumber) ]
fibDataDivBN = [((True,[1]),(True,[9,8,7,1])),((True,[3,0,6,8,1]),(True,[5,2])),((True,[4,4,4,2]),(True,[6,3,1])),((True,[9,9]),(True,[5,1,1])),((True,[4]),(True,[4])),((True,[7]),(True,[6,8,4]))]

testeSoma :: Bool
testeSoma = testeSomaAux fibDataRightBN fibDataLeftBN == fibDataSomaBN

testeSomaAux :: [BigNumber] -> [BigNumber] -> [BigNumber]
testeSomaAux [] [] = []
testeSomaAux (x:xs) (y:ys) = somaBN x y : testeSomaAux xs ys

testeSub :: Bool
testeSub = testeSubAux fibDataLeftBN fibDataRightBN == fibDataSubBN

testeSubAux :: [BigNumber] -> [BigNumber] -> [BigNumber]
testeSubAux [] [] = []
testeSubAux (x:xs) (y:ys) = subBN x y : testeSubAux xs ys

testeMul :: Bool
testeMul = testeMulAux fibDataLeftBN fibDataRightBN == fibDataMulBN

testeMulAux :: [BigNumber] -> [BigNumber] -> [BigNumber]
testeMulAux [] [] = []
testeMulAux (x:xs) (y:ys) = mulBN x y : testeMulAux xs ys

testeDiv :: Bool
testeDiv = testeDivAux [(True, snd x) | x <- fibDataLeftBN] [(True, snd x) | x <- fibDataRightBN] == fibDataDivBN

testeDivAux :: [BigNumber] -> [BigNumber] -> [(BigNumber, BigNumber)]
testeDivAux [] [] = []
testeDivAux (x:xs) (y:ys) = divBN x y : testeDivAux xs ys

testeSafeDiv :: Bool
testeSafeDiv = safeDivBN (scanner "123") (scanner "0") == Nothing && testeDiv

testeGetLista :: Bool
testeGetLista = getLista (True,[0,1]) == fibDataBN

testeGetIndex :: Bool
testeGetIndex = [getIndex fibDataBN x | x <- fibDataBN] == fibDataBN

testeLength :: Bool
testeLength = lengthBN fibDataBN == (True,[1,1])




