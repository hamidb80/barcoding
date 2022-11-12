## https://web.archive.org/web/20070202060711/http://www.barcodeisland.com/code11.phtml

import common, utils

type
  Code11 = enum
    cs = -1 # start/stop
    c0, c1, c2, c3, c4, c5, c6, c7, c8, c9
    cd      # dash -


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
  of '-': cd
  else: raise newException(ValueError, "not valid")


func bits(c: Code11): seq[bool] =
  case c
  of c0: bitSeq "101011"
  of c1: bitSeq "1101011"
  of c2: bitSeq "1001011"
  of c3: bitSeq "1100101"
  of c4: bitSeq "1011011"
  of c5: bitSeq "1101101"
  of c6: bitSeq "1001101"
  of c7: bitSeq "1010011"
  of c8: bitSeq "1101001"
  of c9: bitSeq "110101"
  of cd: bitSeq "101101"
  of cs: bitSeq "1011001"


template checkSum(base: int): untyped =
  var acc = 0

  for i in 1..data.len:
    let w = ((i-1) mod base) + 1
    acc.inc data[^i].int * w

  Code11 acc mod 11

func checkSumK(data: seq[Code11]): Code11 =
  checkSum 9

func checkSumC(data: seq[Code11]): Code11 =
  checkSum 11


func code11Repr*(data: string): Barcode =
  let
    s = transform(data, toCode11)
    c = checkSumC s
    final =
      if s.len < 10: s & c
      else:
        let
          t = s & c
          k = checkSumK t
        t & k

  result.add bits cd
  result.add W

  for c in final:
    result.add bits c
    result.add W

  result.add bits cd

