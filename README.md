# Belmont

*Chicago System Resource Manager*

[![Hippocratic License HL3-CORE](https://img.shields.io/static/v1?label=Hippocratic%20License&message=HL3-CORE&labelColor=5e2751&color=bc8c3d)](https://firstdonoharm.dev/version/3/0/core.html)

Belmont manages reactive resource providers. It maps abstract resource locators to concrete URLs and delegates operations to the appropriate protocol-specific provider. This allows application logic to interact with resources (like HTTP APIs or local storage) in a uniform, reactive way.

## Features

- Resolves abstract resource locators to reactive providers.
- Supports extensible protocol schemes via a provider registry.
- Provides a consistent interface for operations on disparate underlying resources.
- Leverages the Chicago System architecture for event-driven resource management.

## Installation

To install this package, run the following command:

```shell
pnpm install @dashkite/belmont
```

## Usage

This example illustrates how to register a provider and resolve a resource locator.

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

- [Usage Guides](docs/recipes.md)
- [Reference](docs/reference.md)
- [Technical Notes](docs/technical-notes.md)
- [Testing](docs/testing.md)
