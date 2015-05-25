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
  (let (extention-alist fname suffix progName cmdStr)
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
            ("dart" . "run_dart --checked")
            ("yaml" . "pub update")
            ("cpp" . "run_cpp -f")
            ("html" . "firefox")
            )
          )
    (setq fname (buffer-file-name))
    (setq suffix (file-name-extension fname))
    (setq progName (cdr (assoc suffix extention-alist)))
    (setq cmdStr (concat "time " progName " \""   fname "\" " args))
    (setq buffname (format "*%s*" cmdStr))

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
;            (compilation-mode)
            (rename-buffer buffname t)
        (message "No recognized program file suffix for this file.")
        )))))

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

