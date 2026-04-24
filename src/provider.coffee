import Topic from "@dashkite/reactive/topic"

class Provider extends Topic

  @make: ({ url, locator }) ->
    Object.assign ( new @ ), { url, locator }

  constructor: -> super()

  publish: ( event ) -> super event

  resolve: -> @constructor.resolve @locator

export default Provider
