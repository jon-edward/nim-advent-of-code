from std/strutils import splitLines, split, parseInt
from std/strformat import fmt
from std/times import cpuTime
from std/re import replace, re, findBounds

const input: seq[string] = readFile("input.txt").splitLines()


proc solution1(): int =

    proc checkRounds(rounds: seq[string]): bool = 
        for round in rounds:
            let entries = round.split(", ")

            var red = 0
            var green = 0
            var blue = 0

            for entry in entries:

                let s = entry.split(" ")
                
                let amountString = s[0]
                let color = s[1]

                let amount = parseInt(amountString)
                
                case color:
                    of "red":
                        red += amount
                    of "green":
                        green += amount
                    of "blue":
                        blue += amount
                
            if red > 12 or green > 13 or blue > 14:
                return false
        
        return true

    var acc: int = 0

    for line in input:
        var gameLine = line.replace(re"Game \d+: ", "")
        let rounds = gameLine.split("; ")

        if checkRounds(rounds):
            let (start, last) = line.findBounds(re"(?<=Game )\d+")
            acc += parseInt(line[start .. last])
    
    return acc


proc solution2(): int = 
    
    proc getPower(rounds: seq[string]): int =

        var redMax = 0
        var greenMax = 0
        var blueMax = 0

        for round in rounds:
            let entries = round.split(", ")

            var red = 0
            var green = 0
            var blue = 0

            for entry in entries:

                let s = entry.split(" ")
                
                let amountString = s[0]
                let color = s[1]

                let amount = parseInt(amountString)
                
                case color:
                    of "red":
                        red += amount
                    of "green":
                        green += amount
                    of "blue":
                        blue += amount
            
            redMax = max(redMax, red)
            greenMax = max(greenMax, green)
            blueMax = max(blueMax, blue)
                
        return redMax * greenMax * blueMax

    var acc: int = 0

    for line in input:
        var gameLine = line.replace(re"Game \d+: ", "")
        let rounds = gameLine.split("; ")

        acc += getPower(rounds)
    
    return acc


let startTime = cpuTime()

echo "*** Day 2 ***"
echo fmt"Solution 1: {solution1()}"
echo fmt"Solution 2: {solution2()}"

echo fmt"Time taken: {cpuTime() - startTime:.3f}"