import ../common, ../utils

type
  Upca* = enum
    o0, o1, o2, o3, o4, o5, o6, o7, o8, o9
    e0, e1, e2, e3, e4, e5, e6, e7, e8, e9
    b # border guard 
    m # middle guard
    q # quite zone

func bits(u: Upca): seq[bool] =
  case u
  of o0: bs"0001101"
  of o1: bs"0011001"
  of o2: bs"0010011"
  of o3: bs"0111101"
  of o4: bs"0100011"
  of o5: bs"0110001"
  of o6: bs"0101111"
  of o7: bs"0111011"
  of o8: bs"0110111"
  of o9: bs"0001011"
  of e0 .. e9: not bits(Upca(u.int - 10))
  of b: bs"101"
  of m: bs"01010"
  of q: bs"000000000"


func checkSum(digits: seq[int]): int =
  for i, d in digits:
    result.inc:
      if i mod 2 == 0: d*3
      else: d

  result = sup10(result) - result

func toUPCA(d: int, p: Parity): Upca =
  case p
  of odd: Upca d
  of even: Upca d+10

func upca(s: seq[int]): seq[Upca] =
  result.add q
  result.add b

  for i in 0..5:
    result.add toUPCA(s[i], odd)

  result.add m

  for i in 6..11:
    result.add toUPCA(s[i], even)

  result.add b
  result.add q

func upcaRepr*(digits: seq[int]): Barcode =
  assert digits.len == 11
  let final = upca(digits & checkSum(digits))
  for s in final:
    result.add bits s
