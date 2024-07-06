
type PropertyType* = enum
    Nil # empty return types n stuff will just be treated as nil
    # also for undefined parameters or returns if they arent needed
    String
    Int
    Number
    Vec3

type Property* = object
    name: string
    propertyType: PropertyType

proc getPropertyType*(property: Property): PropertyType =
    return property.propertyType

proc getPropertyName*(property: Property): string =
    return property.name