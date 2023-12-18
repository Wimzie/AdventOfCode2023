$inputList = Get-Content .\input.txt

$endReached = $false
$directions = $inputList[0] -split "" | Where-Object {$_ -ne ""}
$currentPosition = "AAA"
$endPosition = "ZZZ"

$steps = 0

$map = @{}

ForEach ($coordinate in ($inputList[1..$inputList.Count] | Where-Object {$_ -ne ""})) {
    $position = $coordinate.Split("=")[0].TrimEnd()
    $direction = ($coordinate.Split("=")[-1]).Replace("(", "").Replace(")", "").Replace(" ", "")
    $map.$position = $direction
}

While(-not $endReached) {
    ForEach($instruction in $directions) {
        if($currentPosition -eq $endPosition) {
            $endReached = $true
            break
        }
        $currentMapPosition = $map.$currentPosition
        if($instruction -eq "L") {
            $currentPosition = $currentMapPosition.Split(",")[0]
        } else {
            $currentPosition = $currentMapPosition.Split(",")[1]
        }
        $steps++
    }
}

Write-Host $steps