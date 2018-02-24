def accumSum(l, n):
    if(len(l) == 0):
        return n
    else:
        x, *xs = l
        if(x % 2 == 0):
            return accumSum(xs, x + n)
        else:
            return accumSum(xs, n)

def evenSum(l):
    return accumSum(l, 0)

print(evenSum([1, 2, 3, 4, 5]))
