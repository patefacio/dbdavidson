(defun select-filepath-under-cursor()
(interactive)
 (let (pt)
   (skip-chars-backward "-~./_A-Za-z0-9")
   (setq pt (point))
   (skip-chars-forward "-~./_A-Za-z0-9")
   (set-mark pt)
 ))

(defun yank-filepath-under-cursor() 
  (interactive)
  (progn
   (select-filepath-under-cursor)
   (copy-region-as-kill (region-beginning) (region-end))))

 
(defun load-filepath-under-cursor() (interactive)
  (progn
    (select-filepath-under-cursor)
    (copy-region-as-kill (region-beginning) (region-end))
    (find-file (car kill-ring))))

(defun do-command-on-yank(command) (interactive "sEnter command: ")
  (my-shell-command (format "%s %s" command (car kill-ring))))

(message "DBD INIT - Commands on yank [ `load-filepath-under-cursor`, `yank-filepath-under-cursor`,...]")
