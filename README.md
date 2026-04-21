# Belmont

*Chicago System Resource Manager*

[![Hippocratic License HL3-CORE](https://img.shields.io/static/v1?label=Hippocratic%20License&message=HL3-CORE&labelColor=5e2751&color=bc8c3d)](https://firstdonoharm.dev/version/3/0/core.html)

## Purpose

Belmont manages reactive resource providers. It maps abstract resource locators to concrete URLs and delegates operations to the appropriate protocol-specific provider. This allows application logic to interact with resources (like HTTP APIs or local storage) in a uniform, reactive way.

## Installation

Use your favorite package manager to install `@dashkite/belmont`.

## Usage

```coffee
import Resource from "@dashkite/belmont"
import Broadway from "@dashkite/broadway"
import Providers from "@dashkite/belmont/providers"

# Register a provider for the https protocol
Providers.add "https", Broadway

# Resolve a locator to a reactive resource
resource = await Resource.resolve
  origin: "https://api.example.com"
  name: "greeting"
  bindings: { name: "world" }

# Subscribe to changes
resource.subscribe ({ name, value }) ->
  console.log "Received #{name}:", value

# Trigger an operation
resource.get()
```

## Other Resources

- [Reference](docs/reference.md)

## Status

Not suitable for production use. Please report bugs and feature requests via the issue tracker.
