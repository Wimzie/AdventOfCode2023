$inputList = Get-Content .\input.txt

$powerSum = 0


ForEach($line in $inputList) {
    $lowestRed = $null
    $lowestGreen = $null
    $lowestBlue = $null

    $games = $line.Split(";")
    ForEach($game in $games) {
        $colors = ($game.Split(":")[-1]).Split(",")
        $redColor = $colors | Where-Object {$_ -like "*red"}
        if($redColor) {
            $redAmount = [int]($redColor -replace "[^0-9]")
            if(!$lowestRed){
                $lowestRed = $redAmount
            } elseif($redAmount -gt $lowestRed) {
                $lowestRed = $redAmount
            }
        }
        $blueColor = $colors | Where-Object {$_ -like "*blue"}
        if($blueColor) {
            $blueAmount = [int]($blueColor -replace "[^0-9]")
            if(!$lowestBlue){
                $lowestBlue = $blueAmount
            } elseif($blueAmount -gt $lowestBlue) {
                $lowestBlue = $blueAmount
            }
        }
        $greenColor = $colors | Where-Object {$_ -like "*green"}
        if($greenColor) {
            $greenAmount = [int]($greenColor -replace "[^0-9]")
            if(!$lowestGreen){
                $lowestGreen = $greenAmount
            } elseif($greenAmount -gt $lowestGreen) {
                $lowestGreen = $greenAmount
            }
        }
    }
    $powerSum += ($lowestRed * $lowestGreen * $lowestBlue)
}

Write-Host $powerSum