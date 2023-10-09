#!/usr/bin/env python3

from pwn import process
from vuln import mkaes
from binascii import unhexlify


class BitsCalculator:
    def __init__(self, p, c, r):
        self.p = p
        self.c = c
        self.r = r
        self.chosen_ciphertext = self.get_hash(r)
        self.nth_pos = []
        for _ in range(256):
            r = ""
            for i in range(256):
                if i == _ % 256:
                    r += "1"
                    continue
                if _ % 256 < 128:
                    if i >= 128:
                        r += "1"
                    else:
                        r += "0"
                else:
                    if i >= 128:
                        r += "0"
                    else:
                        r += "1"
            self.nth_pos.append(r)
        self.lower_hash = None
        self.higher_hash = None

    def get_hash(self, r):
        self.p.sendline(self.c)
        self.p.sendline(r)
        return self.p.recvline(False).decode()

    def get_hash_with_index(self, i):
        return self.get_hash(self.nth_pos[i])

    def get_seq(self):
        self.lower_hash = self.get_hash_with_index(0)
        self.higher_hash = self.get_hash_with_index(128)
        return [int(self.lower_hash == self.get_hash_with_index(i)) for i in range(128)] + \
            [int(self.higher_hash == self.get_hash_with_index(
                i)) for i in range(128, 256)]

    def check_bits(self, bits):
        bits = [bit for (r1, bit) in zip(self.r, bits) if int(r1)]
        return mkaes([1] + bits).encrypt(b"hxp<3you").hex() == self.chosen_ciphertext

    def print_flag(self, seq, ciphertext):
        bits = [bit for (r1, bit) in zip(self.r, seq) if int(r1)]
        print(mkaes([0] + bits).decrypt(ciphertext))


def main():
    p = process("./vuln.py")
    p.recvlines(2)
    c = p.recvline(False).replace(b"ct[0]: ", b"").decode()
    r = p.recvline(False).replace(b"ct[1]: ", b"").decode()
    ciphertext = unhexlify(p.recvline(False).replace(b"flag:  ", b""))
    calc = BitsCalculator(p, c, r)
    seq = calc.get_seq()
    if calc.check_bits(seq):
        calc.print_flag(seq, ciphertext)
        return
    for i in range(128):
        seq[i] = int(not seq[i])
    if calc.check_bits(seq):
        calc.print_flag(seq, ciphertext)
        return
    for i in range(128, 256):
        seq[i] = int(not seq[i])
    if calc.check_bits(seq):
        calc.print_flag(seq, ciphertext)
        return
    for i in range(128):
        seq[i] = int(not seq[i])
    if calc.check_bits(seq):
        calc.print_flag(seq, ciphertext)
        return


if __name__ == "__main__":
    main()
