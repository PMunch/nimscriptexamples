import json, tables

var
  table = {"hello": 42, "world": 100}.toTable
  jsonTable* = $(%table) # First convert to JSON, then to a string
