x, y = var("x, y")
intersections = solve([y**2 == x**3 - 7*x + 10, y ==
                      2*x - 2], x, y, solution_dict=True)
intersections = [[i[x], i[y]] for i in intersections]
assert len(intersections) == 3

E = EllipticCurve(QQ, [-7, 10])
check = E(0)
for x in intersections:
    check += E(x)
assert check == E(0)
