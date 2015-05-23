
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

  (global-set-key "\C-c!"               'run-current-file)
  (global-set-key "\C-c@"               'run-current-file-prompt)
  
  
  (message "added global keys")
  )
