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
-}
scanner :: String -> BigNumber
scanner s   | head s == '-' = (False ,[fromEnum x - 48 | x <- reverse (tail s)])
            | otherwise = (True, [fromEnum x - 48 | x <- reverse s])

{-
Função que dado um BigNumber converte para String para uma melhor leitura do número
-}
output :: BigNumber -> String
output a    | fst a = [toEnum (x + 48)::Char | x <- reverse (snd a)]
            | otherwise = '-' : [toEnum (x + 48)::Char | x <- reverse (snd a)]

{-
Função que soma dois BigNumbers e retorna o resultado obtido
-}
somaBN :: BigNumber -> BigNumber -> BigNumber
somaBN a b  | fst a && fst b = (True, somaArray (snd a) (snd b) 0)
            | fst a && not (fst b) = subBN a (True, snd b)
            | not (fst a) && fst b = subBN b (True, snd a)
            | otherwise = (False, somaArray (snd a) (snd b) 0)

{-
Função auxiliar para fazer a soma de dois arrays de digitos independentemente do sinal
-}
somaArray :: [Int] -> [Int] -> Int -> [Int]
somaArray [] [] c = [] -- [0]
somaArray a [] c = a
somaArray [] b c = b
somaArray (x:xs) (y:ys) c   | x + y + c > 9 = mod (x + y + c) 10 : somaArray (if null xs then [0] else xs) (if null ys then [0] else ys) 1--números positivos
                            | otherwise = x + y + c: somaArray xs ys 0

{-
Função que compara dois BigBumbers e retorna True no caso de o primeiro ser maior ou igual ao segundo e False caso contrário
-}
maiorOuIgualModulo :: BigNumber -> BigNumber -> Bool
maiorOuIgualModulo (_,[]) (_,[]) = True
maiorOuIgualModulo (a,x) (b,y)  | length x > length y = True --errado por causa dos zeros
                                | length y > length x = False --errado por causa dos zeros
                                | otherwise = if last x /= last y then last x >= last y else maiorOuIgualModulo (a,init x) (b, init y)

{-
Função que subtrai dois BigNumbers e retorna o resultado obtido
-}
subBN :: BigNumber -> BigNumber -> BigNumber --maior em primeiro'
subBN a (_,[]) = a
subBN (_,[]) (b,y) = (not b,y)
subBN a b   | fst a && fst b = if maiorOuIgualModulo a b then (True, limpaZeros (subArray (snd a) (snd b) 0)) else (False, limpaZeros (subArray (snd b) (snd a) 0))
            | fst a && not (fst b) = somaBN a b
            | not (fst a) && fst b = (False, somaArray (snd a) (snd b) 0)
            | otherwise = if maiorOuIgualModulo b a then (True, limpaZeros (subArray (snd b) (snd a) 0)) else (False, limpaZeros (subArray (snd a) (snd b) 0))

{-
Função auxiliar para fazer a subtração de dois arrays de digitos independentemente do sinal
Ter em atenção que o número representado pelo primeiro array deve ser maior ou igual do que o módulo do segundo número
-}
subArray :: [Int] -> [Int] -> Int -> [Int]
subArray a [] c = a
subArray [] b c = b
subArray (x:xs) (y:ys) c    | x < y + c = x + 10 - y - c : subArray (if null xs then [0] else xs) (if null ys then [0] else ys) 1
                            | otherwise = x - y - c: subArray xs ys 0

{-
Remove os zeros há direita do array que são desnecessários para a representação do número
-}
limpaZeros :: [Int] -> [Int]
limpaZeros l = reverse (until (\x -> (x == [0]) || (head x /= 0)) tail (reverse l))

{-
Função que multiplica dois BigNumbers e retorna o resultado obtido
-}
mulBN :: BigNumber -> BigNumber -> BigNumber
mulBN a (_,[]) = (True,[0])
mulBN (_,[]) b = (True,[0])
mulBN (a,x) (b,y:ys) = (not a /= b, somaArray (mulBNCarry x [y] 0) (0 : snd (mulBN (a,x) (b,ys))) 0)

{-
Função auxiliar para fazer a múltiplicação de dois arrays de digitos independentemente do sinal
-}
mulBNCarry :: [Int] -> [Int] -> Int -> [Int]
mulBNCarry a [] c = []
mulBNCarry [] b c = []
mulBNCarry (x:xs) (y:ys) c  | x * y + c > 9 = mod (x * y + c) 10 : mulBNCarry (if null xs then [0] else head xs : tail xs) [y] (div (x*y+c) 10)
                            | otherwise = x * y + c : mulBNCarry xs [y] 0

{-
Função que divide dois BigNumbers e retorna o resultado obtido
-}
divBN :: BigNumber -> BigNumber -> (BigNumber,BigNumber)
divBN a b   | not (maiorOuIgualModulo a b) = ((True, [0]), a)
            | otherwise = last (until (\[(w,x),(y,z)] -> not (fst (subBN z x))) (\[(w,x),(y,z)] -> [(w,x),(somaBN y (True,[1]), subBN z x)]) [(a,b),((True,[0]),a)])

{-
Função que divide dois BigNumbers e retorna um tuplo com o quociente e o resto da divisão obtido tendo cuidado com as divisões por zero, as quais retorna Nothing
-}
safeDivBN :: BigNumber -> BigNumber -> Maybe (BigNumber,BigNumber)
safeDivBN a b   | limpaZeros (snd b) == [0] = Nothing 
                | not (maiorOuIgualModulo a b) = Just ((True, [0]), a)
                | otherwise = Just (last (until (\[(w,x),(y,z)] -> not (fst (subBN z x))) (\[(w,x),(y,z)] -> [(w,x),(somaBN y (True,[1]), subBN z x)]) [(a,b),((True,[0]),a)]))

{-
Função que retorna uma lista de BigNumbers que representam os números de 0 até ao BigNumber passado como argumento
-}
getLista :: BigNumber -> [BigNumber]
getLista a = until (\x -> last x == a) (\x -> x ++ [somaBN (last x) (True,[1])]) [(True,[0])]

{-
Função que retorna um BigNumber de uma lista de BigNumbers que está num certo indice do array
-}
getIndex :: [BigNumber] -> BigNumber -> BigNumber
getIndex a b = head (fst (until (\(x, y) -> y == (True, [0])) (\(x, y) ->  (tail x, subBN y (True, [1]))) (a,b)))

{-
Função que retorna um BigNumber que representa o tamanho de uma lista de uma lista de BigNumbers
-}
lengthBN :: [BigNumber] -> BigNumber
lengthBN = foldr (\_ x -> somaBN x (True, [1])) (True, [0])
