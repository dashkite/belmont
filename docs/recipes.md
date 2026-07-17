# Recipes

## How to resolve a remote resource locator

Often, you will need to map an abstract resource locator to a concrete provider that can handle the underlying network or storage operations.
Belmont enables this seamless mapping by allowing you to resolve a declarative locator object into a reactive resource instance.

```coffeescript
# assuming providers have been registered previously
resource = await Resource.resolve
  origin: "https://api.example.com"
  name: "greeting"

resource.subscribe (event) ->
  console.log "Received event:", event.name
```

1. Construct a locator object containing the required properties, such as the `origin` and `name`.
2. Await the `Resource.resolve` method, passing the locator as an argument.
3. Subscribe to the returned resource to listen for reactive events emitted by the underlying provider.

## How to register a protocol provider

To resolve locators correctly, Belmont needs to know which provider handles which protocol scheme (e.g., `https`, `file`).
Belmont manages this routing through a singleton registry that associates protocol scheme strings with concrete provider classes.

```coffeescript
import Broadway from "@dashkite/broadway"
import Providers from "@dashkite/belmont/providers"

Providers.add "https", Broadway
providerClass = Providers.find "https://api.example.com"
```

1. Import your target provider class, such as `Broadway` for HTTP operations.
2. Call `Providers.add`, passing the protocol scheme string (like `"https"`) and the provider class.
3. Verify the registration by calling `Providers.find` with a fully qualified URL to retrieve the associated provider class.

## How to implement a custom resource provider

In specialized environments, you may need to interact with a proprietary storage system or a unique network protocol.
Belmont accommodates these scenarios by providing a base `Provider` class that you can extend to implement custom resource operations and publish standard reactive events.

```coffeescript
import Provider from "@dashkite/belmont/provider"

class CustomProvider extends Provider
  get: ->
    # complex data fetching logic goes here
    data = { status: "success" }
    @publish name: "value", value: data

  refresh: ->
    url = await @resolve()
    # reconnection logic goes here using the newly resolved url

provider = CustomProvider.make 
  url: "custom://local/data"
  locator: { origin: "custom://local" }
```

1. Import the base `Provider` class from `@dashkite/belmont/provider`.
2. Extend the base class and define the necessary interaction methods (e.g., `get`, `put`, `refresh`).
3. Call the inherited `@publish` method within your operations to emit events back through the reactive stream.
4. Utilize the inherited `@resolve` method if your provider needs to recalculate its URL dynamically from the underlying locator.
5. Use the static `make` method to instantiate your custom provider with a `url` and `locator` object.

## How to manage asynchronous events with observers

Advanced providers occasionally require buffering or orchestrating a complex sequence of internal events before publishing them to consumers.
Belmont includes an `Observer` utility that establishes a dedicated event loop and queue, allowing you to dispatch and process internal events asynchronously.

```coffeescript
import Observer from "@dashkite/belmont/observer"

observer = Observer.make()

# complex internal process generating events goes here
observer.dispatch name: "internal-update", data: 123
observer.dispatch name: "internal-update", data: 456

# shutdown condition met
observer.cancel()
```

1. Call `Observer.make()` to instantiate the observer and start its internal asynchronous event loop.
2. Use the `dispatch` method to enqueue events into the observer's stream for processing.
3. Call the `cancel` method to gracefully terminate the event loop when the observer is no longer needed.
