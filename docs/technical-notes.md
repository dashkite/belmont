# Technical Notes

### The Reactive Resource Model

DashKite's reactive resource pattern is our solution to bridging the inherent complexities of distributed systems. Rather than writing in a brittle imperative style that pretends the network does not exist, this model constructs higher-level abstractions that treat resources as distinct entities communicating via message passing.

By using Sublime to handle hypermedia representation formatting concerns and Altair to handle the request-response cycle at a low level, the overarching reactive resource model allows developers to express intention within our model-view-controller (MVC) component structures declaratively. Belmont has a much narrower remit within this ecosystem: it simply acts as the manager that maps these high-level resource locators to concrete, event-driven providers. 

In this model, message passing occurs through a multiplexing event stream. When combined with the Sky API model, developers can logically name the resources they need access to and await their fulfillment. This abstracts away low-level network details and failure modes, allowing the high-level code path to remain extremely focused and narrative-driven.

### Provider Caching and the Registry Pattern

Belmont maintains a registry of instantiated providers keyed by their resolved URL. This is an application of the DashKite Registry Pattern, which serves as a structural approach to managing global state. When resolving a locator that maps to an already-cached URL, Belmont returns the existing provider instance rather than creating a new one. Sharing the exact same instance guarantees that subscriptions and states for the same resource are shared, enabling safe same-instance equality checks and preventing race conditions for stateful components.

### URL Resolution and Sky APIs

The `resolve` function leverages `Scout` for discovery and `URLCodex` for binding variables into templates, depending on the locator properties. While Scout provides the mechanism for *how* endpoints are discovered and encoded, the Sky API concept provides the *why*. 

Sky APIs define highly structured, constraint-based hypermedia interfaces that explicitly model an application's interface. By grouping HTTP resources under related names expressed via URL Codex templates, Sky APIs allow developers to reason about entire abstract resource spaces effortlessly. Belmont uses these abstractions to logically name resources and translate those names into concrete URLs, allowing the reactive resource model to map high-level intentions to actual network endpoints.
