import Control.Monad
import System.Random

main :: IO ()
main =  join
     $  (\(r:rs) -> foldl (\p x -> p >> addToFile (',' : show x)) (writeFile file $ show r) rs)
    <$> foldl (\rs _ -> (:) <$> (randomRIO (1, 1000) :: IO Int) <*> rs) (return []) [1..10]
     where addToFile = appendFile file
           file = "random_numbers_test"
