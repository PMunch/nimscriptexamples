import tables

var importantValue* = 42
echo "hello world"

# Some more complex types
proc testProc*() =
  echo "test"
let testTable* = {"a": 100}.toTable
let testSeq* = @["Hello", "world"]
