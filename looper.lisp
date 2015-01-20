(in-package :auto-pipe)


(defclass looper ()
  ((m-running
    :initform nil)
   (m-state-lock
    :accessor get-state-lock
    :initform (make-lock))
   (m-thread
    :initform nil) ;;this field is binded during intialization
   (m-worker
    :initarg :function)))


(defmethod handle-state (state-list (handler looper))
  (declare (type list state-list))
  (when (or (endp state-list)
            (some (lambda (x) (eq x :saturated))
                  state-list))
    (pause handler)))


(defun get-worker-wrapper (worker lo)
  (lambda ()
    (do nil ((null (slot-value lo 'm-running)))
      (handler-case
          (progn
            (run-worker worker
                        lo
                        (pull-element lo))) ;;pull-element is a method implemented for the queue
        (invalid-queue-state (e)
          (wait-for-queue-internal lo))))))


(defmethod initialize-instance :around ((lo looper) &key function)
  (setf (slot-value lo 'm-worker)
        (make-worker function (lambda ()
                                (get-destination lo))))
  (call-next-method))


(defun resume (lo)
  (declare (type looper lo))
  (with-lock-held ((get-state-lock lo))
    (unless (or (eq (state-check lo) :empty)
                (slot-value lo 'm-running))
      (setf (slot-value lo 'm-running) t

            (slot-value lo 'm-thread) (make-thread (get-worker-wrapper (slot-value lo 'm-worker)
                                                                       lo))))))


(defun pause (lo)
  (declare (type looper lo))
  (with-lock-held ((get-state-lock lo))
    (setf (slot-value lo 'm-running)
          nil)))
