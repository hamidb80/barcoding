import macros

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

template transform*(s, by): untyped =
  var r = newSeqOfCap[typeof by(s[0])](s.len)
  for i in s: r.add by(i)
  r


macro bs*(s: static[string]): untyped =
  ## converts a sequence of bits that represented as a `string`
  ## into `seq[bool]`

  runnableExamples:
    assert bs"101" == @[true, false, true]

  var acc = newNimNode nnkBracket

  for ch in s:
    acc.add:
      case ch
      of '1': ident "true"
      of '0': ident "false"
      else: raise newException(ValueError, "invalid bit literal")

  prefix(acc, "@") # convert toseq

template cut*(s: seq): untyped =
  s.del s.high
  