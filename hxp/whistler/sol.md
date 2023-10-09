# Background

## LWE

Let $s$ be the secret key. Let $\chi$ be a random distribution for $e$. Let $n$ be a size parameter. Let $q$ be a modulus. Given as many random elements from $A_{s, \chi} = (a, a\cdot s + e) \in \mathbb{Z}_q^n \times \mathbb{Z}_q$ as possible with random $a\in \mathbb{Z}_q^n$ and random $e\in \mathbb{Z}_q$, solve for $s$.

## Ring LWE

If we need $n$ samples from $A$, we'll use $O(n^2)$ memory if unique $a$'s are used. To reduce memory to $O(n)$, each element in $a$ can be rotated n times to be $a_i=(a_i, ..., a_n, -a_1, ..., -a_{i-1})$. This is achieved by changing groups from $\mathbb{Z}_q^n$ to $R_q = \mathbb{Z}_q[x]/(x^n+1)$ and $q\equiv 1\bmod{2n}$.

## Decisional LWE

Let $U$ be the random distribution for $\mathbb{Z}_q^n \times \mathbb{Z}_q$. Assume we have an efficient algorithm $W$ that tells whether an element is from $U$ or $A_{s, \chi}$. Then, there exists an efficient algorithm $W'$ that can calculate $s$ from $A_{s, \chi}$. Let $a' = a + (r_1, 0, 0,...)$ where $r_1$ is random. Let $b'_{j\in \mathbb{Z}_q} = a'\cdot s_1 + e = (a + (r_1, 0, 0, ...))\cdot s + e = b + r_1s_1$ where we bruteforce $s_1 \in \mathbb{Z}_q$. Using $W$, we can tell which $(a', b'_j)$ is in $A_{s, \chi}$, so we've bruteforced $s_1$.

Assuming decisional ring LWE was solved, solving ring LWE would require a reduction to LWE, because the order of $R_q$ is $q^n$. Let $t_i\in \mathbb{Z}_q$ be the $n$ roots of unity such that $t_i^n \equiv -1\bmod{q}$. Then there is a ring homomorphism $\phi : R_q\rightarrow \mathbb{Z}_q^n$ that maps every $p\in R_q$ to $(p(t_1), p(t_2), ...)$.

# Solution

## Why decaps(sk, ct) == dh

$$
\begin{aligned}
sk, pk = genkey() \\
a, b = pk \\
a \cdot sk + e = b \\
dh, ct = encaps(pk) \\
c, r = ct \\
c = a \cdot sk' + e' \\
r = f(d) \\
dh = f'(r, d)
\end{aligned}
$$

Then, we can see $d \approx c*sk$ because

$$
\begin{aligned}
dh = decaps(sk, ct) = f'(r, c \cdot sk) \\
d = b \cdot sk' + e' = (a \cdot sk + e) \cdot sk' + e' = a \cdot sk \cdot sk' + e \cdot sk' + e' \\
c \cdot sk = (a \cdot sk' + e') \cdot sk = a \cdot sk' \cdot + e' \cdot sk
\end{aligned}
$$

The $+e'$ is negligible between $d$ and $c \cdot sk$. $f'(x) = 2 \cdot x / 11777$ and increasing x by at most 4 would not really change the result.

## Hints

Notice $f'(x)$ is just $0$ or $1$. If it weren't for `sum(r) < n // 2`, we could just do

```
seq = [0] * 256
seq[i] = 1
```

and guess whether the hash returned by $f'(seq, r)$ corresponded to `[0]` or `[1]`. The $r$ acts as a filter so $f'(seq, r)$ would be the same thing as $f'(seq_i)$.

# Sources

1. https://cims.nyu.edu/~regev/papers/lwesurvey.pdf
2. https://thomwiggers.nl/post/2023-03-13-hxp-ctf/
