$inputList = Get-Content .\input.txt

$endReached = $false
$directions = $inputList[0] -split "" | Where-Object {$_ -ne ""}

$steps = 0

$map = @{}
$ghostPositions = @()
$endPositions = @()

ForEach ($coordinate in ($inputList[1..$inputList.Count] | Where-Object {$_ -ne ""})) {
    $position = $coordinate.Split("=")[0].TrimEnd()
    if($position[-1] -eq "A") {
        $ghostPositions += $position
    } elseif($position[-1] -eq "Z") {
        $endPositions += $position
    }
    $direction = ($coordinate.Split("=")[-1]).Replace("(", "").Replace(")", "").Replace(" ", "")
    $map.$position = $direction
}

$endPositionSteps = @()


ForEach($ghost in $ghostPositions) {
    $currentPosition = $ghost
    $steps = 0
    $endReached = $false
    While(-not $endReached) {
        ForEach($instruction in $directions) {
            if($endPositions -contains $currentPosition) {
                $endReached = $true
                $endPositionSteps += $steps
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
}

# Math section
function Get-PrimeFactors {
    param (
        [int]$number
    )

    $factors = @()
    $divisor = 2

    while ($number -gt 1 -and $divisor -le $number) {
        if ($number % $divisor -eq 0) {
            $factors += $divisor
            $number = $number / $divisor
        } else {
            $divisor++
        }
    }

    $factors
}

function Get-LCM {
    param (
        [Parameter(Mandatory=$true, ValueFromPipeline=$true)]
        [int[]]$numbers
    )

    $allFactors = @()

    foreach ($number in $numbers) {
        $factors = Get-PrimeFactors -number $number
        $allFactors += $factors
    }

    $uniqueFactors = $allFactors | Sort-Object -Unique

    $lcm = 1
    foreach ($factor in $uniqueFactors) {
        $maxPower = 0
        foreach ($factors in $allFactors) {
            $power = $factors | Where-Object { $_ -eq $factor } | Measure-Object | Select-Object -ExpandProperty Count
            if ($power -gt $maxPower) {
                $maxPower = $power
            }
        }
        $lcm *= [math]::Pow($factor, $maxPower)
    }

    return $lcm
}


$result = Get-LCM -numbers $endPositionSteps

Write-Host $result