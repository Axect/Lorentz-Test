module Main where

import Data.Functor
import Data.List

main :: IO ()
main = do
  let g = Lorentz (T [D Mu, D Nu]) -- Metric Tensor
      x = Lorentz (T [U Nu]) -- Contravariant Vector
      y = Lorentz (T [D Nu]) -- Covariant Vector
  print $ g <> x
  print $ g <> y
  print $ x <> y

------------------------
-- Data Declaration
------------------------

data Greek = Mu | Nu | Rho | Sigma deriving (Show, Eq)

data Index = U Greek | D Greek deriving (Show, Eq)

data LX = S | T [Index] deriving (Show, Eq)

data Lorentz = Lorentz LX | Err String deriving (Show, Eq)

------------------------
-- Instance Layer
------------------------

(<>) :: Monoid a => a -> a -> a
(<>) x y = x `mappend` y

instance Monoid Lorentz where
  mempty = Lorentz (T [])
  Lorentz (T i) `mappend` Lorentz (T j)
    | null i && null j = Lorentz S
    | null i           = Lorentz (T j)
    | null j           = Lorentz (T i)
    | null hat         = Err "Can't Contract"
    | otherwise        = Lorentz (T remX) `mappend` Lorentz (T remY)
    where hat =  i `intersect` map dualIndex j
          remX = do
            e <- hat
            filter (/=e) i
          remY = do
            f <- map dualIndex hat
            filter (/=f) j


dualIndex :: Index -> Index
dualIndex (U i) = D i
dualIndex (D i) = U i
