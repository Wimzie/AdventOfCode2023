$line = "???.### 1,1,3"
$lineStr = ($line.Split(" ")[0])

$quantifiers = ($line.Split(" ")[1]).Split(",")
$qIndexes = @()
For($i = 0; $i -lt $line.Length; $i++) {
    if($line[$i] -eq "?") {
        $qIndexes += $i
    }
}

$regex = "(\?|\.)*"

for($i = 0; $i -lt $quantifiers.Length; $i++) {
    $regex += "(#){$($quantifiers[$i])}(((\?|\.){1,})|($))"
}

$permutations = 0

ForEach($index in $qIndexes) {
    $tempStr = $lineStr
    $tempStr[$index] = "#"

    $lineStr[($index+1)..($line.Length-1)]
}
