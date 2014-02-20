import Data.Maybe

-- practical 2
type RegExp a = [a] -> (Maybe [a], [a])

nil :: RegExp a
nil a = (Just [], a)

range :: (a -> Bool) -> RegExp a
range _ [] = (Nothing, [])
range func ss@(c:cs) | func c = (Just [c], cs)
                | otherwise = (Nothing, ss)

--(a -> Bool) -> [a] -> (Maybe [a], [a])
