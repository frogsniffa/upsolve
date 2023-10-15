from sage.schemes.elliptic_curves.ell_point import EllipticCurvePoint_finite_field

p = 2**32 - 5
a = 0
b = 1
F = GF(p**2, "x", modulus=x**2 + 1)
E = EllipticCurve(F, [a, b])
q = F.order() - 1
# https://crypto.stackexchange.com/questions/63614/finding-the-n-th-root-of-unity-in-a-finite-field
# check third root of unity is possible
assert q % 3 == 0
zeta = F.random_element() ** (q // 3)
print(f"{zeta = }")
# ensure that zeta is root of unity
assert zeta**3 == 1


def pi(point):
    x, y = point.xy()
    return E(x**p, y**p)


def omega(point):
    x, y = point.xy()
    return E(zeta * x, y)


def theta(point):
    return point - omega(point) + pi(point) - omega(pi(point))


n = 3
torsion_group = set()
while len(torsion_group) < 2:
    P = E.random_point()
    P_order = P.order()
    m = int(P_order / gcd(P_order, n))
    torsion_element = m*P
    if torsion_element != E(0):
        torsion_group.add(torsion_element)
P, Q = torsion_group
assert theta(P) == E(0)
assert theta(Q) == E(0)
