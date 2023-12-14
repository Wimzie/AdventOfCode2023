$inputList = Get-Content .\input.txt

$seedRanges = @()
$seeds = (($inputList[0]).Split(":")[-1]).Split(" ") | Where-Object {$_ -ne ""}
For($i = 0; $i -lt $seeds.Count; $i += 2) {
    $seedRanges += "$($seeds[$i]),$($seeds[$i+1])"
}

$seedDistance = @{}

$soilRanges = $inputList[$($inputList.IndexOf("seed-to-soil map:"))..$($inputList.IndexOf("soil-to-fertilizer map:"))] | Where-Object {$_ -notmatch "[a-z]" -and $_ -ne ""}
$fertilizerRanges = $inputList[$($inputList.IndexOf("soil-to-fertilizer map:"))..$($inputList.IndexOf("fertilizer-to-water map:"))] | Where-Object {$_ -notmatch "[a-z]" -and $_ -ne ""}
$waterRanges = $inputList[$($inputList.IndexOf("fertilizer-to-water map:"))..$($inputList.IndexOf("water-to-light map:"))] | Where-Object {$_ -notmatch "[a-z]" -and $_ -ne ""}
$lightRanges = $inputList[$($inputList.IndexOf("water-to-light map:"))..$($inputList.IndexOf("light-to-temperature map:"))] | Where-Object {$_ -notmatch "[a-z]" -and $_ -ne ""}
$temperatureRanges = $inputList[$($inputList.IndexOf("light-to-temperature map:"))..$($inputList.IndexOf("temperature-to-humidity map:"))] | Where-Object {$_ -notmatch "[a-z]" -and $_ -ne ""}
$humidityRanges = $inputList[$($inputList.IndexOf("temperature-to-humidity map:"))..$($inputList.IndexOf("humidity-to-location map:"))] | Where-Object {$_ -notmatch "[a-z]" -and $_ -ne ""}
$locationRanges = $inputList[$($inputList.IndexOf("humidity-to-location map:"))..$inputList.Count] | Where-Object {$_ -notmatch "[a-z]" -and $_ -ne ""}

$seedFound = $false
$location = 3173381
while (-not $seedFound) {
    forEach($locationRange in $locationRanges) {
        $instructions = $locationRange.Split(" ")
        if($location -ge [int64]$instructions[0] -and $location -le $([int64]$instructions[0] + [int64]$instructions[2]) -1) {
            $humidity = $([int64]$instructions[1] - [int64]$instructions[0]) + $location
            break
        }
        $humidity = $location
    }

    forEach($humidityRange in $humidityRanges) {
        $instructions = $humidityRange.Split(" ")
        if($humidity -ge [int64]$instructions[0] -and $humidity -le $([int64]$instructions[0] + [int64]$instructions[2]) -1) {
            $temperature = $([int64]$instructions[1] - [int64]$instructions[0]) + $humidity
            break
        }
        $temperature = $humidity
    }

    forEach($temperatureRange in $temperatureRanges) {
        $instructions = $temperatureRange.Split(" ")
        if($temperature -ge [int64]$instructions[0] -and $temperature -le $([int64]$instructions[0] + [int64]$instructions[2]) -1) {
            $light = $([int64]$instructions[1] - [int64]$instructions[0]) + $temperature
            break
        }
        $light = $temperature
    }

    forEach($lightRange in $lightRanges) {
        $instructions = $lightRange.Split(" ")
        if($light -ge [int64]$instructions[0] -and $light -le $([int64]$instructions[0] + [int64]$instructions[2]) -1) {
            $water = $([int64]$instructions[1] - [int64]$instructions[0]) + $light
            break
        }
        $water = $light
    }

    forEach($waterRange in $waterRanges) {
        $instructions = $waterRange.Split(" ")
        if($water -ge [int64]$instructions[0] -and $water -le $([int64]$instructions[0] + [int64]$instructions[2])) {
            $fertilizer = $([int64]$instructions[1] - [int64]$instructions[0]) + $water
            break
        }
        $fertilizer = $water
    }

    forEach($fertilizerRange in $fertilizerRanges) {
        $instructions = $fertilizerRange.Split(" ")
        if($fertilizer -ge [int64]$instructions[0] -and $fertilizer -le $([int64]$instructions[0] + [int64]$instructions[2])) {
            $soil = $([int64]$instructions[1] - [int64]$instructions[0]) + $fertilizer
            break
        }
        $soil = $fertilizer
    }

    forEach($soilRange in $soilRanges) {
        $instructions = $soilRange.Split(" ")
        if($soil -ge [int64]$instructions[0] -and $soil -le $([int64]$instructions[0] + [int64]$instructions[2])) {
            $seed = $([int64]$instructions[1] - [int64]$instructions[0]) + $soil
            break
        }
        $seed = $soil
    }

    foreach($range in $seedRanges) {
        [int64]$lowerRange = $range.Split(",")[0]
        [int64]$upperRange = $lowerRange + [int64]$range.Split(",")[1] -1

        if($seed -ge $lowerRange -and $seed -le $upperRange) {
            $seedFound = $location
        }
    }
    $location++
}

Write-Host $seedFound

    