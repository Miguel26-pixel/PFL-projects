import GHC.OldList (genericIndex)

fibRec :: Integral a => a -> a
fibRec a | a == 0 = 0
         | a == 1 = 1
         | otherwise = fibRec(a-1) + fibRec(a-2)

fibLista :: Integral a => a -> a
fibLista a = lista !! fromIntegral a where lista = 0 : 1 : [fibRec x | x <- [2..a]]

fibListaInfinita :: Integral a => a -> a
fibListaInfinita a = lista !! fromIntegral a where lista = [0,1] ++ zipWith (+) lista (tail lista)
