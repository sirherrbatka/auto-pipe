(in-package :auto-pipe)

(defstruct condition-variable-composite
  "Condition variable with it's own lock"
  (lock (make-lock))
  (condition (make-condition-variable)))


(defun simple-condition-wait (cv)
  (declare (type condition-variable-composite cv))
  (with-lock-held ((condition-variable-composite-lock cv))
    (condition-wait (condition-variable-composite-condition cv)
                    (condition-variable-composite-lock cv))))


(defun simple-condition-notify (cv)
  (declare (type condition-variable-composite cv))
  (condition-notify (condition-variable-composite-condition cv)))
