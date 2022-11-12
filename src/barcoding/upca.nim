import common

type
  UPCA* = enum
    o0, o1, o2, o3, o4, o5, o6, o7, o8, o9
    e0, e1, e2, e3, e4, e5, e6, e7, e8, e9
    borderGuard, middleGuard, quiteZone

func bits(u: UPCA): seq[bool] =
  case u
  of o0: @[W, W, W, B, B, W, B]
  of o1: @[W, W, B, B, W, W, B]
  of o2: @[W, W, B, W, W, B, B]
  of o3: @[W, B, B, B, B, W, B]
  of o4: @[W, B, W, W, W, B, B]
  of o5: @[W, B, B, W, W, W, B]
  of o6: @[W, B, W, B, B, B, B]
  of o7: @[W, B, B, B, W, B, B]
  of o8: @[W, B, B, W, B, B, B]
  of o9: @[W, W, W, B, W, B, B]
  of e0 .. e9: not bits(UPCA(u.int - 10))
  of borderGuard: @[B, W, B]
  of middleGuard: @[W, B, W, B, W]
  of quiteZone: @[W, W, W, W, W, W, W, W, W]


func checkSum(digits: seq[int]): int =
  for i, d in digits:
    result.inc:
      if i mod 2 == 0: d*3
      else: d

  result = sup10(result) - result

func toUPCA(d: int, p: Parity): Upca =
  case p
  of odd: UPCA d
  of even: UPCA d+10

func upca(s: seq[int]): seq[Upca] =
  result.add quiteZone
  result.add borderGuard

  for i in 0..5:
    result.add toUPCA(s[i], odd)

  result.add middleGuard

  for i in 6..11:
    result.add toUPCA(s[i], even)

  result.add borderGuard
  result.add quiteZone

func upcaRepr*(digits: seq[int]): Barcode =
  assert digits.len == 11
  let final = upca(digits & checkSum(digits))
  for s in final:
    result.add bits s
