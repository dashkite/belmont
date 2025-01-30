import { Queue } from "@dashkite/joy/iterable"
import EventReactor from "@dashkite/reactive/event-reactor"

class Observer extends EventReactor

  @make: ->
    do ({ queue } = {}) =>
      queue = Queue.make()
      self = @from do ->
        loop
          event = await queue.dequeue()
          yield event
          break if ( event.name == "cancel" ) || ( event.name == "delete" ) 
      self.queue = queue
      self

  dispatch: ( event ) -> @queue.enqueue event

export default Observer