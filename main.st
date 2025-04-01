args := Smalltalk arguments.
usage := 'Usage: shape.st sphere.st cylinder.st torus.st box.st -f main.st shape_file'.

(args size = 0)
    ifTrue: [
        Transcript show: usage; cr.
        ObjectMemory quit
    ].


fileName := args first.

fs := FileStream 
    open: fileName 
    mode: #read 
    ifFail: [ 
        Transcript show: 'Unable to open ', fileName, ' for reading'; cr.
        ObjectMemory quit 
    ].

word := ''.
[ fs atEnd ] whileFalse: [
    char := fs next.
    (char = $ ) 
    ifTrue:
    [
        Transcript show: word;cr.
        word := ''.
    ]
    ifFalse:
    [
        "add to building the word"
        word := word, (char asString).
    ].
].
Transcript show: word;cr.
fs close.
