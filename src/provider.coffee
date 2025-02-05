import Observer from "./observer"

class Provider

  @make: ({ url, locator }) ->
    Object.assign ( new @ ),
      { url, locator, observers: new Set }
  
  resolve: -> @.constructor.resolve @locator
  
  observe: ->
    observer = Observer.make()    
    @observers.add observer
    observer
    
  cancel: ( observer ) ->
    if @observers.has observer
      observer.cancel()
      @observers.delete observer
      
  dispatch: ( event ) ->
    @observers.forEach ( observer ) ->
      observer.dispatch event

export default Provider