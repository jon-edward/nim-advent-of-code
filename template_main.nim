import strutils
import strformat
import times

#  Replace with day!
const DAY: int = -1

const input: seq[string] = readFile("input.txt").splitLines()


proc solution1(): int = 
    return 0


proc solution2(): int = 
    return 0


let startTime = cpuTime()

echo fmt"*** Day {DAY} ***"
echo fmt"Solution 1: {solution1()}"
echo fmt"Solution 2: {solution2()}"

echo fmt"Time taken: {cpuTime() - startTime:.3f}s"
