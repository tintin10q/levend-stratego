
build: 
    typst compile levend_stratego.typ

example:
    typst compile levend_stratego.typ --pages 1 -f png plaatjes/example.png

all: build example

watch: 
    typst watch levend_stratego.typ