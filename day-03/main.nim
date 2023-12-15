from std/strutils import splitLines, parseInt
from std/strformat import fmt
from std/times import cpuTime
from std/sets import toHashSet, contains, HashSet, len, items, initHashSet, incl
from std/options import Option, some, none, isSome, get
from std/hashes import hash


const input: seq[string] = readFile("input.txt").splitLines()


proc solution1(): int =
    let numbers = toHashSet(["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"])
    let disregardCharacters = toHashSet(["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "."])

    proc positionIsSymbol(lineIndex: int, charIndex: int): bool = 
        if lineIndex < 0 or lineIndex >= len(input) or charIndex < 0 or charIndex >= len(input[lineIndex]):
            return false
        return not ($input[lineIndex][charIndex] in disregardCharacters)

    proc isAdjacentToSymbol(lineIndex: int, charIndex: int): bool = 
        if positionIsSymbol(lineIndex + 1, charIndex):
            return true
        if positionIsSymbol(lineIndex + 1, charIndex + 1):
            return true
        if positionIsSymbol(lineIndex, charIndex + 1):
            return true
        if positionIsSymbol(lineIndex - 1, charIndex + 1):
            return true
        if positionIsSymbol(lineIndex - 1, charIndex):
            return true
        if positionIsSymbol(lineIndex - 1, charIndex - 1):
            return true
        if positionIsSymbol(lineIndex, charIndex - 1):
            return true
        if positionIsSymbol(lineIndex + 1, charIndex - 1):
            return true
        return false

    var acc: int = 0

    for lineIndex in 0..(len(input)-1):
        var numberAcc = ""
        var foundSymbol = false

        let line = input[lineIndex]

        for charIndex in 0..(len(line)-1):
            let currentChar = $line[charIndex]

            if currentChar in numbers:
                numberAcc = fmt"{numberAcc}{currentChar}"

                if (not foundSymbol and isAdjacentToSymbol(lineIndex, charIndex)):
                    foundSymbol = true
            
            elif numberAcc != "" and foundSymbol:
                acc += parseInt(numberAcc)
                numberAcc = ""
                foundSymbol = false
            
            elif numberAcc != "":
                numberAcc = ""
            
        if numberAcc != "" and foundSymbol:
            acc += parseInt(numberAcc)
    
    return acc


proc solution2(): int = 
    let numbers = toHashSet(['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'])

    type NumberLineRanges = seq[seq[tuple[colStart: int, colEnd: int]]]

    proc buildNumberLineRanges(): seq[seq[tuple[colStart: int, colEnd: int]]] =
        var acc: NumberLineRanges = @[]

        for lineIndex in 0..(len(input)-1):
            let line = input[lineIndex]
        
            var lineAcc: seq[tuple[colStart: int, colEnd: int]] = @[]

            var startIndex: Option[int] = none(int)

            for charIndex in 0..(len(line)-1):
                let currentChar = line[charIndex]

                let isNumber: bool = currentChar in numbers

                if not startIndex.isSome and isNumber:
                    startIndex = some(charIndex)
                elif startIndex.isSome and not isNumber:
                    lineAcc.add((colStart: startIndex.get(), colEnd: charIndex-1))
                    startIndex = none(int)
            
            if startIndex.isSome:
                lineAcc.add((colStart: startIndex.get(), colEnd: len(line)-1))
            
            acc.add(lineAcc)
        
        return acc

    type TaggedNumberRange = tuple[row: int, r: tuple[colStart: int, colEnd: int]]

    type Coordinate = tuple[row: int, col: int]

    proc getRangeForCoordinate(ranges: NumberLineRanges, coordinate: Coordinate): Option[TaggedNumberRange] = 
        let row = coordinate.row
        let col = coordinate.col

        let numberRanges = ranges[row]
        
        if len(numberRanges) == 0 or row < 0 or col < 0:
            return none(TaggedNumberRange)

        for r in numberRanges:
            if r.colStart <= col and col <= r.colEnd:
                return some((row: row, r: r))
        
        return none(TaggedNumberRange)


    proc getGearCoords(): seq[Coordinate] = 
        var coords: seq[tuple[row: int, col: int]] = @[]

        for row in 0..(len(input) - 1):
            for col in 0..(len(input[row]) - 1):
                let c = input[row][col]
                
                if c == '*':
                    coords.add((row: row, col: col))
        
        return coords

    let ranges = buildNumberLineRanges()

    proc getAdjacentNumbers(coordinate: Coordinate): HashSet[TaggedNumberRange] = 
        let row = coordinate.row
        let col = coordinate.col

        let adjacentCoords = @[
            (row: row - 1, col: col - 1),
            (row: row + 1, col: col + 1),
            (row: row, col: col - 1),
            (row: row, col: col + 1),
            (row: row - 1, col: col + 1),
            (row: row + 1, col: col - 1),
            (row: row - 1, col: col),
            (row: row + 1, col: col)
        ]

        var results: HashSet[TaggedNumberRange] = initHashSet[TaggedNumberRange]()

        for coord in adjacentCoords:
            let r = getRangeForCoordinate(ranges, coord)

            if r.isSome:
                results.incl(r.get())
        
        return results

    proc getGearRatio(coordinate: Coordinate): int = 
        let adjacentNumbers = getAdjacentNumbers(coordinate)

        if len(adjacentNumbers) != 2:
            return 0

        var total = 1

        for a in adjacentNumbers:
            total *= parseInt(input[a.row][(a.r.colStart)..(a.r.colEnd)])

        return total

    var acc = 0

    let gearCoords = getGearCoords()

    for coord in gearCoords:
        acc += getGearRatio(coord)

    return acc


let startTime = cpuTime()

echo "*** Day 2 ***"
echo fmt"Solution 1: {solution1()}"
echo fmt"Solution 2: {solution2()}"

echo fmt"Time taken: {cpuTime() - startTime:.3f}"