line = "Hello=world"
local a, b, c, d = line:match("(%a+)%s*=%s*(.+)")
print(a, b, c, d)