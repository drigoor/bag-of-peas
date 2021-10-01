(in-package #:bag-of-peas)


(defvar *canvas-width* 640)
(defvar *canvas-height* 480)


(defvar *black* (vec4 0 0 0 1))
(defvar *white* (vec4 1 1 1 1))


(defgame game () ()
  (:viewport-width *canvas-width*)
  (:viewport-height *canvas-height*)
  (:viewport-title "Bag of Peas"))


(defmethod post-initialize ((game game))
  )


(defmethod act ((game game))
  )


(defmethod draw ((game game))
  (draw-world-border *canvas-width* *canvas-height* 4)
  (draw-text "ASTEROIDS" (vec2 (/ *canvas-width* 2) (/ *canvas-height* 2))))


(defun run ()
  (start 'game))


(defun draw-world-border (width height thickness)
  (let ((thickness-by-2 (/ thickness 2)))
    (draw-rect (vec2 thickness-by-2 thickness-by-2)
               (- width thickness)
               (- height thickness)
               :fill-paint *white*
               :stroke-paint *black*
               :thickness thickness)))


;; (defvar *origin* (vec2 (- (/ *canvas-width* 2) (/ 16 2)) 8))
