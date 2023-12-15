$inputList = Get-Content .\input.txt

$boatRaces = @()

$times = $inputList[0] -split "\s+" | Where-Object {$_ -notmatch "[A-Z][a-z]"}
$distances = $inputList[1] -split "\s+" | Where-Object {$_ -notmatch "[A-Z][a-z]"}
$resultForRaces = 1

for($i = 0; $i -lt $times.Count; $i++) {
    $boatRaces += "$($times[$i]),$($distances[$i])"
}

ForEach($race in $boatRaces) {
    $time = $race.Split(",")[0]
    $distance = $race.Split(",")[1]

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

    $resultForRaces *= ($lowerBound..$higherBound).Count

}

Write-Host $resultForRaces