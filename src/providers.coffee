protocol = ( url ) ->
  ( new URL url )
    .protocol[...-1]

Dictionary = {}

Providers =

  add: ( scheme, provider ) ->
    Dictionary[ scheme ] = provider

  find: ( url ) -> Dictionary[ protocol url ]

export default Providers