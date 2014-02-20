import Data.List
import Data.Maybe

-- examples from http://www.cs.nott.ac.uk/~gmh/book.html
double x    = x + x

quadruple x = double (double x)

factorial n = product [1..n]

average ns = sum ns `div` length ns

-- examples from 
-- http://www-module.cs.york.ac.uk/syac/compilers/SLIDES/1_Haskell.pdf
data Day = Mon | Tue | Wed deriving Show

sportsday :: Day
sportsday = Wed

tomorrow :: Day -> Day
tomorrow Mon = Tue
tomorrow Tue = Wed

-- practical 1; 3.1
d2n :: Char -> Int
d2n c = case x of
        Nothing -> error "That wasn't a digit"
        Just n -> n 
    where x = lookup c $ zip ['0'..'9'] [0..9]

-- foldl1 <function> <list>
s2n :: String -> Int
s2n = (foldl1 f) . (map d2n)
    where f a b = a * 10 + b

    --"56"
    --5, 6
    --a * 10 + b
    --56

-- 3.2
whitespace :: Char -> Bool
whitespace c = elem c [' ', '\n', '\r', '\t'] 

dropLeadingWhitespace :: String -> String
dropLeadingWhitespace = dropWhile whitespace

-- 3.3
type V = String
type N = Int
data E = Var V | Val N | Plus E E | Mult E E deriving Eq

-- fancy show
instance Show E where
    show (Var v) = v
    show (Val v) = show v
    show (Plus e0 e1) = "(" ++ show e0 ++ " + " ++ show e1 ++ ")"
    show (Mult e0 e1) = "(" ++ show e0 ++ " * " ++ show e1 ++ ")"

evaluate :: E -> Int
evaluate (Var v) = error ("evaluate: attempted to acc variable")
evaluate (Val n) = n
evaluate (Plus a b) = (evaluate a) + (evaluate b)
evaluate (Mult a b) = (evaluate a) * (evaluate b)

-- original simplify
-- <funcname> <input pattern> = <what to do with pattern>
simplify :: E -> E
simplify (Mult e (Val 1)) = simplify e
simplify (Mult e0 e1) = Mult (simplify e0) (simplify e1)
simplify (Plus e0 e1) = Plus (simplify e0) (simplify e1)
simplify e = e

-- improved simplify
simplify2 :: E -> E
simplify2 (Mult e f) | simpleE == Val 0 || simpleF == Val 0 = Val 0
                    | simpleE == Val 1 = simpleF
                    | simpleF == Val 1 = simpleE
                    | otherwise = Mult simpleE simpleF
    where simpleF = simplify2 f
          simpleE = simplify2 e
simplify2 (Plus e f) | simpleE == Val 0 = simpleF
                   | simpleF == Val 0 = simpleE
                   | otherwise = Plus simpleE simpleF
    where simpleE = simplify2 e
          simpleF = simplify2 f
simplify2 e = e

-- (Mult (Val 1) (Mult (Val 1) (Val 1)))

-- 3.4
type Assoc a = [(String, a)]

-- test assoc array
test :: Assoc Int
test = [("x", 4), ("y", 2), ("z", 0)]

test2 = [("x", 4)]

names :: Assoc a -> [String]
names xs = map f xs
    where f s = fst s

inAssoc :: String -> Assoc a -> Bool
inAssoc s xs = s `elem` (names xs)
