FileStream fileIn: 'shape.st'.

Shape subclass: Torus
[
    
    | smallRadius bigRadius |

    PI  := 3.14159265358979323846.

    Torus class >> new: aName smallRadius: aSmallRadius bigRadius: aBigRadius
    [
        | instance |
        instance := super new.
        instance init: aName smallRadius: aSmallRadius bigRadius: aBigRadius.
        ^instance
    ]

    init: aName smallRadius: aSmallRadius bigRadius: aBigRadius
    [
        super init: aName.
        smallRadius := aSmallRadius.
        bigRadius:= aBigRadius.
    ]
    " A = 4π²Rr "
    getArea
    [
        ^( ( 4 * PI * PI * bigRadius * smallRadius ) * 100) rounded/100.0
    ]
    " V=(πr2)(2πR) "
    getVolume
    [
        ^( 2 * PI * PI * smallRadius * smallRadius * bigRadius * 100.0 ) rounded / 100.0 
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

            (name = 'type') ifTrue:[val := 'torus'].
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
        ss nextPutAll: 'Torus: '.
        ss nextPutAll: self getName.
        ss nextPutAll: ', Small Radius='.
        ss nextPutAll: smallRadius asString.
        ss nextPutAll: ', Big Radius='.
        ss nextPutAll: bigRadius asString.
        ss nextPut: Character lf.
        ss nextPut: Character tab.
        ss nextPutAll: 'Surface Area: '.
        ss nextPutAll: self getArea asString.
        ss nextPutAll: ', Volume: '.
        ss nextPutAll: self getVolume asString.
        output := ss contents.
        ^output.

    ]
]



" 
s := Torus new: 'House' smallRadius: 10 bigRadius: 5.5.

tests := Dictionary new.

tests at: 'type == torus (should PASS)'              put: { #('type' '==' 'torus') . true }.
tests at: 'area > 2000 (should PASS)'                put: { #('area' '>' 2000) . true }.
tests at: 'area <= 2200 (should PASS)'               put: { #('area' '<=' 2200) . true }.
tests at: 'volume < 11000 (should PASS)'             put: { #('volume' '<' 11000) . true }.
tests at: 'volume == 10856.56 (should PASS)'          put: { #('volume' '==' 10856.56) . true }.
tests at: 'multi check (type and volume)'            put: { #('type' '==' 'torus' 'volume' '<' 11000) . true }.
tests at: 'multi check (area and volume)'            put: { #('area' '>' 2000 'volume' '<=' 11000) . true }.

tests at: 'type == sphere (should FAIL)'             put: { #('type' '==' 'sphere') . false }.
tests at: 'area < 1000 (should FAIL)'                put: { #('area' '<' 1000) . false }.
tests at: 'volume > 12000 (should FAIL)'             put: { #('volume' '>' 12000) . false }.
tests at: 'multi fail (wrong type)'                  put: { #('type' '!=' 'torus' 'volume' '<' 11000) . false }.


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
Transcript show: '====================='; cr.  "

