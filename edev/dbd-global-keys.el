
(defun dbd:safeExit()
  (interactive) 
  (if (yes-or-no-p "Are you sure you want to exit? ")
      (save-buffers-kill-emacs)
    nil))

(defun dbd:add-global-keys()
  (interactive)

  (global-set-key "\C-x!"		'shell-command)       
  (global-set-key "\C-x\C-c"            'dbd:safeExit)
  (global-set-key "\C-x\C-n"	        'next-error)
  (global-set-key "\C-x\C-p"	        'previous-error)

  (global-set-key "\C-xb"		'switch-to-buffer)       
  
  (message "added global keys")
  )
