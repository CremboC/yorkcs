import Data.Maybe

-- practical 2
type RegExp a = [a] -> (Maybe [a], [a])

nil :: RegExp a
nil a = (Just [], a)

--range :: (a -> Bool) -> RegExp a
--range func (s:ss) = if func s then (Just ss, ss) else (Just ss, ss)


    --(a -> Bool) -> [a] -> (Maybe [a], [a])
