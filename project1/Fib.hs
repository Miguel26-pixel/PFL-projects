import BigNumber

fibRec :: Integral a => a -> a
fibRec a | a == 0 = 0
         | a == 1 = 1
         | otherwise = fibRec(a-1) + fibRec(a-2)


fibLista :: Integral a => a -> a
fibLista a = lista !! fromIntegral a where lista = [fibRec x | x <- [0..a]]


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
fibListaBN a = getIndex lista a where lista = [fibRecBN x | x <- getLista a]


fibListaInfinitaBN :: BigNumber -> BigNumber
fibListaInfinitaBN a = getIndex lista a where lista = [(True, [0]),(True, [1])] ++ zipWith somaBN lista (tail lista)