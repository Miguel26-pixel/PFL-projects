type BigNumber = [Int]

--'0' = 48

scanner :: String -> BigNumber
scanner s = [fromEnum x - 48 | x <- s]

output :: BigNumber -> String
output a = [toEnum (x + 48)::Char | x <- a]

somaBN :: BigNumber -> BigNumber -> BigNumber --assumindo que números estão ao contrário
somaBN a [] = a
somaBN [] b = b
somaBN (x:xs) (y:ys)    | x + y > 9 = mod (x + y) 10 : somaBN (if null xs then [1] else (1 + head xs) : tail xs) ys --números positivos
                        | otherwise = x + y : somaBN xs ys

subBN :: BigNumber -> BigNumber -> BigNumber --maior em primeiro'
subBN a [] = a
subBN [] b = b
subBN (x:xs) (y:ys) | x < y = x + 10 - y : subBN ((head xs - 1) : tail xs) ys
                    | otherwise = x - y : subBN xs ys

mulBN :: BigNumber -> BigNumber -> BigNumber
mulBN a [] = []
mulBN [] b = []
mulBN (x:xs) (y:ys) = somaBN (mulBNCarry (x:xs) [y] 0) (0 : mulBNCarry (x:xs) ys 0)

mulBNCarry :: BigNumber -> BigNumber -> Int -> BigNumber
mulBNCarry a [] c = []
mulBNCarry [] b c = []
mulBNCarry (x:xs) (y:ys) c  | x * y + c > 9 = mod (x * y + c) 10 : mulBNCarry (if null xs then [0] else head xs : tail xs) [y] (div (x*y+c) 10)
                            | otherwise = x * y + c : mulBNCarry xs [y] 0

--divBN :: BigNumber -> BigNumber -> (BigNumber, BigNumber)
--divBN a b = until (\(x,y) -> y == 0) (\(x,y) -> (y,mod x y)) (a,b)