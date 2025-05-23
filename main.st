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
        | count testArray testCondition testConditionArray name operator value |
        testArray := OrderedCollection new.

        count := 0.
        [count < testCount]
        whileTrue:
        [
            Transcript show: 'Enter test condition #', (count+1) asString , ': '.
            testCondition := FileStream stdin nextLine.
            testConditionArray := testCondition substrings.

            name := testConditionArray at: 1.
            operator := testConditionArray at: 2.
            value := testConditionArray at:3.
            (self isValidName: name)
            ifFalse:
            [
                Transcript show: name , ': invalid column.'; cr.
            ]
            ifTrue:
            [
                (self isValidOp: operator)
                ifFalse:
                [
                    Transcript show: operator, ': invalid operator.'; cr.
                ]
                ifTrue:
                [
                    testArray add: name.
                    testArray add: operator.
                    testArray add: value.
                    count := count + 1.
                ].
            ].
            
        ].
        ^ testArray.
    ]

    countShapes: testConds
    [
        | count myShapes |
        count := 0.
        myShapes := self getArray.
        myShapes do:[ :i | (i test:testConds)ifTrue:[count:=count+1]].
        ^count. 
    ]

    printShapes: testConds
    [
        | myShapes output |
        output := ' '.
        myShapes := self getArray.
        myShapes do:[ :i | (i test:testConds)ifTrue:[(i getInfo) displayNl]].
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
    command := ''.
    Transcript show: 'Enter a command: '.
    command := FileStream stdin nextLine.
    (command = 'quit')
    ifFalse:
    [
        (command = 'help')
        ifTrue:
        [
            s printHelp.
        ]
        ifFalse:
        [
            action := s getAction: command. 
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

                    conds := s getTestConditions:testCount.
                    numOfShapes := s countShapes: conds.
                    Transcript show: 'There are ', (numOfShapes asString) , ' shapes. '; cr.
                ].
                (action = 'print')
                ifTrue:
                [
                    conds := s getTestConditions:testCount.
                    numOfShapes := s countShapes: conds.
                    (numOfShapes = 0)
                    ifTrue:
                    [
                        Transcript show: 'There are no shapes satisfying the condition(s)'; cr.
                    ]
                    ifFalse:
                    [
                        s printShapes:conds.
                    ] 

                ].
                (action = 'min')
                ifTrue:
                [
                    conds := s getTestConditions:testCount.
                    numOfShapes := s countShapes:conds.
                    (numOfShapes = 0)
                    ifTrue:
                    [
                        Transcript show: 'There are no shapes satisfying the condition(s)'; cr.
                    ]
                    ifFalse:
                    [
                        area_min := Float infinity.
                        vol_min := Float infinity.
                        myArray := s getArray.
                        myArray do:[ :i | (i test:conds)ifTrue:[
                            area := i getArea.
                            (area < area_min)
                            ifTrue:
                            [
                                area_min := area.
                            ].
                            volume := i getVolume.
                            (volume < volume_min)
                            ifTrue:
                            [
                                volume_min := volume.
                            ].
                        ]
                        ]

                        Transcript show: 'min(Surface Area)=', area_min ;cr.
                        Transcript show: 'min(Volume)=', volume_min; cr.
                    ]
                ].
                (action = 'max')
                ifTrue:
                [
                    conds := s getTestConditions:testCount.
                    numOfShapes := s countShapes:conds.
                    (numOfShapes = 0)
                    ifTrue:
                    [
                        Transcript show: 'There are no shapes satisfying the condition(s)'; cr.
                    ]
                    ifFalse:
                    [
                        area_max := 0.
                        volume_max := 0.
                        myArray := s getArray.
                        myArray do:[ :i | (i test:conds)ifTrue:[
                            area := i getArea.
                            (area > area_max)
                            ifTrue:
                            [
                                area_max := area.
                            ].
                            volume := i getVolume.
                            (volume > volume_max)
                            ifTrue:
                            [
                                volume_max := volume.
                            ].
                        ]
                        ]

                        Transcript show: 'max(Surface Area)=', (area_max asString) ;cr.
                        Transcript show: 'max(Volume)=', (volume_max asString); cr.
                    ]
                ].
                (action = 'avg')
                ifTrue:
                [
                    conds := s getTestConditions:testCount.
                    numOfShapes := s countShapes:conds.
                    (numOfShapes = 0)
                    ifTrue:
                    [
                        Transcript show: 'There are no shapes satisfying the condition(s)'; cr.
                    ]
                    ifFalse:
                    [
                        myArray := s getArray.
                        area_total := 0.
                        volume_total := 0.
                        myArray do:[:i | 
                            (i test:conds)
                            ifTrue:
                            [
                                area_total := area_total + (i getArea).
                                volume_total := volume_total + (i getVolume).
                            ].
                        ].
                        Transcript show: 'avg(Surface Area)=', ((area_total/numOfShapes) asString); cr.
                        Transcript show: 'avg(Volume)=', ((volume_total/numOfShapes) asString); cr.
                    ]
                    ].
                (action = 'total')
                ifTrue:
                [
                    conds := s getTestConditions:testCount.
                    numOfShapes := s countShapes:conds.
                    (numOfShapes = 0)
                    ifTrue:
                    [
                        Transcript show: 'There are no shapes satisfying the condition(s)'; cr.
                    ]
                    ifFalse:
                    [
                        myArray := s getArray.
                        area_total := 0.
                        volume_total := 0.
                        myArray do:[:i | 
                            (i test:conds)
                            ifTrue:
                            [
                                area_total := area_total + (i getArea).
                                volume_total := volume_total + (i getVolume).
                            ].
                        ].
                        Transcript show: 'total(Surface Area)=', (area_total asString); cr.
                        Transcript show: 'total(Volume)=', volume_total asString; cr.
                    ]
                ].
            ].
        ]. 
    ].
] 


