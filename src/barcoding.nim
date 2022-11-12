# import std/strformat


type
  Barcode* = enum
    bUpca, bUpce

  UPCA* = enum
    o0, o1, o2, o3, o4, o5, o6, o7, o8, o9
    e0, e1, e2, e3, e4, e5, e6, e7, e8, e9
    b, m, q

  Parity = enum
    odd, even


const
  W = false
  B = true


func `not`(s: seq[bool]): seq[bool] =
  for i in s:
    result.add(not i)

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
  of b: @[B, W, B]
  of m: @[W, B, W, B, W]
  of q: @[W, W, W, W, W, W, W, W, W]


func sup10(i: int): int =
  if i mod 10 == 0: i
  else: ((i div 10) + 1) * 10

func findCheck(digits: seq[int]): int =
  for i, d in digits:
    result.inc:
      if i mod 2 == 0: d*3
      else: d

  result = sup10(result) - result

func toUPCA(d: int, p: Parity): UPCA =
  case p
  of odd: UPCA d
  of even: UPCA d+10

func upca(s: seq[int]): seq[UPCA] =
  result.add q
  result.add b

  for i in 0..5:
    result.add toUPCA(s[i], odd)

  result.add m

  for i in 6..11:
    result.add toUPCA(s[i], even)

  result.add b
  result.add q

func upcaRepr(digits: seq[int]): seq[bool] =
  assert digits.len == 11
  let final = upca(digits & findCheck(digits))
  for s in final:
    result.add bits s


template TODO: untyped =
  raise newException(ValueError, "not implemented")


func genBarcode*(data: seq[int], kind: Barcode): seq[bool] =
  case kind
  of bUpca: upcaRepr data
  of bUpce: TODO



# func toSVG(s: seq[bool]): string =
#   for i, bar in s:
#     let color =
#       case bar
#       of W: "white"
#       of B: "black"

#     result &= fmt"""<rect x="{i*7}" height="100" width="7" style="fill: {color}"/>"""

#   result = fmt"""
#   <svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink"
#     width="{7 * s.len}" height="100">
#      {result}
#   </svg>
#   """
