# Reference

## Core Concepts

Belmont's public interface heavily utilizes a few key concepts throughout its methods:
* **Locator**: An abstract object describing a resource. It typically includes properties like `origin`, `name`, and optional `bindings` (for templated locators) or `template`.
* **Provider**: A concrete, protocol-specific handler (like an HTTP handler or a local storage handler) to which Belmont delegates operations. Providers extend `@dashkite/reactive/topic` to emit events via the Chicago System.
* **Resource**: A logical wrapper around a provider instance, establishing the overarching reactive resource model.

## Resource

The primary entry point for resolving abstract locators into reactive resource providers.

### resolve:
$resolve: locator \dashrightarrow resource$

Asynchronously resolves an abstract resource `locator` to a concrete `Resource` instance (a provider). Belmont maintains a cache keyed by the resolved URL, so subsequent calls for the same URL return the exact same instance. This ensures that state and subscriptions are safely shared.

```coffeescript
resource = await Resource.resolve
  origin: "https://api.example.com"
  name: "greeting"
  bindings: { name: "world" }

assert.equal typeof resource.subscribe, "function"
```

### make:
$make: options \to resource$

Instantiates or retrieves a provider for a given URL and locator directly. Typically, developers should use `resolve:` instead, as `make:` assumes the URL string has already been successfully calculated.

```coffeescript
options = 
  url: "https://api.example.com/greeting"
  locator: { origin: "https://api.example.com" }

resource = Resource.make options
assert.equal resource.url, "https://api.example.com/greeting"
```

## Providers

A singleton registry that maps protocol schemes to their respective provider classes.

### add:
$add: scheme, provider \to \emptyset$

Registers a `provider` class for a specific protocol `scheme` (e.g., `https`, `local`). This allows `Resource` to dynamically select the correct handler when resolving URLs.

```coffeescript
import Broadway from "@dashkite/broadway"

Providers.add "https", Broadway
assert.equal Providers.find("https://api.example.com"), Broadway
```

### find:
$find: url \to provider$

Looks up the registered provider class based on the protocol scheme extracted from the given `url`.

```coffeescript
providerClass = Providers.find "https://api.example.com/data"
assert.equal providerClass, Broadway
```

## Provider

The base class for all resource providers. It extends `@dashkite/reactive/topic` to provide multiplexing event stream capabilities. Custom providers should extend this class to participate in the reactive resource model.

### make:
$make: options \to provider$

Creates a new instance of the provider, attaching the provided `url` and `locator` to the instance.

```coffeescript
provider = Provider.make
  url: "local://storage/users"
  locator: { origin: "local://storage" }

assert.equal provider.url, "local://storage/users"
```

### publish:
$publish: event \to \emptyset$

Emits an `event` through the reactive topic stream. Providers call this method when underlying operations complete, such as receiving a network response or encountering an error.

```coffeescript
provider.publish 
  name: "value"
  value: { hello: "world" }
```

### resolve:
$resolve: \to url$

A helper method that re-resolves the provider's `locator` into a URL. This is useful for providers that might need to dynamically refresh their connection strings or endpoints.

```coffeescript
url = await provider.resolve()
assert.equal typeof url, "string"
```

### url
$url \to string$

The concrete URL assigned to this provider instance.

### locator
$locator \to object$

The abstract resource locator object that was used to create this provider instance.

## Observer

A specialized reactive event reactor used internally or by advanced providers to observe and dispatch events through an asynchronous queue.

### make:
$make: \to observer$

Creates a new `Observer` instance that immediately begins processing its internal queue until a `cancel` or `delete` event is encountered.

```coffeescript
observer = Observer.make()
assert.equal typeof observer.dispatch, "function"
```

### dispatch:
$dispatch: event \to \emptyset$

Enqueues an `event` into the observer's asynchronous processing stream. 

```coffeescript
observer.dispatch { name: "value", data: 123 }
```

### cancel:
$cancel: \to \emptyset$

A convenience method that dispatches a `cancel` event, which signals the observer's event loop to safely terminate.

```coffeescript
observer.cancel()
```
