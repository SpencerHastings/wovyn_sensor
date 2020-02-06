ruleset wovyn_base {

    rule process_heartbeat {
        select when wovyn:heartbeat genericThing re#(.+)#
        send_directive("test", {"hello": "world"})
        fired {
            raise wovyn event "new_temperature_reading"
                attributes {"temperature":event:attr("temperatureF"), "timestamp":time:now()}
        }
    }
}