# TODO switch to using a topic?
#      do we even need a base class now?
#      could we just do `x.topic.subscribe()`?

import Topic from "@dashkite/reactive/topic"

class Provider extends Topic

  @make: ({ url, locator }) ->
    Object.assign ( new @ ), { url, locator }

  constructor: -> super()

  resolve: -> @constructor.resolve @locator
  
export default Provider