(defun dbd:restart-network() (interactive)
       (insert "sudo service network-manager restart"))

(defun clear-eshell ()
  "Clear the eshell buffer."
  (interactive)
  (let ((inhibit-read-only t))
    (erase-buffer)
    (message "erase eshell buffer")))

(defun magit()
  "Run magit-status on current file"
  (interactive)
  (magit-status (file-name-directory buffer-file-name)))


(defun fill-indented()
  "Set the fill column to 70 and then fill-paragraph"
  (interactive)
  (set-fill-column 70)
  (fill-paragraph))

(defun md-code()
  "Indent the region to 4 spaces"
  (interactive)  
  (indent-rigidly (region-beginning) (region-end) 4))

(defun sudo-edit (&optional arg)
  "Edit currently visited file as root.

With a prefix ARG prompt for a file to visit.
Will also prompt for a file to visit if current
buffer is not visiting a file."
  (interactive "P")
  (if (or arg (not buffer-file-name))
      (find-file (concat "/sudo:root@localhost:"
                         (ido-read-file-name "Find file(as root): ")))
    (find-alternate-file (concat "/sudo:root@localhost:" buffer-file-name))))
(put 'erase-buffer 'disabled nil)

(defun named-shell (name)
  (interactive "sEnter name: ")
  (shell (format "*sh (%s)*" name)))

(defun shell-in-dir (dir)
  (interactive "DEnter dir: ")
  (save-excursion
    (cd dir)
    (shell (format "*sh (%s)*" dir))))



(defun run-current-file-args-with (args cmd)
  (let (fname cmdStr buffname)
    (setq fname (buffer-file-name))
    (setq cmdStr (format "time %s %s %s" cmd fname args))
    (setq buffname (format "%s*" cmdStr))
    (save-excursion
      (message (concat "Running:" cmdStr))
      (if (not (eq nil (get-buffer buffname))) (kill-buffer buffname))
      (setq compilation-scroll-output t)
      (compile cmdStr)
      (toggle-truncate-lines t)
      (set-buffer "*compilation*")
      (rename-buffer buffname t)
      )))

(defun run-current-file-args (args)
  (let (extention-alist fname suffix progName cmdStr buffname resultBuff)
    (setq extention-alist ; a keyed list of file suffix to comand-line program to run
          '(
            ("php" . "php")
            ("pl" . "perl")
            ("py" . "python")
            ("rb" . "ruby")
            ("rspec" . "rspec")
            ("js" . "js")
            ("jl" . "julia")            
            ("sh" . "bash")
            ("bash" . "bash")
            ("ml" . "ocaml")
            ("vbs" . "cscript")
            ("java" . "javac")
            ("go" . "rungo.sh")
;            ("d" . "rdmd")
            ("d" . "rd")
            ("dart" . "dart.wrapper")
            ("yaml" . "pub upgrade")
            ("cpp" . "run_cpp.dart -f")
            ("html" . "firefox")
            ("psql" . "psql -f")
            ("capnp" . "capnp compile -ocapnp ")            
            )
          )
    (setq fname (buffer-file-name))
    (setq suffix (file-name-extension fname))
    (setq progName (cdr (assoc suffix extention-alist)))
    (setq cmdStr (concat "time " progName " \""   fname "\" " args))
    (setq buffname (format "R(%s) *%s*" (helm-basename fname) cmdStr))

    (if (string-equal suffix "el")
        (load-file fname)
      (if progName                    ; is not nil
          (save-excursion
            (message (concat "Running:" cmdStr))
            (if (not (eq nil (get-buffer buffname))) (kill-buffer buffname))
            (setq compilation-scroll-output t)
            (compile cmdStr)
                                        ;            (shell-command cmdStr buffname)
            ;(comint-exec buffname cmdStr)
            (toggle-truncate-lines t)
            (set-buffer "*compilation*")
            (setq resultBuff (current-buffer))
            (rename-buffer buffname t)
            )
        (message "No recognized program file suffix for this file.")
        ))
    resultBuff
    )
  )

(defun run-current-file ()
  "Execute or compile the current file.
For example, if the current buffer is the file x.pl,
then it'll call “perl x.pl” in a shell.
The file can be php, perl, python, ruby, javascript, bash, ocaml, java.
File suffix is used to determine what program to run."
  (interactive)
  (run-current-file-args ""))

(defun run-current-file-prompt (args)
  (interactive "sEnter args:")
  (run-current-file-args args))

