import Observer from "./observer"

class Provider

  @make: ( url ) ->
    Object.assign ( new @ ),
      { url, observers: new Set }
  
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
    @observers.delete observer
      
  dispatch: ( event ) ->
    @observers.forEach ( observer ) ->
      observer.dispatch event

export default Provider