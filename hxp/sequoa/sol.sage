#!/bin/env sage

from sage.rings.polynomial.polynomial_ring_constructor import PolynomialRing
from sage.rings.finite_rings.finite_field_constructor import GF
from sage.rings.quotient_ring import QuotientRing
from sage.rings.finite_rings.integer_mod_ring import Zmod

from pwn import process
from binascii import unhexlify

N = 359
G = PolynomialRing(GF(2), "x")
x = G.gen()
QUOTIENT = x ** N - 1
R = QuotientRing(G, QUOTIENT)
Q = R.order()
ZQ = Zmod(Q)
PI1_QUOTIENT, PI2_QUOTIENT = [
    quotient_factor
    for quotient_factor, _ in QUOTIENT.factor()
    if quotient_factor != x + 1
]
PI1 = GF(2 ** PI1_QUOTIENT.degree(), name="x1", modulus=PI1_QUOTIENT)
PI2 = GF(2 ** PI2_QUOTIENT.degree(), name="x2", modulus=PI2_QUOTIENT)


def ntl_bytes_to_long(bytes):
    s = 0
    for i, byte in enumerate(bytes):
        s += 256 ** i * byte
    return s


def long_to_poly(long):
    return R([int(b) for b in bin(long)[2:].zfill(N)[::-1]])


def ntl_bytes_to_poly(bytes):
    return long_to_poly(ntl_bytes_to_long(bytes))


def transpose(poly):
    p = list(poly)
    p += [0] * (N - len(p))
    shift = [p[0]] + p[1:][::-1]
    return R(shift)


def _cached_log(base, result):
    """TODO: cache it"""
    return result.log(base)


GEN = ntl_bytes_to_poly([36, 4]).lift()
TGEN = transpose(GEN).lift()


def main():
    p = process("./vuln")
    p.recvlines(3)
    pk = unhexlify(p.recvline(False))
    y = ntl_bytes_to_poly(pk).lift()
    c1 = _cached_log(PI1(GEN), PI1(TGEN))
    c2 = _cached_log(PI2(GEN), PI2(TGEN))
    print(f"{c1 = }")
    print(f"{c2 = }")
    u1 = _cached_log(PI1(GEN), PI1(y))
    u2 = _cached_log(PI2(GEN), PI2(y))
    print(f"{u1 = }")
    print(f"{u2 = }")


if __name__ == "__main__":
    main()
