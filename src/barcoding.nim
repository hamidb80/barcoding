import barcoding/[utils]
import barcoding/standards/[upc, ean, code11]

type
  Barcode* = seq[bool]

  Barcodekind* = enum
    bUpca, bUpce
    bEan13, bEan8, bEan5, bEan2
    bCode128, bCode93, bCode39, bCode11
    bMsi, bCodabar, bPharmacode


func genBarcode*(data: string, kind: BarcodeKind): seq[bool] =
  case kind
  of bUpca: upcaRepr toIntSeq data
  of bUpce: upceRepr toIntSeq data
  of bEan13: ean13Repr toIntSeq data
  of bEan8: ean8Repr toIntSeq data
  of bEan5: ean5Repr toIntSeq data
  of bEan2: ean2Repr toIntSeq data
  # of bCode128:
  # of bCode93:
  # of bCode39:
  of bCode11: code11Repr data
  # of bMsi:
  # of bCodabar:
  # of bPharmacode:
  else: raise newException(ValueError, $kind & " is not implmented")


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
