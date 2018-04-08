module Ver1 where

import Data.Functor

main :: IO ()
main = putStrLn "hello world"

-- Data Declaration
-- Index = index to mark Lorentz type (scalar, vector, tensor and error)
-- Lorentz = Lorentz object
-- Metric = Metric Tensor

data Index = S | V Bool | T [Bool] | Err deriving (Show, Eq)

data Lorentz a = Lorentz Index (Either String [a]) deriving (Show, Eq)

newtype Metric a = Metric [a]

-- Instance Layer
-- Functor, Monad and etc.

instance Functor Lorentz where
  f `fmap` (Lorentz i (Right x)) = Lorentz i (Right (map f x))

-- Useful Functions
-- contraction
-- dual

contraction :: Num a => Lorentz a -> Lorentz a -> Lorentz a
contraction (msg@(Lorentz Err _)) _                     = msg
contraction _                     (msg@(Lorentz Err _)) = msg
contraction (Lorentz S _)         _                     = errMsg1
contraction _                     (Lorentz S _)         = errMsg1
contraction (Lorentz (V u) (Right x)) (Lorentz (V d) (Right y))
  | u /= d    = Lorentz S (Right [sum $ zipWith (*) x y])
  | otherwise = errMsg2

dual :: Num a => Metric a -> Lorentz a -> Lorentz a
dual _ (msg@(   Lorentz Err _)) = msg
dual _ (Lorentz S            _) = errMsg1
dual _ (Lorentz (T _) _) =
  Lorentz Err (Left "Not yet to apply metric to tensor")
dual (Metric g) (Lorentz (V i) (Right x)) =
  Lorentz (V (not i)) (Right (zipWith (*) g x))


-- Error Message
-- errMsg1 = metric to scalar error
-- errMsg2 = Lorentz index matching error

errMsg1 :: Lorentz a
errMsg1 = Lorentz Err (Left "Can't apply metric tensor to Lorentz Scalar")

errMsg2 :: Lorentz a
errMsg2 = Lorentz Err (Left "Lorentz Index Matching Error!")
