; ; Gets the root machine config and setup config
; (call_expression 
;   function: (member_expression
;   object: (call_expression
;   function: (identifier) @setup (#eq? @setup "setup")
;   arguments: (arguments
;     (object)@setup_config
;   ))
;   property: (property_identifier) @createMachine (#eq? @createMachine "createMachine")
; ) arguments: (arguments
;     (object)@machine_config)
;   )

; Gets the states of the machiine
(pair
  key: (property_identifier) @xstate.states (#eq? @xstate.states "states")
  value: (object
    (pair
      key: (property_identifier) @xstate.state.name
      value: (_))))
