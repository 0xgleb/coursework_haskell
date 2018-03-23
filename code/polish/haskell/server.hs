{-# LANGUAGE DataKinds         #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TypeOperators     #-}

import           Control.Monad.Trans
import           Data.Proxy
-- import           Data.Text
import           Network.Wai
import           Network.Wai.Handler.Warp
import           Safe
import           Servant

infixl 6 :+:
infixl 6 :-:
infixl 7 :*:
infixl 7 :/:

data Expr a = Expr a :+: Expr a
            | Expr a :-: Expr a
            | Expr a :*: Expr a
            | Expr a :/: Expr a
            | Number a
            deriving Show

parse :: (Read a, Num a) => String -> Maybe (Expr a)
parse = flip parseAccum []
  where parseAccum :: (Read a, Num a) => String -> [Expr a] -> Maybe (Expr a)
        parseAccum []       [x]        = Just x
        parseAccum ('+':cs) (x1:x2:xs) = parseAccum cs $ x1 :+: x2 : xs
        parseAccum ('-':cs) (x1:x2:xs) = parseAccum cs $ x1 :-: x2 : xs
        parseAccum ('*':cs) (x1:x2:xs) = parseAccum cs $ x1 :*: x2 : xs
        parseAccum ('/':cs) (x1:x2:xs) = parseAccum cs $ x1 :/: x2 : xs
        parseAccum (' ':cs) exprs      = parseAccum cs exprs
        parseAccum str      exprs      = readMay (takeWhile (/= ' ') str)
                                     >>= parseAccum (dropWhile (/= ' ') str) . (: exprs) . Number

type API = ReqBody '[JSON] String :> Post '[JSON] String

server :: Server API
server = return . maybe "invalid" (const "valid") . parse

api :: Proxy API
api = Proxy

app :: Application
app = serve api server

main :: IO ()
main = run 3000 app
