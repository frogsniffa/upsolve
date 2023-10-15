p = 0x10003
a = 1
b = 0
E = EllipticCurve(GF(p**2, "x", modulus=x**2 + 1), [a, b])
n = 2

torsion_group = set()
while len(torsion_group) < 2:
    P = E.random_point()
    P_order = P.order()
    m = int(P_order / gcd(P_order, n))
    torsion_element = m*P
    if torsion_element != E(0):
        torsion_group.add(torsion_element)
P, Q = torsion_group

while 1:
    a = randint(1, n)
    b = randint(1, n)
    K = a*P + b*Q
    if K != E(0):
        break
print(f"{K = }")
phi = EllipticCurveIsogeny(E, K)
print(f"{phi = }")
# need to change p and n, otherwise dual gets stuck
dual = phi.dual()
print(f"{dual = }")
kernel = phi(K)
assert dual(kernel) == dual(kernel).curve()(0)
