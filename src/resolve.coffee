import Generic from "@dashkite/generic"
import * as Obj from "@dashkite/joy/object"
import Scout from "@dashkite/scout"
import * as URLCodex from "@dashkite/url-codex"

resolve = do ->

  ( Generic.make "Belmont.resolve" )

    .define [ Object ], ( locator ) ->
      target = Scout.encode locator,
        await Scout.discover locator.origin
      "#{ locator.origin }#{ target }"

    # TODO support template-based locators in Scout?
    .define [ Obj.has "template" ], ( locator ) ->
      URLCodex.encode locator.template, locator.bindings

export default resolve