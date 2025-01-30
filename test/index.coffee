import assert from "@dashkite/assert"
import {test, success} from "@dashkite/amen"
import print from "@dashkite/amen-console"

import $ from "../src"

do ->

  print await test "Halstead", [

    test "todo"

  ]

  process.exit if success then 0 else 1