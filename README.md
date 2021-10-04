# Bag of Peas
A game jam or nothing at all


## Screenshots

1. added shapes

![01-shape](/screenshots/01-shape.png)

2. added generation of asteroids

![02-shape-asteroids](/screenshots/02-shape-asteroids.png)


## Current status

- [x] shapes
- [ ] movement
- [ ] input
- [ ] state management
- [ ] collision detection
- [ ] particles
- [ ] menus & high scores
- [ ] menu option to turn on/off the antialiasing (maybe with a shortcut?)


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


## Ideas

- [ ] starfield (parallax?)
- [ ] the player's spaceship is fixed in the center and everything around it moves
- [ ] mini map like a radar to see all around (or a given distance if the world is big)
