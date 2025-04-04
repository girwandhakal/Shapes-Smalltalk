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

printHelp [
    | names ops |
    names := #('type' 'area' 'volume').
    ops := #('==' '!=' '>=' '<=' '>' '<').

    Transcript show: '    count'; cr.
    Transcript show: '    *** print the number of all shapes'; cr.
    Transcript show: '    countN'; cr.
    Transcript show: '    *** print the number of all shapes that satisfy all N conditions specified below'; cr.
    Transcript show: '    *** for example: count3'; cr.
    Transcript show: '    print'; cr.
    Transcript show: '    *** print all shapes'; cr.
    Transcript show: '    printN'; cr.
    Transcript show: '    *** print all shapes that satisfy all N conditions specified below'; cr.
    Transcript show: '    *** for example: print4'; cr.
    Transcript show: '    min'; cr.
    Transcript show: '    *** find the minimum surface area and volume of all shapes'; cr.
    Transcript show: '    minN'; cr.
    Transcript show: '    *** find the minimum surface area and volume of all shapes that satisfy all N conditions specified below'; cr.
    Transcript show: '    *** for example: min2'; cr.
    Transcript show: '    max'; cr.
    Transcript show: '    *** find the maximum surface area and volume of all shapes'; cr.
    Transcript show: '    maxN'; cr.
    Transcript show: '    *** find the maximum surface area and volume of all shapes that satisfy all N conditions specified below'; cr.
    Transcript show: '    *** for example: max3'; cr.
    Transcript show: '    total'; cr.
    Transcript show: '    *** find the total surface area and volume of all shapes'; cr.
    Transcript show: '    totalN'; cr.
    Transcript show: '    *** find the total surface area and volume of all shapes that satisfy all N conditions specified below'; cr.
    Transcript show: '    *** for example: total4'; cr.
    Transcript show: '    avg'; cr.
    Transcript show: '    *** find the average surface area and volume of all shapes'; cr.
    Transcript show: '    avgN'; cr.
    Transcript show: '    *** find the average surface area and volume of all shapes that satisfy all N conditions specified below'; cr.
    Transcript show: '    *** for example: avg2'; cr.
    Transcript show: '    quit'; cr.
    Transcript show: '    *** quit this program'; cr.
    Transcript show: '    help'; cr.
    Transcript show: '    *** print this list'; cr.
    Transcript cr.

    Transcript show: 'Each condition shall be entered in one line and of the following format:'; cr; cr.
    Transcript show: '    name op value'; cr; cr.
    Transcript show: '    *** for example: type != box'; cr.
    Transcript show: '                     area <= 1000'; cr.
    Transcript show: '                     volume > 100.5'; cr; cr.

    Transcript show: '    The valid names:'; cr.
    names do: [:n |
        Transcript show: '        ', n; cr.
    ].

    Transcript show: '    The valid operators:'; cr.
    ops do: [:o |
        Transcript show: '        ', o; cr.
    ].

    Transcript cr.
]


    getArray
    [
        ^ arrayOfShapes
    ]

    isValidAction: aString [
        | actions |
        actions := #('print' 'count' 'min' 'max' 'total' 'avg').
        ^ (actions includes: aString)
    ]


    isValidName: aString [
        | names |
        names := #('type' 'area' 'volume').
        ^ names includes: aString
    ]


    isValidOp: aString [
        | ops |
        ops := #('==' '!=' '>=' '<=' '>' '<').
        ^ ops includes: aString
    ]


    init:fileName
    [
        | words line fs instance count |

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
        | stringArr index count action ss|
        stringArr:= aString asArray.
        index := 1.
        count := 0.
        [index <= stringArr size]
        whileTrue:
        [
            ((stringArr at: index) isDigit)
            ifFalse:
            [
                count := count + 1.
            ]
            ifTrue:
            [
                index := index + stringArr size.
            ].
            index := index + 1.
        ].

        ss := ReadStream on: aString.
        index:= 1.
        action:= ''.
        [index <= count]
        whileTrue:
        [
            action := action, ss next asString.
            index := index + 1.
        ].
        ^action.
    ]
    
getCount: action cmd: aString "a number is a parameter representing the index of the last non-digit character"
[
    | output stringArr index |
    output := ''.
    
    (action size = aString size)
        ifTrue: [^  (output:='0') asNumber.].

    stringArr := aString asArray.
    index := action size + 1.

    [ index <= aString size ] whileTrue: [
        ((stringArr at: index) isDigit)
            ifTrue: [
                output := output , ((stringArr at: index) asString).
            ]
            ifFalse: [
                ^ output asNumber.
            ].
        index := index + 1.
    ].

    ^ output asNumber.
    ]

    getTestConditions:testCount
    [
        | count testArray testCondition|
        testArray = OrderedCollection new.

        count := 0.
        [count < testCount]
        whileTrue:
        [
            Transcript show: 'Enter test condition #', count+1, ': '.
            testCondition := FileStream stdin nextLine.
            testConditionArray := testCondition asArray.

            name := testConditionArray at: 1.
            operator := testConditionArray at: 2.
            value := testConditionArray at:3.
            (isValidName(name))
            ifFalse:
            [
                Transcript show: name , ': invalid column.'; cr.
            ]
            ifTrue:
                (isValidOp(operator))
                ifFalse:
                [
                    Transcript show: operator, ': invalid operator.'; cr.
                ]
                ifTrue:
                [
                    testArray put: 

                ]
            [

            ]
            count := count + 1.
        ]
    ]
]


actions := #('print' 'count' 'min' 'max' 'total' 'avg').



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

    (command = 'help')
    ifTrue:
    [
        s printHelp.
    ]
    ifFalse:
    [
        action := s getAction: command. "returns the action in string format"
        testCount := s getCount:action cmd:command.

        ((s isValidAction:action) and: [testCount >= 0])
        ifFalse:
        [
            Transcript show: action , ': invalid action'; cr.
            Transcript show: 'Valid actions:';cr.

            actions do: [:each |
                Transcript show: (' ' , each);cr.
            ].

            Transcript cr.
            Transcript show: 'Enter help for help'; cr.
        ]
        ifTrue:
        [
            (action = 'count')
            ifTrue:
            [
                conds := s getTestConditions(testCount).
                numOfShapes := s countShapes(arrayOfShapes, conds).
                Transcript show: 'There are ', numOfShapes, ' shapes. '; cr.
            ]
            ifFalse:
            [
                (action = 'print')
                ifTrue:
                [
                    conds := s getTestConditions(testCount)
                    numOfShapes := s countShapes(arrayOfShapes, conds)
                    (numOfShapes = 0)
                    ifTrue:
                    [
                        Transcript show: 'There are no shapes satisfying the condition(s)'; cr.
                    ]
                    ifFalse:
                    [
                        s printShapes(arrayOfShapes, conds).
                    ] 

                ]
                ifFalse:
                [
                    (action = 'min')
                    ifTrue:
                    [
                        conds := s getTestConditions(testCount).
                        numOfShapes := s countShapes(arrayOfShapes, conds).
                        (numOfShapes = 0)
                        ifTrue:
                        [
                            Transcript show: 'There are no shapes satisfying the condition(s)'; cr.
                        ]
                        ifFalse:
                        [

                        ]

                    ]
                    ifFalse:
                    [
                        (action = 'max')
                        ifTrue:
                        [

                        ]
                        ifFalse:
                        [
                            (action = 'total' or: [action = 'avg'])
                            ifTrue:
                            [

                            ]
                        ]
                    ]
                ]
            ]
        ]

    ].



]



