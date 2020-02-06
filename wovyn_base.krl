ruleset wovyn_base {

    rule process_heartbeat {
        select when wovyn:heartbeat genericThing re#(.+)#
        send_directive("test", {"hello": "world"})
    }
}