import Observer from "./observer"

class Provider

  @make: ({ url, locator }) ->
    Object.assign ( new @ ),
      { url, locator, observers: new Set }
  
  resolve: -> @.constructor.resolve @locator
  
  observe: ->

    observer = Observer.make()

    @get()
      .when "value", ({ value }) ->
        observer.dispatch { name: "update", value }
      .when "failure", ( error ) ->
        observer.dispatch error
      .run()
    
    @observers.add observer
    observer
    
  cancel: ( observer ) ->
    if @observers.has observer
      observer.dispatch "cancel"
      @observers.delete observer
      
  dispatch: ( event ) ->
    @observers.forEach ( observer ) ->
      observer.dispatch event

export default Provider