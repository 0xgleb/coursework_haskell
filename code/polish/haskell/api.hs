{-# LANGUAGE DataKinds     #-}
{-# LANGUAGE TypeOperators #-}

module API where

import           Data.Proxy
import           Servant

type API = "check" :> ReqBody '[JSON] String :> Post '[JSON] Bool
      :<|> "evaluate" :> ReqBody '[JSON] String :> Post '[JSON] Float

api :: Proxy API
api = Proxy
