import           Data.Word  (Word16)
-- Word16 is a type for 16 bit unsigned integers
import           Safe       (readMay)
-- readMay is a function for parsing that returns Nothing if it fails to parse
import           Data.List  (sort)
import           Data.Maybe (maybe)
-- maybe :: b -> (a -> b) -> Maybe a -> b

-- FilePath is a type synonym of String

{-| The file with random numbers -}
inputFile :: FilePath
inputFile = "random_number_test"

{-| The output file -}
outputFile :: FilePath
outputFile = "haskell_result_test"

-- The SPECIALIZE pragma tells the compiler to optimize the function for the given type.

{-| Takes a string with comma-separated integers and returns the list of integers.
If the given string is invalid returns Nothing.
-}
{-# SPECIALIZE decode :: String -> Maybe [Word16] #-}
decode :: Read a => String -> Maybe [a]
decode = parseAccum ""
  where parseAccum str (',':cs) = (:) <$> readMay str <*> parseAccum "" cs
        parseAccum str (c:cs)   = parseAccum (str ++ [c]) cs
        parseAccum str []       = (: []) <$> readMay str

{-| Takes a list of values and returns a string with the values separated by commas -}
{-# SPECIALIZE encode :: [Word16] -> String #-}
encode :: Show a => [a] -> String
encode []     = []
encode [x]    = show x
encode (x:xs) = foldl (\p n -> p ++ (',' : show n)) (show x) xs


main :: IO ()
main = (fmap sort . decode :: String -> Maybe [Word16]) <$> readFile inputFile
   >>= maybe (print "Failed to decode!") (writeFile outputFile . encode)
