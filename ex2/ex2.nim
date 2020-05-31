import compiler / [nimeval, renderer, ast, types]
import osproc, strutils, algorithm

# This uses your Nim install to find the standard library instead of hard-coding it
var
  nimdump = execProcess("nim dump")
  nimlibs = nimdump[nimdump.find("-- end of list --")+18..^2].split
nimlibs.sort

let
  intr = createInterpreter("script.nims", nimlibs)
intr.evalScript()
intr.destroyInterpreter()

for sym in intr.exportedSymbols:
  if sym.typ.kind in {tyInt, tyString}:
    echo sym.name.s, " = ", intr.getGlobalValue(sym)

when false: # Looking at some more types
  for sym in intr.exportedSymbols:
    echo sym.name.s, ":"
    echo "\t", sym.typ.kind
    echo "\ttype name: ", typeToString(sym.typ, preferName)
    if sym.typ.kind in {tyInt, tyString, tyGenericInst}:
      echo "\t= ", intr.getGlobalValue(sym)
    if sym.typ.kind in {tySequence, tyGenericInst}:
      for i, son in intr.getGlobalValue(sym).sons:
        echo "\t[", i, "] = ", $son
