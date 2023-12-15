$inputList = Get-Content .\input.txt

$time = $inputList[0].Replace(" ", "") -replace "([A-Z][a-z])+\:",""
$distance = $inputList[1].Replace(" ", "") -replace "([A-Z][a-z])+\:",""

$combinations = 0

$lowerBound = 0
$higherBound = 0

For($i = 1; $i -lt $time; $i++) {
    if((($i * $time) - [Math]::Pow($i, 2)) -gt $distance) {
        $lowerBound = $i
        break
    }
}
For($j = $time -1; $j -gt 0; $j--) {
    if((($j * $time) - [Math]::Pow($j, 2)) -gt $distance) {
        $higherBound = $j
        break
    }
}

$combinations = ($lowerBound..$higherBound).Count



Write-Host $combinations