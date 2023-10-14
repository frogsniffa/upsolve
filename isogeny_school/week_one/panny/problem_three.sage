p = 18446744073709551667
a = 6120164818944
b = 9660707028
E = EllipticCurve(GF(p), [a, b])
assert E.order() == p + 1

R = E.random_element()
assert (p + 1) * R == E(0)
