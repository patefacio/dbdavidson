
(defun dbd:safeExit() (interactive) 
       (if (yes-or-no-p "Are you sure you want to exit? ")
           (save-buffers-kill-emacs)
         nil))

(defun dbd:add-global-keys() (interactive)
       (message "added global keys")
       (global-set-key "\C-x\C-c"      'dbd:safeExit)
       (save-excursion
         (describe-bindings)
         (switch-to-buffer "*Help*")
         ;(princ (buffer-string))
         )
       )
