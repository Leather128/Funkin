function onEvent(name, position, argument1, argument2)
    if string.lower(name) == "no shader" then
        local actor = charFromEvent(argument1)
        setActorNoShader(actor)
    end
end