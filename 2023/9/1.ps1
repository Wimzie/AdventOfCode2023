$inputList = Get-Content .\input.txt

$sum = 0

ForEach($row in $inputList) {
    $numbers = $row.Split(" ")
    $rows = @("$($numbers -join ","),")
    $onlyZeroes = $false
    While(-not $onlyZeroes) {
        $currentDifferences = ""
        for($i = 0; $i -lt $numbers.Count -1; $i++) {
            $currentDifferences += "$($numbers[$i+1] - $numbers[$i]),"
        }    
        if($currentDifferences -notmatch "^(0,)+$") {
            $rows += $currentDifferences
            $numbers = $currentDifferences.Split(",") | Where-Object {$_ -ne ""}
            continue
        }
        $onlyZeroes = $true
    }

    $currentRow = ""
    $nextRow = ""

    For($i = $rows.Count -1; $i -gt 0; $i--) {
        $currentRow = ($rows[$i].Split(",") | Where-Object {$_ -ne ""})
        $nextRow = ($rows[$i-1].Split(",") | Where-Object {$_ -ne ""})

        $nextRow += ([int]($currentRow[-1]) + [int]($nextRow[-1]))
        $rows[$i-1] = $nextRow -join ","
    }

    $sum += [int]($rows[0].Split(",")[-1])

}

Write-Host $sum