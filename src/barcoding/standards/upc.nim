import ../utils


type
  Parity* = enum
    odd, even

  Upc* = enum
    o0, o1, o2, o3, o4, o5, o6, o7, o8, o9
    e0, e1, e2, e3, e4, e5, e6, e7, e8, e9
    bg # border guard
    mg # middle guard
    qz # quite zone


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
  of bg: bs"101"
  of mg: bs"01010"
  of qz: bs"000000000"

func checkSum(digits: seq[int]): range[0..9] =
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


template gen(name, size, fn): untyped {.dirty.} =
  proc name*(digits: seq[int]): seq[bool] =
    assert digits.len == size
    let final = fn digits
    for s in final:
      result.add bits s

# --- UPC-A

func upca(s: seq[int]): seq[Upc] =
  result.add qz
  result.add bg

  for i in 0..5:
    result.add toUpc(s[i], odd)

  result.add mg

  for i in 6..10:
    result.add toUpc(s[i], even)

  result.add toUpc(checkSum(s), even)

  result.add bg
  result.add qz

gen upcaRepr, 11, upca

# --- UPC-E

func paritySeq(modulo: range[0..9]): array[6, Parity] =
  const
    E = even
    O = odd

  case modulo
  of 0: [E, E, E, O, O, O]
  of 1: [E, E, O, E, O, O]
  of 2: [E, E, O, O, E, O]
  of 3: [E, E, O, O, O, E]
  of 4: [E, O, E, E, O, O]
  of 5: [E, O, O, E, E, O]
  of 6: [E, O, O, O, E, E]
  of 7: [E, O, E, O, E, O]
  of 8: [E, O, E, O, O, E]
  of 9: [E, O, O, E, O, E]

func upce(digits: seq[int]): seq[Upc] =
  assert digits.len == 5
  let check = checkSum digits

  result.add bg

  for i, parity in paritySeq check:
    let d =
      case i:
      of 0..<5: digits[i]
      else: check

    result.add toUpc(d, parity)

  result.add bg

gen upceRepr, 5, upce