(defun cg:run() (interactive)
       (let (compilation-buffer (color-theme-is-global nil))
         (select-frame (make-frame))
         (set-frame-name "CG")
         (toggle-frame-maximized)
         (color-theme-wheat)
         (set-face-foreground 'minibuffer-prompt "black")         
         (setq compilation-buffer (run-current-file))
         (message "CG buffer is %s" (type-of compilation-buffer))
                                        ;(switch-to-buffer compilation-buffer)
         ;(local-set-key (kbd "TAB") 'cg:written)
         ;(define-key compilation-mode-map (kbd "~") 'cg:written)
         (next-window)
         ))

(defun format-current-file ()
  (interactive)
  (let ((fname (buffer-file-name))
        (suffix (file-name-extension (buffer-file-name))))
    (if (string-equal suffix "dart")
        (progn
          (message "Formatting dart code %s" fname)
          (shell-command (concat "dart " dbd:home "bin/dart_format.dart -f " fname))
          (revert-buffer t t)
          )
      (if (string-equal suffix "cpp")
          (message "Formatting cpp code %s" fname)
        (message "Unable to format %s" fname)
    ))))

(defun dbd:gitk-current-buffer ()
  (interactive)
  (my-shell-command (format "nohup gitk %s > /dev/null &" (buffer-file-name (current-buffer)))))

(defun dbd:giggle-current-buffer ()
  (interactive)
  (my-shell-command (format "nohup giggle %s > /dev/null &" (buffer-file-name (current-buffer)))))

(defun gh-search (desideratum)
  (interactive "sEnter search key: ")
  (let ((search-url
         (concat "https://github.com/search?utf8=%E2%9C%93&q=" desideratum "&ref=simplesearch")))
    (message (concat "Searching for: " desideratum))
    (org-open-link-from-string search-url)))


(defun google.com (desideratum) (interactive "sEnter search key: ")
  (let ((search-tag 
         (concat "http://www.google.com/search?q='"
                 desideratum
                 "'&safe&as_sitesearch=.com")))
    (message (concat "Searching for: " search-tag))
    (org-open-link-from-string search-tag)))

(defun google.org (desideratum) (interactive "sEnter search key: ")
  (let ((search-tag 
         (concat "http://www.google.com/search?q='"
                 desideratum
                 "'&safe&as_sitesearch=.org")))
    (message (concat "Searching for: " search-tag))
    (org-open-link-from-string (url-encode-url search-tag))))

(princ (url-encode-url "https://www.google.com/search?q=%27c++%27&safe=&as_sitesearch=.org&gws_rd=ssl"))

(defun google (desideratum) (interactive "sEnter search key: ")
  (let ((search-tag 
         (concat "http://www.google.com/search?q='"
                 desideratum
                 "'&safe")))
    (message (concat "Searching for: " search-tag))
    (org-open-link-from-string search-tag)))

(defun my-mongo ( )   
   (interactive)   
   (setq cmd (format "mongod --dbpath=%s/data/mongo_data -vvvvv" dbd:home))
   (comint-simple-send (make-comint "my-mongo" "bash") cmd)) 

(defun my-mongo-client ( )   
   (interactive)   
   (setq cmd "mongo")   
   (comint-simple-send (make-comint "mongo-client" "bash") cmd)
   ) 

(defun mongo-shutdown()
  (shell-command "pkill -15 mongod"))

(defun mongo()
  (interactive)
  (my-mongo) (sleep-for 0.5) (my-mongo-client) (display-buffer "*mongo-client*"))

(defun mongo-restart()
  (interactive)
  (mongo-shutdown) (sleep-for 0.5) (mongo))

(defun dbd:pry()
  (interactive)
  (comint-simple-send (make-comint "pry" "bash") "no_pager; pry"))

(defun uniquify-all-lines-region (start end)
  "Find duplicate lines in region START to END keeping first occurrence."
  (interactive "*r")
  (save-excursion
    (let ((end (copy-marker end)))
      (while
          (progn
            (goto-char start)
            (re-search-forward "^\\(.*\\)\n\\(\\(.*\n\\)*\\)\\1\n" end t))
        (replace-match "\\1\n\\2")))))

(defun uniquify-all-lines-buffer ()
  "Delete duplicate lines in buffer and keep first occurrence."
  (interactive "*")
  (uniquify-all-lines-region (point-min) (point-max)))


(defun xgrep(strarg) 
"Does generic call to xgrep"
(interactive "sEnter args:") 
  (grep (format "xgrep.rb %s" strarg))
  (save-excursion
    (set-buffer "*grep*")
    (rename-buffer (format "* grep:(%s)" strarg))))

(defun ixgrep(strarg) 
"Does generic call to xgrep"
(interactive "sEnter args:") 
  (grep (format "xgrep.rb -i %s" strarg))
  (save-excursion
    (set-buffer "*grep*")
    (rename-buffer (format "* grep:-i (%s)" strarg))))

(defun dbd:rmEditBackups()
  (interactive)
  (insert "find . -name \\*~ -print | xargs rm"))

(defun gvim()
  (interactive) 
  (shell-command
   (format "gvim +%d %s &"
           (+ (count-lines 1 (point)) 1)
           (buffer-file-name (current-buffer)))))

(defun dbd:restart-network() (interactive)
       (insert "sudo service network-manager restart"))


(defun kill-all-dired-buffers()
      "Kill all dired buffers."
      (interactive)
      (save-excursion
        (let((count 0))
          (dolist(buffer (buffer-list))
            (set-buffer buffer)
            (when (equal major-mode 'dired-mode)
              (setq count (1+ count))
              (kill-buffer buffer)))
          (message "Killed %i dired buffer(s)." count ))))

(defun dbd:kill-async-buffers() (interactive)
  (kill-matching-buffers-by-name "Async Shell"))
(defun dbd:kill-unittest-buffers() (interactive)
  (kill-matching-buffers-by-name ".*time unittest .*"))
(defun dbd:kill-rd-buffers() (interactive)
  (kill-matching-buffers-by-name ".*time rd .*"))

(defun py-profile (args)
  (interactive "sEnter args:")
  (let (cmdStr buffname)
    (setq cmdStr (concat "python -m cProfile -s time " (buffer-file-name) " " args))
    (setq buffname (format "*Profile(%s)*" cmdStr))
    (message (concat "Profiling:" cmdStr))
    (shell-command cmdStr buffname)))

;;; Nice tip from http://stackoverflow.com/questions/13577286/how-to-run-gdb-many-windows-in-new-frame
(defun dbd:gdb-other-frame ()
  (interactive)
  (select-frame (make-frame))
  (call-interactively 'gdb))

(defun dbd:cppref ()
  (interactive)
  (shell-command "/usr/bin/assistant-qt4&"))
