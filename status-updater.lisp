(in-package :auto-pipe)


(defclass status-updater ()
  ((m-controler
    :accessor get-destination
    :initarg :controler)
   (m-id
    :accessor get-id
    :initarg :id)))


(defmethod handle-state ((object status-updater) state)
  (if (some (lambda (x) (eq :saturated x))
            state)
    (pause object)
    (resume object)))


(defmethod update-reciving-from ((object status-updater))
  (when (eq (state-check object)
            :saturated)
    (pause-nodes (get-destination object)
                 (get-all-reciving-from object
                                        (get-id object)))))
