import compiler / [nimeval, renderer, ast, types, llstream]
import osproc, strutils, algorithm

# This uses your Nim install to find the standard library instead of hard-coding it
var
  nimdump = execProcess("nim dump")
  nimlibs = nimdump[nimdump.find("-- end of list --")+18..^2].split
nimlibs.sort

let
  intr = createInterpreter("noscript.nims", nimlibs)
intr.evalScript(llStreamOpen("""
import tables
let testTable* = {"hello": 42, "world": 100}.toTable
"""))
echo intr.getGlobalValue(intr.selectUniqueSymbol("testTable"))

intr.destroyInterpreter()

