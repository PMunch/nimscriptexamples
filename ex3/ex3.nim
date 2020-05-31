import compiler / [nimeval, ast]
import osproc, strutils, algorithm

var
  nimdump = execProcess("nim dump")
  nimlibs = nimdump[nimdump.find("-- end of list --")+18..^2].split
nimlibs.sort

let
  intr = createInterpreter("script.nims", nimlibs)
intr.evalScript()
intr.destroyInterpreter()

let sym = intr.selectUniqueSymbol("testSeq")
assert sym != nil,
  "Script does not export a global of the name: 'testSeq'"
assert sym.typ.kind == tySequence,
  "Script defines global: 'testSeq' as something other than a sequence"

var output: seq[string]
let val = intr.getGlobalValue(sym)
for data in val.sons:
  assert data.typ.kind == tyString,
    "Script defines inner type as something other than a string"
  output.add data.strVal

echo "From compiled: ", output

