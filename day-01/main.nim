from std/strutils import parseInt, splitLines, formatFloat
from std/strformat import fmt
from std/re import re, findBounds, Regex
from std/algorithm import sort
from std/seqUtils import map, concat
from std/times import cpuTime
import std/tables


const input: seq[string] = readFile("input.txt").splitLines()


proc solution1(): int =
    let digitRe = re"\d(?:[a-zA-Z0-9]*\d)?"

    var acc: int = 0

    for entry in input:
        let bounds = findBounds(entry, digit_re)

        let firstChar = entry[bounds[0]]
        let lastChar = entry[bounds[1]]
        
        acc += parseInt(fmt"{firstChar}{lastChar}")

    return acc


proc solution2(): int = 
    let wordRe = re"one|two|three|four|five|six|seven|eight|nine"

    #  Handles overlapping matches (ie. "eightwo", "nineight", etc.)
    proc crawlStartIndices(s: string, pattern: Regex): seq[tuple[start: int, substring: string]] = 
        var matches: seq[tuple[start: int, substring: string]] = @[];
        
        var currentString = s
        var currentMatch = findBounds(currentString, pattern)
        var offset = 0

        while currentMatch != (-1, 0):
            let matchSubstring = currentString[currentMatch[0] .. currentMatch[1]]
            let matchStart = currentMatch[0]

            matches.add((start: matchStart + offset, substring: matchSubstring))

            currentString = currentString[matchStart + 1 .. ^1]
            offset += matchStart + 1
            currentMatch = findBounds(currentString, pattern)
        
        return matches

    let wordToIntMapping = {
        "one": "1",
        "two": "2",
        "three": "3",
        "four": "4",
        "five": "5",
        "six": "6",
        "seven": "7",
        "eight": "8",
        "nine": "9"
    }.toTable

    proc toDigits(t: tuple[start: int, substring: string]): tuple[start: int, substring: string] = 
        if t.substring in wordToIntMapping:
            return (start: t.start, substring: wordToIntMapping[t.substring])
        return t

    proc compareMatches(x, y: tuple[start: int, substring: string]): int = 
        return cmp(x.start, y.start)

    var acc: int = 0

    for entry in input:
        var matches = crawlStartIndices(entry, wordRe)
        matches = concat(map(matches, toDigits), crawlStartIndices(entry, re"\d"))
        matches.sort(compareMatches)

        acc += parseInt(fmt"{matches[0].substring}{matches[^1].substring}")

    return acc


let startTime = cpuTime()

echo "*** Day 1 ***"
echo fmt"Solution 1: {solution1()}"
echo fmt"Solution 2: {solution2()}"

echo fmt"Time taken: {cpuTime() - startTime:.3f}"