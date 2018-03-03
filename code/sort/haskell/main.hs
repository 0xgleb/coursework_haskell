{-# LANGUAGE OverloadedStrings #-}

import qualified Data.ByteString.Lazy.Char8 as C
import           Data.List                  (sort)

{-| The file with random numbers -}
inputFile :: FilePath
inputFile = "random_numbers"

{-| The output file -}
outputFile :: FilePath
outputFile = "haskell_result"

get :: IO C.ByteString
get = C.readFile inputFile

parse :: C.ByteString -> Maybe [Int]
parse = fmap (fmap fst) . traverse C.readInt . C.split ','

s :: Ord a => [a] -> [a]
s = sort

pack :: [Int] -> C.ByteString
pack = C.intercalate "," . fmap (C.pack . show)

put :: C.ByteString -> IO ()
put = C.writeFile outputFile

{-| The main IO action reads numbers from the input file, sorts them and
writes sorted numbers to the output file
-}
main :: IO ()
main =
  get >>= maybe (print "Failed to parse!") (put . pack . s) . parse
