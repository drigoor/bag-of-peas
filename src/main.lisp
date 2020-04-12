


;; https://github.com/joaotavora/ax.game
;; https://borodust.org/projects/trivial-gamekit/

;; https://technomancy.us/188
;;         fennel + lua - winner of a gamejam

;; https://itch.io/jam/spring-lisp-game-jam-2020
;;         Spring Lisp Game Jam 2020

;; https://shinmera.itch.io/
;;         shimera games...


;; https://www.reddit.com/r/Common_Lisp/comments/fyomln/running_mcclim_and_other_lisp_packages_on_windows/
;;         pacman -S unzip git gpg curl base-devel mingw-w64-x86_64-toolchain mingw-w64-x86_64-xpm-nox mingw-w64-x86_64-pcre mingw-w64-x86_64-curl mingw-w64-x86_64-gnutls mingw-w64-x86_64-iconv mingw-w64-x86_64-libgcrypt mingw-w64-x86_64-glfw

;; https://www.reddit.com/r/Common_Lisp/comments/fwmp2r/list_some_beautiful_looking_graphics_applications/
;;         https://www.xach.com/moviecharts/

;; https://github.com/for-GET/know-your-http-well



(cl:in-package #:gamez)


(defvar *canvas-width* 800)
(defvar *canvas-height* 600)


(gk:defgame game-zero ()
  ()
  (:viewport-width *canvas-width*)
  (:viewport-height *canvas-height*)
  (:viewport-title "Game-Zero"))


(defvar *black* (gk:vec4 0 0 0 1))
(defvar *white* (gk:vec4 1 1 1 1))
(defvar *red* (gk:vec4 1 0 0 1))


(defvar *origin* (gk:vec2 0 0))
(defvar *x* 100)
(defvar *y* 100)

;; -- 1
(defmethod gk:draw ((game game-zero))
  (gk:draw-rect *origin* 100 100 :fill-paint *black*))


;; -- 2 
(defvar *current-box-position* (gk:vec2 0 0))


(defun real-time-seconds ()
  "Return seconds since certain point of time"
  (/ (get-internal-real-time) internal-time-units-per-second))


(defun update-position (position time)
  "Update position vector depending on the time supplied"
  (let* ((subsecond (nth-value 1 (truncate time)))
         (angle (* 2 pi subsecond)))
    (setf (gk:x position) (+ 350 (* 100 (cos angle)))
          (gk:y position) (+ 250 (* 100 (sin angle))))))


(defmethod gk:draw ((game game-zero))
  (update-position *current-box-position* (* 0.2 (real-time-seconds)))
  (gk:draw-rect *current-box-position* 100 100 :fill-paint *white* :stroke-paint *black* :thickness 3 :rounding 15))

;; -- 3
(defvar *curve* (make-array 4 :initial-contents (list (gk:vec2 300 300)
                                                      (gk:vec2 375 300)
                                                      (gk:vec2 425 300)
                                                      (gk:vec2 500 300))))

(defun update-position (position time)
  (let* ((subsecond (nth-value 1 (truncate time)))
         (angle (* 2 pi subsecond)))
    (setf (gk:y position) (+ 300 (* 100 (sin angle))))))


(defmethod gk:act ((game game-zero))
  (update-position (aref *curve* 1) (real-time-seconds))
  (update-position (aref *curve* 2) (+ 0.3 (real-time-seconds))))

(setf *origin* (gk:vec2 (- (/ *canvas-width* 2) (/ 16 2)) 8))


;; \arg{thickness} should be even"
(defun draw-world-border (width height thickness)
  (let ((thickness-by-2 (/ thickness 2)))
    (gk:draw-rect (gk:vec2 thickness-by-2 thickness-by-2) (- width thickness) (- height thickness) :fill-paint *white* :stroke-paint *black* :thickness thickness)))


(defmethod gk:draw ((game game-zero))
  (gk:draw-rect (gk:vec2 -1 -1) *canvas-width* *canvas-height* :fill-paint *red*)
  (draw-world-border *canvas-width* *canvas-height* 8)
  (gk:draw-rect *origin* 16 42 :fill-paint *white* :stroke-paint *black* :thickness 1)
  (gk:draw-curve (aref *curve* 0)
                      (aref *curve* 3)
                      (aref *curve* 1)
                      (aref *curve* 2)
                      *black*
                      :thickness 5.0)
    (gk:draw-text "A snake that is!" (gk:vec2 300 400) :fill-color *red*)

  )


(gk:bind-button :a :pressed
                (lambda ()
                  ()))


;; -- 4

(defvar *cursor-position* (gk:vec2 0 0))

(gk:bind-cursor (lambda (x y)
                       "Save cursor position"
                       (setf (gk:x *cursor-position*) x
                             (gk:y *cursor-position*) y)))

(gk:bind-button :mouse-left :pressed
                     (lambda ()
                       "Copy saved cursor position into snake's head position vector"
                       (let ((head-position (aref *curve* 3)))
                         (setf (gk:x head-position) (gk:x *cursor-position*)
                               (gk:y head-position) (gk:y *cursor-position*)))))



;; -- 5
(defvar *head-grabbed-p* nil)

(gk:bind-cursor (lambda (x y)
                  "When left mouse button is pressed, update snake's head position"
                       (when *head-grabbed-p*
                         (let ((head-position (aref *curve* 3)))
                           (setf (gk:x head-position) x
                                 (gk:y head-position) y)))))


(gk:bind-button :mouse-left :pressed
                     (lambda () (setf *head-grabbed-p* t)))

(gk:bind-button :mouse-left :released
                     (lambda () (setf *head-grabbed-p* nil)))


(defun play ()
  (gk:start 'game-zero))
