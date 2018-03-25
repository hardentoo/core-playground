{-# LANGUAGE GeneralizedNewtypeDeriving, DeriveDataTypeable, PatternGuards, TupleSections, ViewPatterns #-}

-- | Module for defining and manipulating expressions.
module Language.Core.Operations(
    modLookup,
    fromApps, fromLets, fromLams,
    mkApps, mkLets, mkLams
    )  where

import Language.Core.Type


modLookup :: Module -> Var -> Maybe Exp
modLookup m x = lookup x $ fromModule m

fromApps :: Exp -> (Exp, [Exp])
fromApps (App x y) = (a, b ++ [y])
    where (a,b) = fromApps x
fromApps x = (x,[])

mkApps :: Exp -> [Exp] -> Exp
mkApps x (y:ys) = mkApps (App x y) ys
mkApps x [] = x

fromLams :: Exp -> ([Var], Exp)
fromLams (Lam x y) = (x:a, b)
    where (a,b) = fromLams y
fromLams x = ([], x)

mkLams :: [Var] -> Exp -> Exp
mkLams (y:ys) x = Lam y $ mkLams ys x
mkLams [] x = x

fromLets :: Exp -> ([(Var, Exp)], Exp)
fromLets (Let x y z) = ((x,y):a, b)
    where (a,b) = fromLets z
fromLets x = ([], x)

mkLets :: [(Var, Exp)] -> Exp -> Exp
mkLets [] x = x
mkLets ((a,b):ys) x = Let a b $ mkLets ys x