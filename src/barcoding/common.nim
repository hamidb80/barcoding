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
