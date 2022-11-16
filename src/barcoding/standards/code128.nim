import ../utils

func checksum(startCode: int, digits: seq[int]): range[0..102] =
  var acc = startCode
  
  for i, d in digits:
    acc.inc (i+1)*d

  acc % 103

