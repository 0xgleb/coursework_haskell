{-# LANGUAGE OverloadedStrings #-}

import qualified Data.ByteString.Lazy.Char8 as C
import           Data.List                  (sort)

main :: IO ()
main = C.readFile "random_numbers"
   >>= maybe (print "Failed to parse!")
             ( C.writeFile "haskell_result"
             . C.intercalate "," . fmap (C.pack . show) . sort . fmap fst
             ) . traverse C.readInt . C.split ','
