from tqdm import tqdm

p = 2**127 - 1
a = 1
b = 0
E = EllipticCurve(GF(p**2, "x", modulus=x**2 + 1), [a, b])
P = E.random_element()
while P.order() != 2**127:
    P = E.random_element()
print(f"{P = }")

isogenies = []
for i in tqdm(range(127)):
    kernel = 2**(127 - i - 1) * P
    isogeny = EllipticCurveIsogeny(kernel.curve(), kernel)
    assert isogeny.degree() == 2
    P = isogeny(P)
    isogenies.append(isogeny)

kernel = P
for isogeny in isogenies:
    kernel = isogeny(kernel)
assert kernel == kernel.curve()(0)
