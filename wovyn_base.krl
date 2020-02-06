ruleset wovyn_base {

    global {
        temperature_threshold = 71.0
    }

    rule process_heartbeat {
        select when wovyn:heartbeat genericThing re#(.+)#
        pre {
            temp = event:attr("genericThing").get("data").get("temperature").head()

        }
        send_directive("test", {"hello": "world"})
        fired {
            raise wovyn event "new_temperature_reading"
                attributes {"temperature":temp.get("temperatureF"), "timestamp":time:now()}
        }
    }

    rule find_high_temps {
        select when wovyn:new_temperature_reading
        pre {
            temperature = event:attr("temperature")
            is_violation = (temperature > temperature_threshold) 
                => true | false
        }
        send_directive("temp_reading", {"is_violation": is_violation})
        fired {
            raise wovyn event "threshold_violation" 
                attributes {"temperature": temperature, "threshold": temperature_threshold}
                if is_violation
        }
    }
}