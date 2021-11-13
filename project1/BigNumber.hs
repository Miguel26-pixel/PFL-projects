type BigNumber = (Bool, [Int]) -- True -> positivo ; False -> negativo

scanner :: String -> BigNumber
scanner s   | head s == '-' = (False ,[fromEnum x - 48 | x <- reverse (tail s)])
            | otherwise = (True, [fromEnum x - 48 | x <- reverse s])


output :: BigNumber -> String
output a    | fst a = [toEnum (x + 48)::Char | x <- reverse (snd a)]
            | otherwise = '-' : [toEnum (x + 48)::Char | x <- reverse (snd a)]


somaBN :: BigNumber -> BigNumber -> BigNumber
somaBN a b  | fst a && fst b = (True, somaArray (snd a) (snd b) 0)
            | fst a && not (fst b) = subBN a b
            | not (fst a) && fst b = subBN a b
            | otherwise = (False, somaArray (snd a) (snd b) 0)


somaArray :: [Int] -> [Int] -> Int -> [Int]
somaArray [] [] c = [] -- [0]
somaArray a [] c = a
somaArray [] b c = b
somaArray (x:xs) (y:ys) c   | x + y + c > 9 = mod (x + y + c) 10 : somaArray (if null xs then [0] else xs) (if null ys then [0] else ys) 1--números positivos
                            | otherwise = x + y + c: somaArray xs ys 0


maiorOuIgualModulo :: BigNumber -> BigNumber -> Bool
maiorOuIgualModulo (_,[]) (_,[]) = True
maiorOuIgualModulo (a,x) (b,y)  | length x > length y = True --errado por causa dos zeros
                                | length y > length x = False --errado por causa dos zeros
                                | otherwise = if last x /= last y then last x >= last y else maiorOuIgualModulo (a,init x) (b, init y)


subBN :: BigNumber -> BigNumber -> BigNumber --maior em primeiro'
subBN a (_,[]) = a
subBN (_,[]) (b,y) = (not b,y)
subBN a b   | fst a && fst b = if maiorOuIgualModulo a b then (True, limpaZeros (subArray (snd a) (snd b) 0)) else (False, limpaZeros (subArray (snd b) (snd a) 0))
            | fst a && not (fst b) = somaBN a b
            | not (fst a) && fst b = (False, somaArray (snd a) (snd b) 0)
            | otherwise = if maiorOuIgualModulo b a then (True, limpaZeros (subArray (snd b) (snd a) 0)) else (False, limpaZeros (subArray (snd a) (snd b) 0))


subArray :: [Int] -> [Int] -> Int -> [Int]
subArray a [] c = a
subArray [] b c = b
subArray (x:xs) (y:ys) c    | x < y + c = x + 10 - y - c : subArray (if null xs then [0] else xs) (if null ys then [0] else ys) 1
                            | otherwise = x - y - c: subArray xs ys 0


limpaZeros :: [Int] -> [Int]
limpaZeros l = reverse (until (\x -> (x == [0]) || (head x /= 0)) tail (reverse l))


mulBN :: BigNumber -> BigNumber -> BigNumber
mulBN a (_,[]) = (True,[0])
mulBN (_,[]) b = (True,[0])
mulBN (a,x) (b,y:ys) = (not a /= b, somaArray (mulBNCarry x [y] 0) (0 : snd (mulBN (a,x) (b,ys))) 0)


mulBNCarry :: [Int] -> [Int] -> Int -> [Int]
mulBNCarry a [] c = []
mulBNCarry [] b c = []
mulBNCarry (x:xs) (y:ys) c  | x * y + c > 9 = mod (x * y + c) 10 : mulBNCarry (if null xs then [0] else head xs : tail xs) [y] (div (x*y+c) 10)
                            | otherwise = x * y + c : mulBNCarry xs [y] 0


divBN :: BigNumber -> BigNumber -> (BigNumber,BigNumber)
divBN a b   | not (maiorOuIgualModulo a b) = ((True, [0]), a)
            | otherwise = last (until (\[(w,x),(y,z)] -> not (fst (subBN z x))) (\[(w,x),(y,z)] -> [(w,x),(somaBN y (True,[1]), subBN z x)]) [(a,b),((True,[0]),a)])


safeDivBN :: BigNumber -> BigNumber -> Maybe (BigNumber,BigNumber)
safeDivBN a b   | limpaZeros (snd b) == [0] = Nothing 
                | not (maiorOuIgualModulo a b) = Just ((True, [0]), a)
                | otherwise = Just (last (until (\[(w,x),(y,z)] -> not (fst (subBN z x))) (\[(w,x),(y,z)] -> [(w,x),(somaBN y (True,[1]), subBN z x)]) [(a,b),((True,[0]),a)]))

