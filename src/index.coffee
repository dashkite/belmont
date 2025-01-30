import Providers from "./providers"

Registry = {}

class Resource

  @make: ( url ) ->
    if ( provider = Providers.find url )?
      provider.make url
    else
      throw new Error "Belmont: No provider found for [ #{ url } ]"

  @resolve: ( url ) ->
    Registry[ url ] ?= @make url

export default Resource