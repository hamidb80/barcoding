# import std/strformat
import barcoding/[common, upca, code11]

type
  Barcodekind* = enum
    bUpca, bUpce
    bCode11


template TODO: untyped =
  raise newException(ValueError, "not implemented")

func genBarcode*(data: string, kind: BarcodeKind): seq[bool] =
  case kind
  of bUpca: upcaRepr toIntSeq data
  of bCode11: code11Repr data
  else: TODO


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
