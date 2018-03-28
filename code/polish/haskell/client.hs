{-# LANGUAGE DataKinds     #-}
{-# LANGUAGE TypeOperators #-}

import           Data.Proxy
import           Network.HTTP.Client
import           Safe
import           Servant.API
import           Servant.Client      as SC
import           System.IO

import           API                 (api)

check :: String -> ClientM Bool
evaluate :: String -> ClientM Float

check :<|> evaluate = client api

baseUrl :: BaseUrl
baseUrl = BaseUrl Http "localhost" 3000 ""

data Action = Check | Evaluate deriving (Show, Read)

printResponse :: Show b => Either ServantError b -> IO ()
printResponse = either (putStrLn . ("Error: " ++) . show . SC.responseBody) print

performAction :: String -> Action -> IO ()
performAction expr action =
  let manager = flip ClientEnv baseUrl <$> newManager defaultManagerSettings
  in manager >>= \m -> case action of
                         Check    -> printResponse =<< runClientM (check expr) m
                         Evaluate -> printResponse =<< runClientM (evaluate expr) m

main :: IO ()
main = do expr <- prompt "Expression: "
          action <- prompt "Action (Check or Evaluate): "
          maybe (print "Invalid action!") (performAction expr) $ readMay action
          where prompt str = putStr str >> hFlush stdout >> getLine
