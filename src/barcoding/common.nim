type
  Barcodekind* = enum
    bUpca, bUpce
    bCode11

  Barcode* = seq[bool]

  Parity* = enum
    odd, even


const
  W* = false
  B* = true


func `not`*(s: seq[bool]): seq[bool] =
  for i in s:
    result.add(not i)

func sup10*(i: int): int =
  if i mod 10 == 0: i
  else: ((i div 10) + 1) * 10

func toDigit*(ch: char): int =
  assert ch in '0'..'9'
  ch.ord - '0'.ord

func toIntSeq*(s: string): seq[int] =
  result = newSeqOfCap[int](s.len)
  for ch in s:
    result.add toDigit ch
