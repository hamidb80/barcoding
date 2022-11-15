import ../utils


type
  Parity* = enum
    odd, even

  Upc* = enum
    o0, o1, o2, o3, o4, o5, o6, o7, o8, o9
    e0, e1, e2, e3, e4, e5, e6, e7, e8, e9


const
  bg* = bs"101"         # border guard
  mg* = bs"01010"       # middle guard
  qz* = bs"000 000 000" # quite zone
  W = false
  O = odd
  E = even


func bits*(u: Upc): seq[bool] =
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
  of e0 .. e9: not bits Upc(u.int - 10)

func upcCheckSum*(digits: seq[int]): range[0..9] =
  var odd = true

  for i in 1..digits.len:
    let d = digits[^i]

    result.inc:
      if odd: d*3
      else: d

    odd = not odd

  result = sup10(result) - result

func toUpc*(d: int, p: Parity): Upc =
  case p
  of odd: Upc d
  of even: Upc d+10

# --- UPC-A

func upca(digits: seq[int]): seq[Upc] =
  const pattern = il"OOOOOO EEEEEE"

  for i, d in digits:
    result.add toUpc(d, pattern[i])

  result.add toUpc(upcCheckSum(digits), even)

proc upcaRepr*(digits: seq[int]): seq[bool] =
  assert digits.len == 11
  let final = upca digits

  result.add qz
  result.add bg

  for i in 0..<6:
    result.add bits final[i]

  result.add mg

  for i in 6..<12:
    result.add bits final[i]

  result.add bg
  result.add qz

# --- UPC-E

func paritySeq(modulo: range[0..9]): array[6, Parity] =
  case modulo
  of 0: il"EEE OOO"
  of 1: il"EEO EOO"
  of 2: il"EEO OEO"
  of 3: il"EEO OOE"
  of 4: il"EOE EOO"
  of 5: il"EOO EEO"
  of 6: il"EOO OEE"
  of 7: il"EOE OEO"
  of 8: il"EOE OOE"
  of 9: il"EOO EOE"

func upce(digits: seq[int]): seq[Upc] =
  let check = upcCheckSum digits

  for i, parity in paritySeq check:
    let d =
      case i:
      of 0..<5: digits[i]
      else: check

    result.add toUpc(d, parity)

proc upceRepr*(digits: seq[int]): seq[bool] =
  assert digits.len == 5

  result.add bg
  result.add W

  for i, f in upce digits:
    result.add bits f

  result.add bg
