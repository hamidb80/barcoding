## https://en.wikipedia.org/wiki/Code_11

import common

type
  Code11 = enum
    c0, c1, c2, c3, c4, c5, c6, c7, c8, c9
    cDash, cStartStop

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

func bits(c: Code11): seq[bool] =
  case ch
  of c0: @[]
  of c1: @[]
  of c2: @[]
  of c3: @[]
  of c4: @[]
  of c5: @[]
  of c6: @[]
  of c7: @[]
  of c8: @[]
  of c9: @[]
  of cDash: @[]
  of cStartStop: @[]


func code11Repr*(data: seq[Code11]): Barcode =
  result.add cStartStop


  result.add cStartStop
