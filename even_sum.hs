foldl' :: (a -> b -> a) -> a -> [b] -> a
foldl' f a []     = a
foldl' f a (x:xs) = seq a' $ foldl' f a' xs
    where a' = f a x

evenSum l = mysum $ filter even l
       where mysum []     = 0
             mysum (x:xs) = x + mysum xs
