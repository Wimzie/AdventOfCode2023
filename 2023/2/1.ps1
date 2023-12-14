$inputList = Get-Content .\input.txt

$maxRed = 12
$maxGreen = 13
$maxBlue = 14

$idSum = 0


ForEach($line in $inputList) {
    $games = $line.Split(";")
    $id = [int](($line.Split(":")[0]) -replace "[^0-9]")
    $tooHighAmount = $false
    ForEach($game in $games) {
        $colors = ($game.Split(":")[-1]).Split(",")
        $redColor = $colors | Where-Object {$_ -like "*red"}
        if($redColor) {
            $redAmount = [int]($redColor -replace "[^0-9]")
            if($redAmount -gt $maxRed) {
                $tooHighAmount = $true
                break
            }
        }
        $blueColor = $colors | Where-Object {$_ -like "*blue"}
        if($blueColor) {
            $blueAmount = [int]($blueColor -replace "[^0-9]")
            if($blueAmount -gt $maxBlue) {
                $tooHighAmount = $true
                break
            }
        }
        $greenColor = $colors | Where-Object {$_ -like "*green"}
        if($greenColor) {
            $greenAmount = [int]($greenColor -replace "[^0-9]")
            if($greenAmount -gt $maxGreen) {
                $tooHighAmount = $true
                break
            }
        }
    }
    if($tooHighAmount) {
        continue
    }
    $idSum += $id
}

Write-Host $idSum