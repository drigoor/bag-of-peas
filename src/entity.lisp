(in-package :bag-of-peas)


(defclass entity ()
  ((xy :initarg :xy ; vec2: position of the entity in the world
       :initform nil
       :accessor xy)
   (angle :initarg :angle ; radians: orientation of the entity in the world
          :initform 0
          :accessor angle)
   (angle-speed :initarg :angle-speed ; float: how fast the orientation of the entity should change
                :initform 0.07
                :accessor angle-speed)
   (velocity :initarg :velocity       ; vec2: , where x > speed, and y > direction
             :initform nil
             :accessor velocity)
   (colour :initarg :colour
           :initform *special-black*
           :accessor colour)
   (points :initarg :points
           :initform nil
           :accessor points)))
