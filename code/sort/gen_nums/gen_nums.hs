import Control.Monad
import System.Random

numOfNums :: Integer
numOfNums = 10^6

file :: FilePath
file = "random_numbers"

main :: IO ()
main =  join
     $  (\(r:rs) -> foldl (\p x -> p >> addToFile (',' : show x)) (writeFile file $ show r) rs)
    <$> foldl (\rs _ -> (:) <$> (randomRIO (1, 1000) :: IO Int) <*> rs) (return []) [1..numOfNums]
     where addToFile = appendFile file
