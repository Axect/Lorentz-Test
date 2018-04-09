module Ver2 where

import Data.List
import Data.Functor

main :: IO ()
main = do
  let a = 1
  print a

----------------------------
-- Data Declaration
----------------------------
data Greek = Mu | Nu | Rho | Sigma deriving (Show, Eq)

data Pos = U Greek | D Greek deriving (Show, Eq)

data Index = S | T [Pos] deriving (Show, Eq)

data Tensor a = Tensor Index (Either String [a]) deriving (Show, Eq)

----------------------------
-- Instance Section
----------------------------
instance Functor Tensor where
  f `fmap` Tensor i (Right x) = Tensor i (Right (map f x))

instance Monoid (Tensor a) where
  mempty = Tensor (T []) (Right [])
  t `mappend` Tensor (T []) (Right _) = t
  Tensor (T i) (Right x) `mappend` Tensor (T j) (Right y)
    | null i    = Tensor (T j) (Right y)
    | null j    = Tensor (T i) (Right x)
    | null hat  = Tensor S (Left "Can't Contract")
    | otherwise = Tensor (T remX) (Right x) `mappend` Tensor (T remY) (Right y)
    where hat  = i `intersect` map dualPos j
          remX = do
            e <- hat
            filter (/=e) i
          remY = do
            e <- hat
            filter (/= dualPos e) j


----------------------------
-- Functions
----------------------------

dualPos :: Pos -> Pos
dualPos (U a) = D a
dualPos (D a) = U a

----------------------------
-- Define Operator Section
----------------------------
-- Mappend Operator Overloading
(<>) :: Monoid a => a -> a -> a
(<>) x y = x `mappend` y
