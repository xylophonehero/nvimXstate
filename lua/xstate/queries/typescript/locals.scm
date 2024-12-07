; Gets the states of the machiine
(pair
  key: (property_identifier) @xstate.states (#eq? @xstate.states "states")
  value: (object
    (pair
      key: (property_identifier) @local.definition.state
      value: (object) ) ))

; Gets the events in a state
(pair
  key: (property_identifier) @xstate.events (#eq? @xstate.events "on")
  value: (object
    (pair
      key: [(property_identifier) (string)] @local.definition.event
      value: [(string) (object) (array)])))

