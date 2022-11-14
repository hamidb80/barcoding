import std/strformat
import ../utils


type
  Code11 = enum
    cs = -1 # start/stop
    c0, c1, c2, c3, c4, c5, c6, c7, c8, c9
    cd      # dash -

const
  W = false
  # B = true


func bits(c: Code11): seq[bool] =
  case c
  of c0: bs"101011"
  of c1: bs"1101011"
  of c2: bs"1001011"
  of c3: bs"1100101"
  of c4: bs"1011011"
  of c5: bs"1101101"
  of c6: bs"1001101"
  of c7: bs"1010011"
  of c8: bs"1101001"
  of c9: bs"110101"
  of cd: bs"101101"
  of cs: bs"1011001"

func toCode11(ch: char): Code11 =
  case ch
  of '0'..'9': Code11 toDigit ch
  of '-': cd
  else: raise newException ValueError:
    fmt"invalid characher in code11 system: '{ch}'"


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


func code11*(data: string): seq[Code11] =
  let
    s = transform(data, toCode11)
    c = checkSumC s
    temp = s & c
    final =
      if s.len < 10: temp
      else: temp & checkSumK temp

  result.add cd
  for c in final: result.add c
  result.add cd

func code11Repr*(data: string): seq[bool] =
  for c in code11 data:
    result.add bits c
    result.add W

  cut result
