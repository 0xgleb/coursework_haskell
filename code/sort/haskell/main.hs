import           Data.Word  (Word16)
-- Word16 is a type for 16 bit unsigned integers
import           Safe       (readMay)
-- readMay is a function for parsing that returns Nothing if it fails to parse
import           Data.List  (sort)
import           Data.Maybe (maybe)

decode :: String -> Maybe [Word16]
decode = parseAccum ""
  where parseAccum :: String -> String -> Maybe [Word16]
        parseAccum str (',':cs) = (:) <$> readMay str <*> parseAccum "" cs
        parseAccum str (c:cs)   = parseAccum (str ++ [c]) cs
        parseAccum str []       = (: []) <$> readMay str

encode :: [Word16] -> String
encode []     = []
encode [x]    = show x
encode (x:xs) = foldl (\p n -> p ++ (',' : show n)) (show x) xs

main :: IO ()
main = fmap sort . decode <$> readFile "random_numbers"
   >>= maybe (print "Failed to decode!") (writeFile "haskell_result" . encode)
