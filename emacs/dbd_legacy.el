;; (defun dbd:debugOnlyBuild() (interactive) (insert "scons -u debug=True"))

;; (defun django-server ( )   
;;    (interactive)   
;;    (kill-matching-buffers-by-name "*django-server*")
;;    (setq cmd "python /home/dbdavidson/fcs/dj/plusauri/manage.py runserver")   
;;    (comint-simple-send (make-comint "django-server" "bash") cmd)) 

;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ;; commands to facilite work on bjam
;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; (defun txt:build_fcs_tests_static() (interactive)
;;   (insert (format "bjam -j10 %s_tests_static" root)))
  
;; (defun txt:build_fcs_test_recordset() (interactive)
;;   (insert (format "bjam -j10 %s_test_recordset" root)))

;; (defun dbd:tagit ()
;;   (interactive)
;;   (shell-command (concat "python " mydrive "/dev/python/scripts/tagit.py")))

