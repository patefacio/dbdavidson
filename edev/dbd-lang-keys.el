(defun dbd:add-lang-keys() (interactive)
       (eval-after-load 'lisp-mode
         '(define-key emacs-lisp-mode-map "\C-c\C-c" 'comment-region))
       (message "added lang keys")
       )

(message "DBD INIT - Language keys available `dbd:add-lang-keys`")
