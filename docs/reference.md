# Reference

## Resource

### resolve
$resolve: locator \dashrightarrow resource$

Asynchronously resolves a resource locator to a `Resource` instance. Returns a cached instance if available for the same URL.

```coffee
resource = await Resource.resolve
  origin: "https://api.example.com"
  name: "greeting"
  bindings: { name: "world" }
```

## Providers

### add
$add: scheme, provider \to \emptyset$

Registers a provider class for a given protocol scheme (e.g., `https`, `local`).

```coffee
Providers.add "https", Broadway
```

### find
$find: url \to provider$

Finds the registered provider for the protocol in the given URL.

## Provider

The base class for resource providers. Extends `@dashkite/reactive/topic`.

### make
$make: url, locator \to provider$

Creates a new provider instance with the given URL and locator.

### url
$url \to string$

The concrete URL of the resource.

### locator
$locator \to object$

The original resource locator.
