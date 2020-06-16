import compiler / [nimeval, renderer, ast]
import osproc, strutils, algorithm, json, tables

# This uses your Nim install to find the standard library instead of hard-coding it
var
  nimdump = execProcess("nim dump")
  nimlibs = nimdump[nimdump.find("-- end of list --")+18..^2].split
nimlibs.sort

let
  intr = createInterpreter("script.nims", nimlibs)
intr.evalScript()

# Grab the complex type as a JSON string
let
  jsonstr = intr.getGlobalValue(intr.selectUniqueSymbol("jsonTable")).getStr()
  parsed = parseJson(jsonstr)
  table = parsed.to(Table[string, int])

# Access the data in the complex type as normal Nim code
echo table["hello"]
echo table["world"]

intr.destroyInterpreter()

