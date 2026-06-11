all: build example

build: 
    typst compile levend_stratego.typ

example:
    typst compile levend_stratego.typ --pages 1 -f png plaatjes/example.png

watch: 
    typst watch levend_stratego.typ