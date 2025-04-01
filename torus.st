FileStream fileIn: 'shape.st'.

Shape subclass: Torus
[
    
    | smallRadius bigRadius |

    PI  := 3.1415926535.

    Torus class >> new: aName smallRadius: aSmallRadius bigRadius: aBigRadius
    [
        | instance |
        instance := super new.
        instance init: aName smallRadius: aSmallRadius bigRadius: aBigRadius.
        ^instance
    ]

    init: aName length: aLength width: aWidth height:aHeight
    [
        super init: aName.
        smallRadius := aSmallRadius.
        bigRadius:= aBigRadius.
    ]
    "SA = 2lw + 2lh + 2wh "
    getArea
    [
        ^( ( (2*length*width) + (2*length*height) + (2*width*height) ) * 100) rounded/100.0
    ]

    getVolume
    [
        ^( length * width * height  * 100.0 ) rounded / 100.0 
    ]

    test: anArray 
    [
        | val bool name operation value index |
        
        index := 1.
        bool := true.
        [index <= (anArray size)]
        whileTrue:
        [
            name := anArray at: index.
            operation := anArray at: index + 1.
            value := anArray at: index + 2. "is the thing we are comparing to"

            (name = 'type') ifTrue:[val := 'box'].
            (name = 'area') ifTrue:[val := (self getArea asNumber). value:=value asNumber].
            (name = 'volume') ifTrue:[val := (self getVolume asNumber). value:=value asNumber].

            bool := super compare: operation left: val right: value.

            (bool) 
            ifFalse:[^bool].

            index := index + 3.
        ].
        ^ bool.
    ]

    getInfo
    [
        | output ss |
        ss := WriteStream on: ''.
        ss nextPutAll: 'Box: '.
        ss nextPutAll: self getName.
        ss nextPutAll: ', Length='.
        ss nextPutAll: length asString.
        ss nextPutAll: ', Width='.
        ss nextPutAll: width asString.
        ss nextPutAll: ', Height='.
        ss nextPutAll: height asString.
        ss nextPut: Character lf.
        ss nextPut: Character tab.
        ss nextPutAll: 'Surface Area: '.
        ss nextPutAll: self getArea asString.
        ss nextPutAll: ', Volume: '.
        ss nextPutAll: self getVolume asString.
        ss nextPut: Character lf.
        output := ss contents.
        ^output.

    ]
]



" 
s := Box new: 'House' length: 10 width: 5.5 height: 1.25.

tests := Dictionary new.

tests at: 'type == box (should PASS)'              put: { #('type' '==' 'box') . true }.
tests at: 'area > 100'                             put: { #('area' '>' 100) . true }.
tests at: 'area <= 150'                            put: { #('area' '<=' 150) . true }.
tests at: 'volume < 100'                           put: { #('volume' '<' 100) . true }.
tests at: 'volume == 68.75'                        put: { #('volume' '==' 68.75) . true }.
tests at: 'multi check (type and volume)'          put: { #('type' '==' 'box' 'volume' '<' 100) . true }.
tests at: 'multi check (area and volume)'          put: { #('area' '>' 100 'volume' '<=' 100) . true }.

tests at: 'type == sphere (should FAIL)'           put: { #('type' '==' 'sphere') . false }.
tests at: 'area < 100 (should FAIL)'               put: { #('area' '<' 100) . false }.
tests at: 'volume > 100 (should FAIL)'             put: { #('volume' '>' 100) . false }.
tests at: 'multi fail (wrong type)'                put: { #('type' '!=' 'box' 'volume' '<' 100) . false }.
pass := 0.
fail := 0.

pass := 0.
fail := 0.

tests keysDo: [:label |
    testEntry := tests at: label.
    testArray := testEntry at: 1.
    expected := testEntry at: 2.
    actual := s test: testArray.
    status := (actual = expected) ifTrue: ['✅ PASS'] ifFalse: ['❌ FAIL'].

    Transcript show: 'Test: ', label; cr.
    Transcript show: '  Expected: ', expected printString; cr.
    Transcript show: '  Actual:   ', actual printString; cr.
    Transcript show: '  Result:   ', status; cr; cr.

    (actual = expected)
        ifTrue: [ pass := pass + 1 ]
        ifFalse: [ fail := fail + 1 ].
].

Transcript show: '====================='; cr.
Transcript show: 'Total Passed: ', pass printString; cr.
Transcript show: 'Total Failed: ', fail printString; cr.
Transcript show: '====================='; cr. 
"
