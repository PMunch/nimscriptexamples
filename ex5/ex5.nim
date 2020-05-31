import compiler / [nimeval, renderer, ast, types, llstream]
import osproc, strutils, algorithm

# This uses your Nim install to find the standard library instead of hard-coding it
var
  nimdump = execProcess("nim dump")
  nimlibs = nimdump[nimdump.find("-- end of list --")+18..^2].split
nimlibs.sort

let
  intr = createInterpreter("script.nims", nimlibs)
  script = readFile("script.nims")

# We forward declare scriptProc here to ensure it has the right signature
# Specifying a llStream to read from will not run top-level things from the
# script like it usually would. The name given above will only be used for errors.
intr.evalScript(llStreamOpen("proc scriptProc*(one, two: int): int\n" & script))


let
  foreignProc = intr.selectRoutine("scriptProc")
  ret = intr.callRoutine(foreignProc, [newIntNode(nkIntLit, 10), newIntNode(nkIntLit, 32)])

echo ret.intVal

intr.destroyInterpreter()

