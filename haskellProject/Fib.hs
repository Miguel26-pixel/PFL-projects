import BigNumber

{-
calcula o enésimo número de Fibonacci de forma recursiva. Tem como argumento um valor do tipo Integral
-}
fibRec :: Integral a => a -> a
fibRec a | a == 0 = 0
         | a == 1 = 1
         | otherwise = fibRec(a-1) + fibRec(a-2)

{-
calcula o enésimo número de Fibonacci utilizando programação dinamica. Tem como argumento um valor do tipo Integral
-}
fibLista :: Integral a => a -> a
fibLista a  | a == 0 = 0
            | otherwise = lista !! fromIntegral a where lista = until (\l -> length l - 1 == fromIntegral a) (\l -> l ++ [last l + l !! (length l - 2)]) [0,1]

{-
calcula o enésimo número de Fibonacci utilizando uma lista infinita. Tem como argumento um valor do tipo Integral
-}
fibListaInfinita :: Integral a => a -> a
fibListaInfinita a = lista !! fromIntegral a where lista = [0,1] ++ zipWith (+) lista (tail lista)

{-
calcula o enésimo número de Fibonacci utilizando uma lista infinita. Tem como argumento um valor do tipo Int
esta função foi criada para o desenvolvimento da pergunta 4 como forma de comparação com a fibListaInfinita
-}
fibListaInfinitaINT :: Int -> Int --max : 94
fibListaInfinitaINT a = lista !! fromIntegral a where lista = [0,1] ++ zipWith (+) lista (tail lista)

{-
calcula o enésimo número de Fibonacci utilizando uma lista infinita. Tem como argumento um valor do tipo Integer
esta função foi criada para o desenvolvimento da pergunta 4 como forma de comparação com a fibListaInfinita
-}
fibListaInfinitaINTEGER :: Integer -> Integer --max : 94
fibListaInfinitaINTEGER a = lista !! fromIntegral a where lista = [0,1] ++ zipWith (+) lista (tail lista)

{-
calcula o enésimo número de Fibonacci de forma recursiva. Tem como argumento um valor do tipo BigNummber e retorna um valor do mesmo tipo
-}
fibRecBN :: BigNumber -> BigNumber
fibRecBN a  | limpaZeros (snd a) == [0] = (True, [0])
            | limpaZeros (snd a) == [1] = (True, [1])
            | otherwise = somaBN (fibRecBN (subBN a (True, [1])))  (fibRecBN (subBN a (True, [2])))

{-
calcula o enésimo número de Fibonacci utilizando programação dinamica. Tem como argumento um valor do tipo BigNummber e retorna um valor do mesmo tipo
-}
fibListaBN :: BigNumber -> BigNumber
fibListaBN a    | a == scanner "0" = a
                | otherwise = getIndex lista a where lista = until (\l -> subBN (lengthBN l) (True, [1]) == a) (\l -> l ++ [somaBN (last l)  (l !! (length l - 2))]) [(True, [0]),(True, [1])]

{-
calcula o enésimo número de Fibonacci utilizando uma lista infinita. Tem como argumento um valor do tipo BigNummber e retorna um valor do mesmo tipo
-}
fibListaInfinitaBN :: BigNumber -> BigNumber
fibListaInfinitaBN = getIndex lista where lista = [(True, [0]),(True, [1])] ++ zipWith somaBN lista (tail lista)



{-
Funções para teste. Calculam os 10 primeiros valores e o resultado é comparado com valores de uma lista fixa e préviamente feita. Caso algum valor falhe retorna falso.
Sendo as funções recursivas basta apenas testar para os 10 primeiros valores, pois para valores maiores a forma de cálculo será sempre igual
-}
fibData :: [Int]
fibData = [0,1,1,2,3,5,8,13,21,34,55]

fibDataBN :: [BigNumber ]
fibDataBN = [(True,[0]),(True,[1]),(True,[1]),(True,[2]),(True,[3]),(True,[5]),(True,[8]),(True,[3,1]),(True,[1,2]),(True,[4,3]),(True,[5,5])]

testeFib :: Bool
testeFib = [fibRec x | x <- [0..10]] == fibData

testeFibBN :: Bool
testeFibBN = [fibRecBN x | x <- getLista (scanner "10")] == fibDataBN

testeFibLista :: Bool
testeFibLista = [fibLista x | x <- [0..10]] == fibData

testeFibListaBN :: Bool
testeFibListaBN = [fibListaBN x | x <- getLista (scanner "10")] == fibDataBN

testeFibListaInfinita :: Bool
testeFibListaInfinita = [fibListaInfinita x | x <- [0..10]] == fibData

testeFibListaInfinitaBN :: Bool
testeFibListaInfinitaBN = [fibListaInfinitaBN x | x <- getLista (scanner "10")] == fibDataBN