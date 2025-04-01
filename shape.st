Object subclass: Shape 
[
    | name |
    <comment: 'Name of shape'>

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


