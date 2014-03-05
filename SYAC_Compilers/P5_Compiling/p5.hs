import Fresh

dualcmp :: Cmp -> Cmp
dualcmp Eql = Neq
dualcmp Neq = Eql
dualcmp Lt = Gte
dualcmp Gte = Lt
