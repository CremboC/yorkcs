type Parse t = (Bool, [t])
type Parser t = [t] -> Parse t
terminal:: t -> Parser t
terminal t (e:es)
        | t == e = (True, es)
        | otherwise = (False, (e:es))

infixr 5 +>
(+>) :: Eq t => Parser t ->Parser t
(f +> g) ts
        | f = g rf
        | otherwise = (False, ts)
        where
        (qf, rf) = f ts


infixl 4 <>
(<>) :: Eq t => Parser t -> Parser t -> Parser t
(f <> g) ts | b = fts
            | otherwise = g ts
where fts@(b, _) = f ts

empty :: Parser t
empty "" = (Just [], "")
