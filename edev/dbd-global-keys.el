(defun dbd:safeExit()
  (interactive)
  (if (yes-or-no-p "Are you sure you want to exit? ")
      (save-buffers-kill-emacs)
    nil))

(defun other-window-backward ()
  "Select the previous window."
  (interactive)
  (other-window -1))

(defun dbd:add-global-keys()
  (interactive)

  (global-set-key "\C-x!"		'shell-command)
  (global-set-key "\C-x\C-c"            'dbd:safeExit)
  (global-set-key "\C-x\C-n"	        'next-error)
  (global-set-key "\C-x\C-p"	        'previous-error)
  (global-set-key "\C-x\C-j"	        'dired-jump)

                                        ;  (global-set-key "\C-x\C-g"	        'ibuffer-list-buffers)
  (global-set-key "\C-x\C-g"	        'ibuffer)
  (global-set-key "\C-x\C-b"	        'buffer-menu)
  (global-set-key "\C-xb"		'switch-to-buffer)

  (global-set-key "\C-c!"               'run-current-file)

  (global-set-key "\C-x\C-y"            (lambda () (interactive) (ibuffer t)))

  
  (global-set-key "\C-c@"               'run-current-file-prompt)
  (global-set-key "\C-c#"               'format-current-file)

  (global-set-key "\C-xp"               'other-window-backward)
  (global-set-key "\M-g"                'goto-line)
  (global-set-key "\M-\e"               'eval-expression)
  (global-set-key "\C-c\C-y"	        'yank-filepath-under-cursor)
  (global-set-key "\C-z"                'comint-stop-subjob)

  (global-set-key "\M-p"                'ace-window)

  (message "added global keys")
  )



(cond (t (progn
           (ivy-mode 1)
           (setq ivy-use-virtual-buffers t)
                                        ;(global-set-key "\C-s" 'swiper)
           (global-set-key (kbd "C-c C-r") 'ivy-resume)
           (global-set-key (kbd "<f6>") 'ivy-resume)
                                        ;(global-set-key (kbd "M-x") 'counsel-M-x)
           (global-set-key (kbd "C-x C-f") 'counsel-find-file)
           (global-set-key (kbd "<f1> f") 'counsel-describe-function)
           (global-set-key (kbd "<f1> v") 'counsel-describe-variable)
           (global-set-key (kbd "<f1> l") 'counsel-load-library)
;           (global-set-key (kbd "<f2> i") 'counsel-info-lookup-symbol)
;           (global-set-key (kbd "<f2> u") 'counsel-unicode-char)
           (global-set-key (kbd "C-c g") 'counsel-git)
           (global-set-key (kbd "C-c j") 'counsel-git-grep)
           (global-set-key (kbd "C-c k") 'counsel-ag)
           (global-set-key (kbd "C-x l") 'counsel-locate)
           (global-set-key (kbd "C-S-o") 'counsel-rhythmbox)
           (setq magit-completing-read-function 'ivy-completing-read)
           (setq ivy-re-builders-alist '((t . ivy--regex-ignore-order)))

           )
         ))


(eval-after-load 'emacs-lisp-mode
  '(define-key "\C-j" 'eval-last-sexp))

(message "DBD INIT - Global keys available `dbd:add-global-keys`")
