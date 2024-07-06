from property import PropertyType

type BareMethod* = object of RootObj
    name*: string
    parameters*: seq[PropertyType]
    returnType*: PropertyType

type Method* = ref object of BareMethod
    function: proc(args: varargs[PropertyType]): PropertyType

proc newMethod*(name: string, parameters: seq[PropertyType] = @[PropertyType.Nil], returnType: PropertyType, function: proc(args: varargs[PropertyType]): PropertyType): Method =
    Method(
        name: name,
        parameters: parameters,
        returnType: returnType,
        function: function
    )

proc callMethod*(method_obj: Method, args: varargs[PropertyType]): PropertyType =
    method_obj.function(args)

