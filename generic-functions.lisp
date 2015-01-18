(in-package :auto-pipe)

(defgeneric send (target &rest data))
(defgeneric state-check (target))
(defgeneric transmit-data (target data sender-id))
(defgeneric wait-for-queue-external (object))
(defgeneric notify-queue-internal (object))
(defgeneric wait-for-queue-internal (object))
(defgeneric notify-queue-external (object))

(defgeneric add-node (nodes node-symbol operation))
(defgeneric connect-nodes-chain (nodes &rest chain))
(defgeneric join-nodes (a b))
(defgeneric pause-nodes (object targets-list))
(defgeneric wait-for-cv (object cv targets-list))
(defgeneric get-all-reciving-from (object id))
(defgeneric send-to-node (object node-id &rest data))
(defgeneric make-nodes-wait (object condition-variable targets-list))

(defgeneric update-reciving-from (object))

(defgeneric handle-state (object state))
