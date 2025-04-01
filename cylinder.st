FileStream fileIn: 'shape.st'.

Shape subclass: Cylinder
[
    
    | radius height |

    PI  := 3.14159265358979323846.

    Cylinder class >> new: aName height:aHeight radius: aRadius
    [
        | instance |
        instance := super new.
        instance init: aName height:aHeight radius: aRadius.
        ^instance
    ]

    init: aName height:aHeight radius: aRadius
    [
        super init: aName.
        radius := aRadius.
        height := aHeight.
    ]
    "A=2πrh+2πr2"
    getArea
    [
        ^( ( (2*PI*radius*height) + (2*PI*radius*radius) ) * 100) rounded/100.0
    ]

    getVolume
    [
        ^( PI * radius * radius * height  * 100.0 ) rounded / 100.0 
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

            (name = 'type') ifTrue:[val := 'cyl'].
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
        ss nextPutAll: 'Cylinder: '.
        ss nextPutAll: self getName.
        ss nextPutAll: ', Radius='.
        ss nextPutAll: radius asString.
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
s := Cylinder new: 'Water Tank' height: 5 radius: 4.

tests := Dictionary new.

tests at: 'type == cyl (should PASS)'        put: { #('type' '==' 'cyl') . true }.
tests at: 'area > 200'                            put: { #('area' '>' 200) . true }.
tests at: 'area <= 230'                           put: { #('area' '<=' 230) . true }.
tests at: 'volume < 300'                          put: { #('volume' '<' 300) . true }.
tests at: 'volume == 251.33'                      put: { #('volume' '==' 251.33) . true }.
tests at: 'multi check (type and volume)'         put: { #('type' '==' 'cyl' 'volume' '<' 300) . true }.
tests at: 'multi check (area and volume)'         put: { #('area' '>' 200 'volume' '<=' 300) . true }.

tests at: 'type == sphere (should FAIL)'          put: { #('type' '==' 'sphere') . false }.
tests at: 'area < 100 (should FAIL)'              put: { #('area' '<' 100) . false }.
tests at: 'volume > 500 (should FAIL)'            put: { #('volume' '>' 500) . false }.
tests at: 'multi fail (wrong type)'               put: { #('type' '!=' 'cyl' 'volume' '<' 300) . false }.

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
Transcript show: '====================='; cr. "

