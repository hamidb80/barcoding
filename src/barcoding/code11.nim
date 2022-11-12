import common

type
  Code11 = enum
    c0, c1, c2, c3, c4, c5, c6, c7, c8, c9
    cDash, cStart

func toCode11(ch: char): Code11 =
  case ch
  of '0': c0
  of '1': c1
  of '2': c2
  of '3': c3
  of '4': c4
  of '5': c5
  of '6': c6
  of '7': c7
  of '8': c8
  of '9': c9
  of '-': cDash
  else: raise newException(ValueError, "not valid")

func code11Repr*(data: seq[Code11]): Barcode =
  discard
