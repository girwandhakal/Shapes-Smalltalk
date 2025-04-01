FileStream fileIn: 'shape.st'.

Shape subclass: Sphere
[
    
    | radius |

    PI  := 3.14159265358979323846.

    Sphere class >> new: aName radius: aRadius
    [
        | instance |
        instance := super new.
        instance init: aName radius: aRadius.
        ^instance
    ]

    init: aName radius:aRadius
    [
        super init: aName.
        radius := aRadius.
    ]

    getRadius
    [
        ^(radius)
    ]

    getArea
    [
        ^(4 * PI * radius * radius * 100) rounded/100.0
    ]

    getVolume
    [
        ^( (4/3) * PI * radius * radius * radius  * 100.0 ) rounded / 100.0 
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

            (name = 'type') ifTrue:[val := 'sphere'].
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
        ss nextPutAll: 'Sphere: '.
        ss nextPutAll: self getName.
        ss nextPutAll: ', Radius='.
        ss nextPutAll: self getRadius asString.
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
s := Sphere new: 'Basketball' radius: 10.
tests := Dictionary new.

tests at: 'type == sphere (should PASS)'        put: { #('type' '==' 'sphere') . true }.
tests at: 'area > 1000 (should PASS)'           put: { #('area' '>' 1000) . true }.
tests at: 'volume < 5000 (should PASS)'         put: { #('volume' '<' 5000) . true }.
tests at: 'type == cube (should FAIL)'          put: { #('type' '==' 'cube') . false }.
tests at: 'area < 1000 (should FAIL)'           put: { #('area' '<' 1000) . false }.
tests at: 'volume > 5000 (should FAIL)'         put: { #('volume' '>' 5000) . false }.
tests at: 'multi check (type/area PASS)'        put: { #('type' '==' 'sphere' 'area' '>' 1000) . true }.
tests at: 'multi fail (wrong type)'             put: { #('type' '!=' 'sphere' 'area' '>' 1000) . false }.

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
