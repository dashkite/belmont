import Providers from "./providers"
import resolve from "./resolve"

Registry = {}

class Resource

  @make: ({ url, locator }) ->
    if ( provider = Providers.find url )?
      provider.make { url, locator }
    else
      throw new Error "Belmont: No provider found for [ #{ url } ]"

  @resolve: ( locator ) ->
    url = await resolve locator
    Registry[ url ] ?= @make { url, locator }

export default Resource