$inputList = Get-Content .\input.txt

$galaxyPositions = @()
$emptyRows = @()
$emptyColumns = @()

for($i = 0; $i -lt $inputList.Count; $i++) {
    $rowIsEmpty = $true
    for($j = 0; $j -lt $inputList[$i].Length; $j++) {
        if($inputList[$i][$j] -eq "#") {
            $galaxyPositions += "$i,$j"
            $rowIsEmpty = $false
        }
    }
    if($rowIsEmpty) {
        $emptyRows += $i
    }
}

for($i = 0; $i -lt $inputList[0].Length; $i++) {
    $columnIsEmpty = $true
    for($j = 0; $j -lt $inputList.Count; $j++) {
        if($inputList[$j][$i] -eq "#") {
            $columnIsEmpty = $false
            break
        }
    }
    if($columnIsEmpty) {
        $emptyColumns += $i
    }
}



$correctedGalaxyPositions = @()

ForEach($position in $galaxyPositions) {
    $row = [int]$position.Split(",")[0]
    $rowExpand = $emptyRows | Where-Object {$_ -lt $row}
    if($rowExpand) {
        $correctedGalaxyPositions += $position.Replace("$row,", "$($row + $(($rowExpand.Count * (1000000-1)))),")
        continue
    }
    $correctedGalaxyPositions += $position
}

$galaxyPositions = $correctedGalaxyPositions


$correctedGalaxyPositions = @()

ForEach($position in $galaxyPositions) {
    $column = [int]$position.Split(",")[1]
    $columnExpand = $emptyColumns | Where-Object {$_ -lt $column}
    if($columnExpand) {
        $correctedGalaxyPositions += $position.Replace(",$column", ",$($column + $(($columnExpand.Count * (1000000-1))))")
        continue
    }
    $correctedGalaxyPositions += $position
}

$galaxyPositions = $correctedGalaxyPositions

$distanceSum = 0

For($i = 0; $i -lt $galaxyPositions.Count -1; $i++) {
    for($j = $i + 1; $j -lt $galaxyPositions.Count; $j++) {
        
        $x1 = $galaxyPositions[$i].Split(",")[0]
        $y1 = $galaxyPositions[$i].Split(",")[1]
        $x2 = $galaxyPositions[$j].Split(",")[0]
        $y2 = $galaxyPositions[$j].Split(",")[1]
        $distance = [System.Math]::Abs(($x1 - $x2)) + [System.Math]::Abs(($y1 - $y2))
        $distanceSum += $distance
    }
}

Write-Host $distanceSum