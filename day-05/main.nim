import strutils
import strformat
import times

import nre
import options

const DAY: int = 5

const input: string = readFile("input.txt")


type MappingEntry = tuple[destination: int, source: int, width: int]


proc createMapping(title: string): seq[MappingEntry] = 
    var mappings: seq[MappingEntry] = @[]
    let mappingPattern: string = $input.find(re(fmt("{title} map:\\R(\\d+ \\d+ \\d+\\R?)+"))).get

    for line in mappingPattern.splitLines[1..^1]:
        if len(line) == 0: continue

        let lineComp = line.split(" ")

        mappings.add((
            destination: lineComp[0].parseInt, 
            source: lineComp[1].parseInt, 
            width: lineComp[2].parseInt))
    
    return mappings


proc getSeeds(): seq[int] = 
    var firstLine = $input.match(re".+").get
    firstLine.removePrefix("seeds: ")

    var seeds: seq[int] = @[]

    for val in firstLine.split(" "):
        seeds.add(val.strip.parseInt)

    return seeds


proc solution1(): int = 

    proc translateValue(value: int, mapping: seq[MappingEntry]): int = 
        for entry in mapping:
            if value >= entry.source and value < (entry.source + entry.width):
                return value - entry.source + entry.destination 
        return value

    let seedToSoil = createMapping("seed-to-soil")
    let soilToFertilizer = createMapping("soil-to-fertilizer")
    let fertilizerToWater = createMapping("fertilizer-to-water")
    let waterToLight = createMapping("water-to-light")
    let lightToTemperature = createMapping("light-to-temperature")
    let temperatureToHumidity = createMapping("temperature-to-humidity")
    let humidityToLocation = createMapping("humidity-to-location")

    var minimum: Option[int] = none(int)

    for seed in getSeeds():
        let location = seed
            .translateValue(seedToSoil)
            .translateValue(soilToFertilizer)
            .translateValue(fertilizerToWater)
            .translateValue(waterToLight)
            .translateValue(lightToTemperature)
            .translateValue(temperatureToHumidity)
            .translateValue(humidityToLocation)
        
        if minimum.isNone or location < minimum.get:
            minimum = some(location)

    return minimum.get


proc seen(ranges: seq[(int, int)], r: (int, int)): bool = 
    for currentRange in ranges:
        if r[0] >= currentRange[0] and r[1] <= currentRange[1]:
            return true
    return false


iterator allSeeds(): int = 
    let seedsExpanded = getSeeds()

    let leftBounds = seedsExpanded[0..^2]
    let rightBounds = seedsExpanded[1..^1]

    var pairs: seq[(int, int)]

    #  Warning: This is a brute force solution. This can be improved 
    #  by only yielding "unseen" seeds, because each seed leads to 
    #  the same location.

    for index in 0..(len(leftBounds) - 1):
        if index mod 2 != 0:
            continue

        pairs.add((leftBounds[index], leftBounds[index] + rightBounds[index] - 1))

    for pair in pairs:
        for value in pair[0]..pair[1]:
            yield value


proc solution2(): int = 

    proc translateValue(value: int, mapping: seq[MappingEntry]): int = 
        for entry in mapping:
            if value >= entry.source and value < (entry.source + entry.width):
                return value - entry.source + entry.destination 
        return value

    let seedToSoil = createMapping("seed-to-soil")
    let soilToFertilizer = createMapping("soil-to-fertilizer")
    let fertilizerToWater = createMapping("fertilizer-to-water")
    let waterToLight = createMapping("water-to-light")
    let lightToTemperature = createMapping("light-to-temperature")
    let temperatureToHumidity = createMapping("temperature-to-humidity")
    let humidityToLocation = createMapping("humidity-to-location")

    var minimum: Option[int] = none(int)

    for seed in allSeeds():
        let location = seed
            .translateValue(seedToSoil)
            .translateValue(soilToFertilizer)
            .translateValue(fertilizerToWater)
            .translateValue(waterToLight)
            .translateValue(lightToTemperature)
            .translateValue(temperatureToHumidity)
            .translateValue(humidityToLocation)
        
        if minimum.isNone or location < minimum.get:
            minimum = some(location)

    return minimum.get


let startTime = cpuTime()

echo fmt"*** Day {DAY} ***"
echo fmt"Solution 1: {solution1()}"
echo fmt"Solution 2: {solution2()}"

echo fmt"Time taken: {cpuTime() - startTime:.3f}s"
