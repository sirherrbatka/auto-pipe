(in-package :auto-pipe)


(defclass queue ()
  ((m-buffer
    :initform (dlist:make-dlist 0))
   (m-buffer-size
    :initform 0)
   (m-buffer-maximum-size
    :initarg :buffer-maximum-size)
   (m-queue-lock
    :initform (make-lock)
    :accessor get-queue-lock)
   (m-queue-condition-var-internal
    :initform (make-condition-variable-composite)
    :accessor get-queue-condition-var-internal)
   (m-queue-condition-var-external
    :initform (make-condition-variable-composite)
    :accessor get-queue-condition-var-external)))


(defmethod send ((target queue) &rest data)
  (with-lock-held ((get-queue-lock target))
    (increase-size target)
    (dlist:dlist-push data (slot-value target 'm-buffer))
    (resume target)
    (notify-queue-internal target)
    (state-check target)))


(define-condition invalid-queue-state (error) ())


(defmethod pull-element ((target queue))
  (with-lock-held ((get-queue-lock target))
    (with-slots (m-buffer) target
      (prog2
          (reduce-size target)
          (dlist:dlist-pop m-buffer
                           :from-end t)
        (when (eq (state-check target) :functional)
          (notify-queue-external target))))))


(defmacro check-queue-state (queue operation &body body)
  `(if (,(cond ((eq operation :non-negative) '<)
               ((eq operation :non-zero)     '<=))
         (slot-value ,queue 'm-buffer-size) 0)
       (error 'invalid-queue-state)
       (progn ,@body)))


(defmethod wait-for-queue-external ((object queue))
  (simple-condition-wait (get-queue-condition-var-external object)))


(defmethod wait-for-queue-internal ((object queue))
  (simple-condition-wait (get-queue-condition-var-internal object)))


(defmethod notify-queue-external ((object queue))
  (simple-condition-notify (get-queue-condition-var-external object)))


(defmethod notify-queue-internal ((object queue))
  (simple-condition-notify (get-queue-condition-var-internal object)))


(defmethod state-check ((target queue))
  (check-queue-state target :non-negative
                     (with-slots (m-buffer-size m-buffer-maximum-size) target
                       (cond ((< m-buffer-size
                                 m-buffer-maximum-size)
                              :functional)
                             ((zerop m-buffer-size)
                              :empty)
                             ((>= m-buffer-size
                                  m-buffer-maximum-size)
                              :saturated)))))


(defun reduce-size (target)
  (declare (type queue target))
  (check-queue-state target :non-zero
    (decf (slot-value target 'm-buffer-size))))


(defun increase-size (target)
  (declare (type queue target))
  (incf (slot-value target 'm-buffer-size)))
