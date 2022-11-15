import std/algorithm
import ../utils, upc

type
  Ean = enum
    l0, l1, l2, l3, l4, l5, l6, l7, l8, l9
    r0, r1, r2, r3, r4, r5, r6, r7, r8, r9
    g0, g1, g2, g3, g4, g5, g6, g7, g8, g9

  Encoding = enum
    L, G, R # Left - GS1 - Right


const
  smallStarter = bs"01011"
  smallSep = bs"01"


func bits(c: Ean): seq[bool] =
  case c
  of l0..l9, r0..r9: bits Upc(c.int)
  of g0..g9: reversed bits Upc(c.int - 10)

func toEan(n: range[0..9], e: Encoding): Ean =
  Ean case e
  of L: n + l0.ord
  of G: n + g0.ord
  of R: n + r0.ord

func genCode(digits: seq[int], pattern: openArray[Encoding]): seq[Ean] =
  for i, d in digits:
    result.add toEan(d, pattern[i])


func ean13Encoding(n: range[0..9]): array[12, Encoding] =
  case n
  of 0: il"LLLLLL RRRRRR"
  of 1: il"LLGLGG RRRRRR"
  of 2: il"LLGGLG RRRRRR"
  of 3: il"LLGGGL RRRRRR"
  of 4: il"LGLLGG RRRRRR"
  of 5: il"LGGLLG RRRRRR"
  of 6: il"LGGGLL RRRRRR"
  of 7: il"LGLGLG RRRRRR"
  of 8: il"LGLGGL RRRRRR"
  of 9: il"LGGLGL RRRRRR"

func ean13Repr*(digits: seq[int]): seq[bool] =
  assert digits.len == 12

  let
    content = digits[1..^1] & upcCheckSum(digits)
    codes = genCode(content, ean13Encoding digits[0])


  result.add qz
  result.add bg

  for i in 0..<6:
    result.add bits codes[i]

  result.add mg

  for i in 6..<12:
    result.add bits codes[i]

  result.add bg
  result.add qz

func ean8Repr*(digits: seq[int]): seq[bool] =
  assert digits.len == 7
  let codes = genCode(digits, il"LLLL RRRR")

  result.add mg

  for i in 0..<4:
    result.add bits codes[i]

  result.add mg

  for i in 4..<8:
    result.add bits codes[i]

  result.add mg


func smallJoiner*(codes: seq[Ean]): seq[bool] =
  result.add smallStarter

  for i, c in codes:
    if i != 0:
      result.add smallSep

    result.add bits c

func ean5CheckSum(digits: seq[int]): int =
  for i, d in digits:
    result.inc:
      case d % 2
      of 0: 3*d
      of 1: 9*d

  result mod 10

func ean5Encoding(n: range[0..9]): array[5, Encoding] =
  case n
  of 0: il"GGLLL"
  of 1: il"GLGLL"
  of 2: il"GLLGL"
  of 3: il"GLLLG"
  of 4: il"LGGLL"
  of 5: il"LLGGL"
  of 6: il"LLLGG"
  of 7: il"LGLGL"
  of 8: il"LGLLG"
  of 9: il"LLGLG"

func ean5Repr*(digits: seq[int]): seq[bool] =
  assert digits.len == 5
  smallJoiner genCode(digits, ean5Encoding ean5CheckSum digits)

func ean2Encoding(n: range[00..99]): array[2, Encoding] =
  case n % 4
  of 0: il"LL"
  of 1: il"LG"
  of 2: il"GL"
  of 3: il"GG"

func ean2Repr*(digits: seq[int]): seq[bool] =
  assert digits.len == 2
  smallJoiner genCode(digits, ean2Encoding toNumber digits)
