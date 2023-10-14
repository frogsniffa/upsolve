from tqdm import tqdm

p = 18446744073709551667
a = 1
b = 0
# CSIDH uses F_p^2
E = EllipticCurve(GF(p**2, "x", modulus=x**2 + 1), [a, b])
n = 4999

# solving for the root of the nth division polynomial is infeasible
# http://tcs.uj.edu.pl/~mistar/pdf/Miller2004WeilPairing.pdf
torsion_group = set()
while len(torsion_group) < 2:
    P = E.random_point()
    P_order = P.order()
    m = int(P_order / gcd(P_order, n))
    torsion_element = m*P
    if torsion_element != E(0):
        assert n * torsion_element == E(0)
        torsion_group.add(torsion_element)

print(f"{torsion_group = }")
P, Q = torsion_group


def get_random_point_from_E_n():
    i = randint(1, n)
    j = randint(1, n)
    return i*P + j*Q


R = get_random_point_from_E_n()
two_sum = dict()
for i in tqdm(range(1, n)):
    two_sum[i*P] = i
for i in tqdm(range(1, n)):
    jP = R - i*Q
    if jP in two_sum:
        j = two_sum[jP]
        assert i*Q + j*P == R
        print(f"{i = }\n{j = }")
        break
