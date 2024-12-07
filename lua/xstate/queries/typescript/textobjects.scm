; Gets the root machine config and setup config
(call_expression 
  function: (member_expression
  object: (call_expression
  function: (identifier) @setup (#eq? @setup "setup")
  arguments: (arguments
    (object) @xstate.setup_config
  ))
  property: (property_identifier) @createMachine (#eq? @createMachine "createMachine")
) arguments: (arguments
    (object) @xstate.machine_config)
  )

; Gets the states of the machiine
(pair
  key: (property_identifier) @xstate.states (#eq? @xstate.states "states")
  value: (object
    (pair
      key: (property_identifier) @xstate.state.name
      value: (object) @xstate.state.config) @xstate.state.node))

; Gets the events in a state
(pair
  key: (property_identifier) @xstate.events (#eq? @xstate.events "on")
  value: (object
    (pair
      key: [(property_identifier) (string)] @xstate.event.name
      value: [(string) (object) (array)] @xstate.event.config) @xstate.event.node))

