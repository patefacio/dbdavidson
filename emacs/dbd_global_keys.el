(global-unset-key "\C-x\C-l") ; downcase-region
(global-unset-key "\C-x\C-u") ; upcase-region

(defun dbd:safeExit() (interactive) 
  (if (yes-or-no-p "Are you sure you want to exit?")
      (save-buffers-kill-emacs)
    nil))

(global-set-key "\C-x\C-c"      'dbd:safeExit)
(global-set-key "\M-["		'dbd:regexp-case-insensitize)
(global-set-key [?\C-=] 'indent-region)
(global-set-key "\C-?"		'backward-delete-char-untabify)
(global-set-key [delete]	'backward-delete-char-untabify)
(global-set-key [backspace]	'backward-delete-char-untabify)
(global-set-key "\C-x!"		'shell-command)
(global-set-key "\C-x4\t"	'indent-to-column)
(global-set-key "\C-x4w"	'delete-region)
(global-set-key "\C-x@"		'set-mark-command)
(global-set-key "\C-x["		'dbd:backward-page)
(global-set-key "\C-x\C-e"	'dbd:compile)
;;(global-set-key "\C-x\C-l"	'load-filepath-under-cursor)
(global-set-key "\C-x\C-l"	'find-file-at-point)
(global-set-key "\C-x\C-j"	'dbd:write-modified-buffers)
(global-set-key "\C-x\C-m"	'dbd:write-modified-buffers)
(global-set-key "\C-x\C-n"	'next-error)
(global-set-key "\C-x\C-p"	'previous-error)
(global-set-key "\C-x\C-z"	'shrink-window)
(global-set-key "\C-x]"		'dbd:forward-page)
(global-set-key "\C-xb"		'switch-to-buffer)
(global-set-key "\C-x\C-b"	'ibuffer-list-buffers)
(global-set-key "\C-xn"		'other-window)
(global-set-key "\C-c!"         'run-current-file)
(global-set-key "\C-c@"         'run-current-file-prompt)
(global-set-key "\C-c#"         'unittest-d-file)
(global-set-key "\C-c\C-y"	'yank-filepath-under-cursor)

(global-set-key "\M-\C-l" 'redraw-display)
(global-set-key "\M-\C-r" 'isearch-backward-regexp)
(global-set-key "\M-\e" 'eval-expression)
(global-set-key "\e\C-r" 'isearch-backward-regexp)

(global-set-key "\M-\\" 'fixup-whitespace)
(global-set-key "\M-g" 'goto-line)

(cond ((dbd:XEmacs-p)
       (global-set-key "\M-o" 'other-screen))
      (t (global-set-key "\M-o" 'other-frame)))

(global-set-key "\M-s" 'center-line)
(global-set-key "\M-|" 'delete-horizontal-space)

;;; Tagging
(defun dbd:back-tag() (interactive) (pop-tag-mark))
(defun dbd:next-tag() (interactive) (progn (tags-loop-continue) (push-tag-mark)))
(global-set-key '[f2] 'pop-tag-mark)
(global-set-key '[f3] 'dbd:next-tag)
(global-set-key '[f4] 'dbd:back-tag)

;;; Breadcrumb
(require 'breadcrumb)
(global-set-key (kbd "<M-SPC>") 'bc-set)
(global-set-key '[f5] 'bc-local-previous)
(global-set-key '[f6] 'bc-local-next)
(global-set-key '[f7] 'bc-previous)
(global-set-key '[f8] 'bc-next)
(global-set-key '[f9] 'bc-list)

(global-set-key "\C-xp" 'mark-page)

(global-set-key "\C-cj"                       'bc-goto-current) 
(global-set-key "\C-x\M-j"                    'bc-list)           ;; C-x M-j for the bookmark menu list
(global-set-key "\C-x\C-f"                    'helm-find-files)

; (global-set-key "\C-?" 'delete-char)
