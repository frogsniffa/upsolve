from tqdm import tqdm

p = 18446744073709551667
a = 1
b = 0
# CSIDH uses F_p^2. copy this from CSIDH code
E = EllipticCurve(GF(p**2, "x", modulus=x**2 + 1), [a, b])
n = 4999

# nth torsion group could be solved algebraically by recursively repeating
# the multiplication by n map and solving for denominator = 0
# but that takes too much time.
# solving for the root of the elliptic curve nth division polynomial is infeasible too,
# which is just a refined multiplication by n map focusing on the denominator.
# https://link.springer.com/article/10.1007/s00145-004-0315-8
# the definition of an n-torsion group is the set of points such that n * point == E(0)
# so find random points, get their order, and divide that order by n.
# l-torsion subgroup are modules of rank at most two == torsion group set length <= 2
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
