local a = {}
a[1] = 5
b = {unpack(a)}
print(a[1], b[1])
b[1] = 6
print(a[1], b[1])