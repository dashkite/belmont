# Testing

The Belmont repository utilizes the standard DashKite testing infrastructure.
The tests are designed to verify the conformance of providers against the expected Chicago System protocol behaviors. They mock or instantiate simple provider factories and simulate operations to ensure that the correct events (like `value`, `not-found`, `created`) are emitted.

To run the test suite, execute the following command:

```shell
npx genie test
```
