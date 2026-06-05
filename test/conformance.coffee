import { test } from "@dashkite/amen"
import assert from "@dashkite/assert"
import * as Fn from "@dashkite/joy/function"

wait = ( events, predicate ) ->
  return event for await event from events when predicate event

verify = ({ resolve, trigger, predicate }) -> ->
  do ({ resource, context, events, event } = {}) ->
    { resource, context... } = await resolve()
    events = resource.subscribe()
    trigger { resource, context... }
    event = await wait events, predicate
    assert event?
    events.close()

subtest = ( description, specifier ) ->
  test description, wait: 1000, verify specifier

isResourceEvent = Fn.curry ( name, event ) ->
  ( event.name == name ) && ( event.scope == "resource" )

isRequestEvent = Fn.curry ( name, event ) ->
  ( event.name == name ) && ( event.scope in [ "request", "response" ] )

conformance = ( factory ) ->

  tests = [
    
    await subtest "`get` emits value for existing resource",
      resolve: factory.existing
      trigger: ({ resource }) -> resource.get()
      predicate: isResourceEvent "value"

    await subtest "`get` emits not-found for missing resource",
      resolve: factory.missing
      trigger: ({ resource }) -> resource.get()
      predicate: isRequestEvent "not-found"

    await subtest "`put` emits created for new resource",
      resolve: factory.missing
      trigger: ({ resource }) -> 
        resource.put { title: "New", body: "I'm a teapot" }
      predicate: isResourceEvent "created"

    await subtest "`put` emits value for existing resource",
      resolve: factory.existing
      trigger: ({ resource }) -> 
        resource.put { title: "Updated", body: "I'm a teapot" }
      predicate: isResourceEvent "value"

    await subtest "`delete` emits delete",
      resolve: factory.existing
      trigger: ({ resource }) -> resource.delete()
      predicate: isResourceEvent "deleted"
  ]

  if factory.creatable?
    tests.push await subtest "`post` emits created with locator",
      resolve: factory.creatable
      trigger: ({ resource, data }) -> resource.post data
      predicate: ( event ) ->
        ( isResourceEvent "created", event ) && event.locator?

  if factory.unsupported?
    tests.push await subtest "Emits method-not-allowed for unsupported operations",
      resolve: factory.unsupported
      trigger: ({ resource, method }) -> resource[ method ]()
      predicate: isRequestEvent "method-not-allowed"

  test "Chicago Protocol Conformance", tests

export default conformance
