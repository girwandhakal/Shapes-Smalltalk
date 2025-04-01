FileStream fileIn: 'shape.st'.
FileStream fileIn: 'box.st'.
FileStream fileIn: 'cylinder.st'.
FileStream fileIn: 'torus.st'.
FileStream fileIn: 'sphere.st'.


Object subclass: ShapeList
[
    | arrayOfShapes |
    ShapeList class >> new: fileName
    [
        | instance |

        instance := super new.
        instance init: fileName.
        ^ instance.
    ]

    getArray
    [
        ^ arrayOfShapes
    ]

    init:fileName
    [
        | words line fs instance count|
        arrayOfShapes := OrderedCollection new.
        fs := FileStream 
        open: fileName 
        mode: #read 
        ifFail: 
        [ 
            Transcript show: 'Unable to open ', fileName, ' for reading'; cr.
            ObjectMemory quit 
        ].
        count := 0.
        [ fs atEnd ] 
        whileFalse: 
        [
            line := fs nextLine.
            words := line substrings.
            ((words at: 2) = 'box')
            ifTrue:
            [
                instance := Box new: (words at: 1) 
                length: (words at: 3) asNumber 
                width: (words at: 4) asNumber 
                height: (words at: 5) asNumber. 
            ].
            ((words at: 2) = 'cylinder')
            ifTrue:
            [
                instance := Cylinder new: (words at: 1) 
                radius: (words at: 3) asNumber 
                height: (words at: 4) asNumber. 
            ].
            ((words at: 2) = 'torus')
            ifTrue:
            [
                instance := Torus new: (words at: 1) 
                smallRadius: (words at: 3) asNumber 
                bigRadius: (words at: 4) asNumber. 
            ].
            ((words at: 2) = 'sphere')
            ifTrue:
            [
                instance := Sphere new: (words at: 1) 
                radius: (words at: 3) asNumber.
            ].

            arrayOfShapes add: instance.
            count := count + 1.
        ].
        (count = 0)
        ifTrue:
        [
            Transcript show: 'There are no shapes in the file'; cr.
            ObjectMemory quit.
        ]. 

        fs close.
    ]
    "print2: we want to extract print, pri2nt: return pri"
    getAction:aString
    [
        | stringArr index count action|
        stringArr:= aString asArray.
        index := 1.
        count := 0.
        [index <= stringArr size]
        whileTrue:
        [
            ((stringArr at: index) isDigit)
            ifTrue:
            [
                count := count + 1.
            ]
            ifFalse:
            [
                index := index + stringArr size.
            ]
            index := index + 1.
        ]

        ss := ReadStream on: aString
        index:= 1.
        action:= ''.
        (index < (count + 1))
        whileTrue:
        [
            action := action, ss next asString.
            index := index + 1.
        ]
        ^action.

    ]




]



args := Smalltalk arguments.
usage := 'Usage: shape.st sphere.st cylinder.st torus.st box.st -f main.st shape_file'.

(args size = 0)
    ifTrue: [
        Transcript show: usage; cr.
        ObjectMemory quit
    ].
fileName := args first.
s:= ShapeList new: fileName.

[command = 'quit']
whileFalse:
[
    Transcript show: 'Enter a command: '.
    command := FileStream stdin nextLine.


]



