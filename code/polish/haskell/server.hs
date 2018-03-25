{-# LANGUAGE DataKinds         #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TypeOperators     #-}

import           Data.Proxy
import           Network.Wai
import           Network.Wai.Handler.Warp
import           Safe
import           Servant

import qualified Data.Text.IO             as TIO
import qualified Lackey

import qualified API

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

eval :: (Num a, Fractional a) => Expr a -> a
eval (x :+: y)  = eval x + eval y
eval (x :-: y)  = eval x - eval y
eval (x :*: y)  = eval x * eval y
eval (x :/: y)  = eval x / eval y
eval (Number x) = x

parse :: (Read a, Fractional a) => String -> Maybe (Expr a)
parse = flip parseAccum [] . words
  where parseAccum :: (Read a, Num a) => [String] -> [Expr a] -> Maybe (Expr a)
        parseAccum []       [x]        = Just x
        parseAccum ("+":cs) (x1:x2:xs) = parseAccum cs $ x1 :+: x2 : xs
        parseAccum ("-":cs) (x1:x2:xs) = parseAccum cs $ x1 :-: x2 : xs
        parseAccum ("*":cs) (x1:x2:xs) = parseAccum cs $ x1 :*: x2 : xs
        parseAccum ("/":cs) (x1:x2:xs) = parseAccum cs $ x1 :/: x2 : xs
        parseAccum (str:cs) exprs = readMay str >>= parseAccum cs . (: exprs) . Number
        parseAccum _        _          = Nothing

server :: Server API.API
server = maybe (return False) (const $ return True) . parse
    :<|> maybe invalid return . fmap eval . parse
    where invalid = throwError err400 { errBody = "Invalid expression!" }

app :: Application
app = serve API.api server

main :: IO ()
main = run 3000 app

rubyClient :: FilePath -> IO ()
rubyClient file = TIO.writeFile file $ Lackey.rubyForAPI API.api
