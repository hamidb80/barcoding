import common, utils

type
  UPCA* = enum
    o0, o1, o2, o3, o4, o5, o6, o7, o8, o9
    e0, e1, e2, e3, e4, e5, e6, e7, e8, e9
    borderGuard, middleGuard, quiteZone

func bits(u: UPCA): seq[bool] =
  case u
  of o0: bitSeq "0001101"
  of o1: bitSeq "0011001"
  of o2: bitSeq "0010011"
  of o3: bitSeq "0111101"
  of o4: bitSeq "0100011"
  of o5: bitSeq "0110001"
  of o6: bitSeq "0101111"
  of o7: bitSeq "0111011"
  of o8: bitSeq "0110111"
  of o9: bitSeq "0001011"
  of e0 .. e9: not bits(UPCA(u.int - 10))
  of borderGuard: bitSeq "101"
  of middleGuard: bitSeq "01010"
  of quiteZone: bitSeq "000000000"


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
