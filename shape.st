Object subclass: Shape 
[
    | name comparison |
    Shape class >> new: aName
    [
        | instance |
        instance := super new.
        instance init: aName.
        ^ instance.
    ]

    init: aName 
    [
        name := aName.
        "comparison dictionary"
        comparison := Dictionary new.
        comparison at: '==' put: [:leftValue :rightValue | leftValue = rightValue].
        comparison at: '>=' put: [:leftValue :rightValue | leftValue >= rightValue].
        comparison at: '<=' put: [:leftValue :rightValue | leftValue <= rightValue].
        comparison at: '!=' put: [:leftValue :rightValue | leftValue ~= rightValue].
        comparison at: '>' put: [:leftValue :rightValue | leftValue >= rightValue].
        comparison at: '<' put: [:leftValue :rightValue | leftValue < rightValue].
    ]

    compare: op left: lValue right: rValue[
        ^ (comparison at: op) value: lValue value: rValue. 
    ]

    getName 
    [
        ^ name.
    ]

    setName: aString
    [
        name := aString.
    ]

    getArea
    [
        self subclassResponsibility.
    ]

    getVolume
    [
        self subclassResponsibility.
    ]

    test: anArray
    [
        self subclassResponsibility.
    ]   

    getInfo
    [
        self subclassResponsibility.
    ]


]


