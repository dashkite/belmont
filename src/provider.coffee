import Topic from "@dashkite/reactive/topic"
import { metaclass } from "@dashkite/joy/metaclass"

class Provider extends metaclass Topic

  @make: ({ url, locator }) ->
    Object.assign ( new @ ), { url, locator }

  constructor: -> super()

  publish: ( event ) -> super event

  resolve: -> @constructor.resolve @locator

export default Provider
