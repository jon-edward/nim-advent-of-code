import std/enumerate
import nre
import seqUtils
import sets
import strutils
import strformat
import times

const input: seq[string] = readFile("input.txt").splitLines()


proc parseCardLine(line: string): tuple[winningNumbers: HashSet[string], testNumbers: HashSet[string]] =
        let lineMatch = line.match(re"Card\s+\d+:\s*((?:\s*\d+)+)\s+\|\s+((?:\s*\d+)+)").get
        
        let winningNumbers = lineMatch.captures[0].split(re"\s+").toHashSet
        let testNumbers = lineMatch.captures[1].split(re"\s+").toHashSet
        
        return (winningNumbers: winningNumbers, testNumbers: testNumbers)


proc solution1(): int =

    var points = 0

    for line in input:
        let (winningNumbers, testNumbers) = parseCardLine(line)
        let alikeSize = len(winningNumbers * testNumbers)

        points += (
            case alikeSize
            of 0: 0
            else: 1 shl (alikeSize-1)
        )

    return points


proc solution2(): int =
    var copiesAccumulate: seq[int] = newSeqWith(input.len, 1)

    for i, line in enumerate(input):
        let (winningNumbers, testNumbers) = parseCardLine(line)
        let currentVal = copiesAccumulate[i]
        let alikeSize = len(winningNumbers * testNumbers)

        var index = 1 + i

        while (index < (alikeSize + i + 1)) and index < len(copiesAccumulate):
            copiesAccumulate[index] += currentVal
            index += 1
    
    var acc = 0

    for a in copiesAccumulate:
        acc += a
    
    return acc


let startTime = cpuTime()

echo "*** Day 4 ***"
echo fmt"Solution 1: {solution1()}"
echo fmt"Solution 2: {solution2()}"

echo fmt"Time taken: {cpuTime() - startTime:.3f}s"
