import BigNumber

fibRec :: Integral a => a -> a
fibRec a | a == 0 = 0
         | a == 1 = 1
         | otherwise = fibRec(a-1) + fibRec(a-2)


fibLista :: Integral a => a -> a
fibLista a = lista !! fromIntegral a where lista = until (\l -> length l - 1 == fromIntegral a) (\l -> l ++ [last l + l !! (length l - 2)]) [0,1]


fibListaInfinita :: Integral a => a -> a
fibListaInfinita a = lista !! fromIntegral a where lista = [0,1] ++ zipWith (+) lista (tail lista)

fibListaInfinitaINT :: Int -> Int --max : 94
fibListaInfinitaINT a = lista !! fromIntegral a where lista = [0,1] ++ zipWith (+) lista (tail lista)

fibListaInfinitaINTEGER :: Integer -> Integer --max : 94
fibListaInfinitaINTEGER a = lista !! fromIntegral a where lista = [0,1] ++ zipWith (+) lista (tail lista)


fibRecBN :: BigNumber -> BigNumber
fibRecBN a  | limpaZeros (snd a) == [0] = (True, [0])
            | limpaZeros (snd a) == [1] = (True, [1])
            | otherwise = somaBN (fibRecBN (subBN a (True, [1])))  (fibRecBN (subBN a (True, [2])))


fibListaBN :: BigNumber -> BigNumber
fibListaBN a = getIndex lista a where lista = until (\l -> subBN (lengthBN l) (True, [1]) == a) (\l -> l ++ [somaBN (last l)  (l !! (length l - 2))]) [(True, [0]),(True, [1])]


fibListaInfinitaBN :: BigNumber -> BigNumber
fibListaInfinitaBN = getIndex lista where lista = [(True, [0]),(True, [1])] ++ zipWith somaBN lista (tail lista)