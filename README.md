# Bag of Peas
A game jam or nothing at all
## Installation and loading

```bat
mklink /J c:\home\quicklisp\local-projects\bag-of-peas c:\home\projects\lisp\bag-of-peas
```


`Bag of Peas` uses trivial-gamekit, the simple framework for making 2D games by Pavel Korolev.

```lisp
;; load the peas
(ql:quickload :bag-of-peas)

;; run it
(bag-of-peas:run)
```


## Screenshots

1. added shapes
![01-shape](/screenshots/01-shape.png)

2. add generation of asteroids
![02-shape-asteroids](/screenshots/02-shape-asteroids.png)
