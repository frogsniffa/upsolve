x, y = var("x, y")
intersections = solve([y**2 == x**3 - 7*x + 10, y ==
                      2*x - 2], x, y, solution_dict=True)
intersections = [[i[x], i[y]] for i in intersections]
assert len(intersections) == 3

E = EllipticCurve(QQ, [-7, 10])
poi = E(0)
check = poi
for x in intersections:
    check += E(x)
assert poi == check
