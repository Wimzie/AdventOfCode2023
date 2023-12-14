$inputList = Get-Content .\input.txt

$seeds = (($inputList[0]).Split(":")[-1]).Split(" ") | Where-Object {$_ -ne ""}
$seedDistance = @{}

$soilRanges = $inputList[$($inputList.IndexOf("seed-to-soil map:"))..$($inputList.IndexOf("soil-to-fertilizer map:"))] | Where-Object {$_ -notmatch "[a-z]" -and $_ -ne ""}
$fertilizerRanges = $inputList[$($inputList.IndexOf("soil-to-fertilizer map:"))..$($inputList.IndexOf("fertilizer-to-water map:"))] | Where-Object {$_ -notmatch "[a-z]" -and $_ -ne ""}
$waterRanges = $inputList[$($inputList.IndexOf("fertilizer-to-water map:"))..$($inputList.IndexOf("water-to-light map:"))] | Where-Object {$_ -notmatch "[a-z]" -and $_ -ne ""}
$lightRanges = $inputList[$($inputList.IndexOf("water-to-light map:"))..$($inputList.IndexOf("light-to-temperature map:"))] | Where-Object {$_ -notmatch "[a-z]" -and $_ -ne ""}
$temperatureRanges = $inputList[$($inputList.IndexOf("light-to-temperature map:"))..$($inputList.IndexOf("temperature-to-humidity map:"))] | Where-Object {$_ -notmatch "[a-z]" -and $_ -ne ""}
$humidityRanges = $inputList[$($inputList.IndexOf("temperature-to-humidity map:"))..$($inputList.IndexOf("humidity-to-location map:"))] | Where-Object {$_ -notmatch "[a-z]" -and $_ -ne ""}
$locationRanges = $inputList[$($inputList.IndexOf("humidity-to-location map:"))..$inputList.Count] | Where-Object {$_ -notmatch "[a-z]" -and $_ -ne ""}

foreach($seed in $seeds) {
    forEach($soilRange in $soilRanges) {
        $instructions = $soilRange.Split(" ")
        if($seed -ge [int64]$instructions[1] -and $seed -le $([int64]$instructions[1] + [int64]$instructions[2])) {
            $soil = $([int64]$instructions[0] - [int64]$instructions[1]) + $seed
            break
        }
        $soil = $seed
    }
    
    forEach($fertilizerRange in $fertilizerRanges) {
        $instructions = $fertilizerRange.Split(" ")
        if($soil -ge [int64]$instructions[1] -and $soil -le $([int64]$instructions[1] + [int64]$instructions[2])) {
            $fertilizer = $([int64]$instructions[0] - [int64]$instructions[1]) + $soil
            break
        }
        $fertilizer = $soil
    }
    
    forEach($waterRange in $waterRanges) {
        $instructions = $waterRange.Split(" ")
        if($fertilizer -ge [int64]$instructions[1] -and $fertilizer -le $([int64]$instructions[1] + [int64]$instructions[2])) {
            $water = $([int64]$instructions[0] - [int64]$instructions[1]) + $fertilizer
            break
        }
        $water = $fertilizer
    }
    
    forEach($lightRange in $lightRanges) {
        $instructions = $lightRange.Split(" ")
        if($water -ge [int64]$instructions[1] -and $water -le $([int64]$instructions[1] + [int64]$instructions[2])) {
            $light = $([int64]$instructions[0] - [int64]$instructions[1]) + $water
            break
        }
        $light = $water
    }
    
    forEach($temperatureRange in $temperatureRanges) {
        $instructions = $temperatureRange.Split(" ")
        if($light -ge [int64]$instructions[1] -and $light -le $([int64]$instructions[1] + [int64]$instructions[2])) {
            $temperature = $([int64]$instructions[0] - [int64]$instructions[1]) + $light
            break
        }
        $temperature = $light
    }
    
    forEach($humidityRange in $humidityRanges) {
        $instructions = $humidityRange.Split(" ")
        if($temperature -ge [int64]$instructions[1] -and $temperature -le $([int64]$instructions[1] + [int64]$instructions[2])) {
            $humidity = $([int64]$instructions[0] - [int64]$instructions[1]) + $temperature
            break
        }
        $humidity = $temperature
    }
    
    forEach($locationRange in $locationRanges) {
        $instructions = $locationRange.Split(" ")
        if($humidity -ge [int64]$instructions[1] -and $humidity -le $([int64]$instructions[1] + [int64]$instructions[2])) {
            $location = $([int64]$instructions[0] - [int64]$instructions[1]) + $humidity
            break
        }
        $location = $humidity
    }

    $seedDistance.$seed = $location
}

$shortestDistance = ($seedDistance.Values | Measure-Object -Minimum).Minimum

Write-Host $shortestDistance