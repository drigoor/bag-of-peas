(in-package :bag-of-peas)


(gk:defgame game (gk.fsm:fistmachine)
  ()
  (:viewport-width 640)
  (:viewport-height 480)
  (:viewport-title "Bag of Peas")
  (:default-initargs :initial-state 'loading-screen))


(defun run ()
  (gk:start 'game))
