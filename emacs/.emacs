;(setq debug-on-error t)
;(setq debug-on-error nil)

(setq my-name "Daniel B. Davidson")
(setq my-address "519 W Jefferson Ave\nNaperville, Il 60540\n(630) 375-1465")

(defvar dbd:user (getenv "USER"))
(defvar dbd:home (getenv "HOME"))
(setq root (concat dbd:home "/dev/open_source/dbd-emacs"))
(defun dbd:linux-p() (or (string-match "linux" (version))))
(defun my-shell-command(cmd) (interactive) (shell-command cmd cmd))
(add-to-list 'load-path root)

;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ;; This sets up mydrive, plus various os specific commands
;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(if (dbd:linux-p) 
    (load (format "~/%s/dbd_linux_utils.el" root))
  (load (format "c:/%s/dbd_windows_utils.el" root)))
(setq myemacs root)
(defun dbd:XEmacs-p () (or (string-match "XEmacs" emacs-version) (string-match "Lucid" emacs-version)))
(defun dbd:GNUEmacs-p () (string-match "GNU Emacs" (emacs-version)))

;(require 'd-mode)
;(autoload 'd-mode "d-mode" "Major mode for editing D code." t)
;(add-to-list 'auto-mode-alist '("\\.d[i]?$" . d-mode))

(require 'dart-mode)
(autoload 'dart-mode "dart-mode" "Major mode for editing Dart code." t)
(add-to-list 'auto-mode-alist '("\\.dart\\'" . dart-mode))

(find-file (concat myemacs "/.emacs"))
;(find-file "/home/dbdavidson/plusauri/dlang/opmix/traits.d")
;(find-file "/home/dbdavidson/plusauri/dart/plus/domain_model.dart")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Not needed for emacs 24
;; ;(load (concat myemacs "/dbd_color_theme.el"))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Causing problems (maybe conflicting with dart-mode)
;(load (concat myemacs "/dbd_c.el"))

;(message (linuxToWindows "/home/dbdavidson/plusauri/dart/plus/domain_model.dart"))

(toggle-truncate-lines)
(transient-mark-mode t)
;; (setq tab-width 4)

(if (dbd:GNUEmacs-p) (tool-bar-mode -1))
(setq x-select-enable-clipboard t)

(if (or (dbd:XEmacs-p)
        (dbd:GNUEmacs-p))
    (cond ((fboundp 'global-font-lock-mode)
           ;; Turn on font-lock in all modes that support it
           (global-font-lock-mode t)
           ;; Maximum colors
           (setq font-lock-maximum-decoration t))))

(setq dirhelp_lisp_file (concat myemacs "/.dirhelp.el"))
(if (file-exists-p dirhelp_lisp_file) (load dirhelp_lisp_file))
(defun dirhelp() (interactive) (if (file-exists-p dirhelp_lisp_file) (load dirhelp_lisp_file)))
(defun dirHelper() (interactive) 
  (shell-command (concat "ruby " mydrive (format "/%s/ruby/lib/scripts/dir_helper.rb" root)))
   ;(load dirhelp_lisp_file)
  (dirhelp)
  )

(setq next-line-add-newlines nil)

(defun dbd:compilation-mode-hook () (font-lock-mode 1))
(defun dbd:compile (command)
  (interactive
   (progn (require 'compile)
 	  ;; This next form comes from compile.el
 	  (if compilation-read-command
 	      (list (read-from-minibuffer "Compile command: "
 					  compile-command nil nil
 					  '(compile-history . 1)))
	    (list compile-command))))
  (compile command))

(defun dbd:ensure-keyboard-translate-table ()
  (or keyboard-translate-table
      (cond ((fboundp 'keyboard-translate))
	    (t (setq keyboard-translate-table
		     (let ((table (make-string 256 0))
			   (index 0))
		       (while (< index 256)
			 (aset table index index)
			 (setq index (1+ index)))
		       table))))))

(defun dbd:execute-extended-command (&optional command prefix-argument)
    (interactive
     (list (read-command
	    "M-x "
	    ;; (concat (key-description (this-command-keys)) " ")
	    )
       current-prefix-arg ))
    (let (prefix-arg prefix-argument)
      (call-interactively command))
    (if (and (interactive-p) (sit-for 1))
        (let ((keys (append (where-is-internal command (current-local-map)))))
      (if keys
          (message "%s is on %s" command
               (mapconcat 'key-description keys " , "))))))

(defun dbd:find-referenced-file ()
  (interactive)
  (beginning-of-line)
  (let ((pattern "[-/_a-zA-Z0-9.]+/[-/_a-zA-Z0-9.]+"))
    (re-search-forward pattern)
    (let ((mark (point)))
      ;; (backward-sexp 2)
      (re-search-backward pattern)
      (find-file-other-window (buffer-substring mark (point))))))

(defun dbd:gdb-mode-hook ()
  (cond ((not (boundp 'gdb-mode-map)) (setq gdb-mode-map (make-keymap))))
  (define-key gdb-mode-map "\C-c\C-b" (function gdb-break))
  (define-key gdb-mode-map "\C-c\C-n" (function gdb-next))
  (define-key gdb-mode-map "\C-c\C-s" (function gdb-step)))

(defun dbd:frob-mode-alist-shell-mode (list)
  (cond (list
	 (let ((car (car list))
	       (cdr (cdr list)))
	   (cons (cond ((eq 'sh-mode (cdr car))
			(cons (car car) 'ksh-mode))
		       (t car))
		 (dbd:frob-mode-alist-shell-mode cdr))))
	(t nil)))

(defun dbd:makefile-mode-hook ()
  (define-key makefile-mode-map "\C-c\C-c"
    (function comment-region)))

(defun dbd:new-shell ()
  (interactive)
  (let ((existing-shell-buffer (get-buffer "*shell*")))
    (cond (existing-shell-buffer
	   (set-buffer existing-shell-buffer)
	   (rename-uniquely)
	   (let ((new-name (buffer-name existing-shell-buffer)))
	     (shell)
	     (let ((new-buffer (get-buffer "*shell*")))
	       (set-buffer new-buffer)
	       (rename-uniquely)
	       (let ((temporary-name (buffer-name new-buffer)))
		 (set-buffer existing-shell-buffer)
		 (rename-buffer "*shell*" nil)
		 (set-buffer new-buffer)
		 (rename-buffer new-name))
	       (switch-to-buffer new-buffer))))
	  (t (shell)))))
(fset 'new-shell 'dbd:new-shell)

(defun dbd:previous-window (n)
  (interactive "p")
  (other-window (if n (- n) nil)))

(defun dbd:regexp-case-insensitize (n)
  (interactive "p")
  (dotimes (index n)
    (insert-char ?[ 1)
    (let ((mark (point)))
      (forward-char)
      (let ((string (buffer-substring mark (point))))
	(upcase-region mark (point))
	(setq mark (point))
	(insert-string string)
	(downcase-region mark (point))
	(insert-char ?] 1)))))

(defun my-shell-setup ()
  "For Cygwin bash under Emacs 20"
  (setq comint-scroll-show-maximum-output 'this)
  (make-variable-buffer-local 'comint-completion-addsuffix))
(setq comint-completion-addsuffix t)
;; (setq comint-process-echoes t) ;; reported that this is no longer needed
(setq comint-eol-on-send t)
(setq w32-quote-process-args ?\")
(setq shell-mode-hook 'my-shell-setup)

(defun dbd:shell-mode-hook ()
  (let ((process (get-buffer-process (current-buffer))))
    (cond (process
	   (process-kill-without-query process))))
  (auto-fill-mode 0)
  (local-unset-key "\e\C-l")
  (local-set-key "\C-c\C-l" (function dbd:delete-preceding-lines)))

(defun dbd:swap-backspace-and-delete ()
  (interactive)
  (let ((table (dbd:ensure-keyboard-translate-table)))
    (cond ((fboundp 'keyboard-translate)
	   (keyboard-translate ?\^H ?\^? ?\^? ?\^H))
	  (t (let ((backspace (aref table 8))
		   (delete (aref table 127)))
	       (aset table 8 delete)
	       (aset table 127 backspace)))))
  nil)

(defun dbd:text-mode-hook ()
  (auto-fill-mode 0)
  (setq fill-column 70)
  (local-set-key [backspace] 'backward-delete-char-untabify)
  (local-set-key "" 'backward-delete-char-untabify))

(defun dbd:translate-directory-prefix (directory prefix translation)
  (let ((prefix-length (length prefix))
	(directory-length (length directory)))
    (cond ((and (>= directory-length prefix-length)
		(string= prefix (substring directory 0 prefix-length)))
	   (concat translation
		   (substring directory prefix-length directory-length)))
	  (t directory))))

(defun dbd:write-modified-buffers ()
  (interactive)
  (let ((count 0)
	(buffers (buffer-list)))
    (while buffers
      (let ((buffer (car buffers)))
	(cond ((and (buffer-modified-p buffer)
		    (buffer-file-name buffer))
	       (set-buffer buffer)
	       (save-buffer)
	       (setq count (1+ count)))))
      (setq buffers (cdr buffers)))
    (cond ((zerop count)
	   (message "No files needed to be saved."))
	  ((= count 1)
	   (message "1 file was saved."))
	  (t (message "%d files were saved." count)))))

(cond ((dbd:XEmacs-p)
       (setq auto-mode-alist (apply 'list
			     (cons "\\.C$" 'c++-mode)
			     (cons "\\.h\\'" 'c++-mode)
			     (cons "\\.KILL$" 'emacs-lisp-mode)
			     (cons "\\.\\([ckz]?sh\\|shar\\)\\'" 'ksh-mode)
			     (dbd:frob-mode-alist-shell-mode
			      auto-mode-alist)))))

(setq completion-ignored-extensions
      '("~" ".aux" ".bak" ".bbl" ".bin" ".blg" ".ckp" ".dvi" ".elc" ".fas"
	".fasl" ".glo" ".idx" ".lbin" ".lof" ".lot" ".mbin" ".o" ".sbin"
	".sparcf" ".toc" ".vbin" ".class"))
(setq default-fill-column 78)
(setq default-major-mode 'text-mode)
(setq delete-key-deletes-forward nil)
(setq display-time-day-and-date t)
(setq enable-recursive-minibuffers t)
(setq font-lock-maximum-decoration t)
(setq-default indent-tabs-mode nil)
(setq kept-new-versions 2)
(setq kept-old-versions 2)
(setq version-control t)
(setq window-min-height 1)

(add-hook 'gdb-mode-hook 'dbd:gdb-mode-hook)
(add-hook 'text-mode-hook 'dbd:text-mode-hook)
(add-hook 'compilation-mode-hook 'dbd:compilation-mode-hook)

(put 'capitalize-region 'disabled nil)
(put 'downcase-region 'disabled nil)
(put 'eval-expression 'disabled nil)
(put 'narrow-to-page 'disabled nil)
(put 'narrow-to-region 'disabled nil)
(put 'upcase-region 'disabled nil)
(put 'event-case 'common-lisp-indent-function '(4 &rest (&whole 2 4 &rest 2)))
(put 'xlib:event-case 'common-lisp-indent-function '(4 &rest (&whole 2 4 &rest 2)))

(defvar *font-lock-loaded-p* nil)
(cond ((and (not *font-lock-loaded-p*)
	    (dbd:XEmacs-p))
       (load "font-lock")
       (setq *font-lock-loaded-p* t)
       (set-face-foreground 'font-lock-keyword-face "orange3")))

(setq line-number-mode t)
(defun dbd:datestamp() (interactive) (insert (format-time-string "%m/%d/%Y" (current-time))))
(defun dbd:comment(comment) (interactive "sComment: ")
  (save-excursion (beginning-of-line)
                  (insert (format "// -- dbd -- : %s : %s\n"
                                  (format-time-string "%m/%d/%Y" (current-time))
                                  comment))))
(defun google(expression) (interactive "sEnter search expression: ") (shell-command (format "google.py %s" expression)))

;; (defun dbd:apropos(word) (interactive "sEnter word: ") (apropos word '(4)))

;; (setq auto-mode-alist (cons '("\\.py$" . python-mode) auto-mode-alist))
;; (setq interpreter-mode-alist (cons '("python" . python-mode) interpreter-mode-alist))


;; ;; - FIND gnu emacs version of replace-in-string
;; ;; (defun dbd:toggleSlash(rbegin rend) (interactive "r")
;; ;;        (let ((input (buffer-substring rbegin rend (current-buffer))))
;; ;;          (if (string-match "/" input)
;; ;;              (setq input (replace-in-string input "/" "\\"))
;; ;;              (setq input (replace-in-string input "\\\\" "/")))
;; ;;          (message input)
;; ;;          ))


(defun dbd:kill-ring-query() 
  "Display contents of kill ring in new buffer"
  (interactive)
  (switch-to-buffer (get-buffer-create "*DBD-KILL-RING*"))
  (erase-buffer)
  (progn (let ((kringlist kill-ring))
           (while kringlist
             (insert "\n####################################################\n")
             (insert (car kringlist))
             (setq kringlist (cdr kringlist)))))
  (goto-char 0)
  )

(defun dbd:mark-ring-query() 
  "Display contents of mark ring in new buffer"
  (interactive)
  (switch-to-buffer (get-buffer-create "*DBD-MARK-RING*"))
  (erase-buffer)
  (progn (let ((mringlist global-mark-ring))
           (while mringlist
             (let ((mymarker (car mringlist)))
               (insert (int-to-string (or (marker-position mymarker) 0)))
               (insert "\t")
               (insert (buffer-name (marker-buffer mymarker)))
               (insert "\n")
               )
             (setq mringlist (cdr mringlist))))
         (goto-char 0)
         )
  )

(defun dbd-find-cpp-files(directory) 
  (interactive "D") 
  (let ((result nil))
    (save-excursion
      (let ((temp-buffer  (get-buffer-create "*DBD FIND*"))
            )
        (shell-command (format "find %s  -name \\*.[ch]\\* -print" directory) temp-buffer)
        (setq result (progn (set-buffer temp-buffer) (buffer-string)))
        (kill-buffer temp-buffer)
        )
      )
    (mapconcat 'identity (split-string result) " ")
    ))

(defun gvim() (interactive) 
  (my-shell-command (format "gvim +%d %s &"  (+ (count-lines 1 (point)) 1) (buffer-file-name (current-buffer)) )))

(defun dbd:rmEditBackups() (interactive) (insert "find . -name \\*~ -print | xargs rm"))
(defun dbd:wsjblogs() (interactive) (shell-command "google-chrome http://blogs.wsj.com/marketbeat"))

(defun eshell/clear ()
  "to clear the eshell buffer."
  (interactive)
  (let ((inhibit-read-only t))
    (erase-buffer)))

;; ;; (filesets-init)


;(set-default-font "-adobe-courier-medium-r-normal--14-100-100-100-m-90-iso10646-1")
;(set-default-font "-adobe-courier-bold-r-normal--12-120-75-75-m-70-iso10646-1")
;(set-default-font "-adobe-courier-bold-r-normal--14-100-100-100-m-90-iso10646-1")

(setq gnus-select-method '(nntp "news.gmane.org"))
(setq gnus-secondary-servers '("freenews.netfront.net"))
(setq user-mail-address "dbdavidson@yahoo.com")

(global-linum-mode)

(autoload 'ansi-color-for-comint-mode-on "ansi-color" nil t)
(add-hook 'shell-mode-hook 'ansi-color-for-comint-mode-on)
(add-hook 'comint-mode-hook 'ansi-color-for-comint-mode-on)


;; ;;;; This was downloaded from web (EmacsWiki) it allows multiple shell-commands
;; ;;;; to be run by renaming the output buffer so you don't get the annoying
;; ;;;; "A command is running", "kill it?"
(defun my-shell-command (command &optional output-buffer) 
  "Same as shell-command but rename uniquely the buffers for asynch commands.Each command that is run spawns a bash shell"
  (interactive (list (read-from-minibuffer "Shell command: " nil nil nil 'shell-command-history) current-prefix-arg)
                                        ;use this list if your using shell-command.el 
                                        ;(list 
                                        ;(shell-command-read-minibuffer shell-command-prompt 
                                        ; default-directory 
                                        ; nil nil nil ‘shell-command-history) 
                                        ; current-prefix-arg) 
               )
  (if current-prefix-arg (shell-command command current-prefix-arg) 
    (if (string-match "[ \t]*&[ \t]*\\'" command) 
        (let* ((command-buffer-name 
                (format "Async Shell Command: %s" 
                        (substring command 0 (match-beginning 0)))) 
               (command-buffer (get-buffer command-buffer-name))) 
          (when command-buffer (set-buffer command-buffer)
                (rename-uniquely)) 
          (setq output-buffer command-buffer-name))) (shell-command command output-buffer)))

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


;; ; keep cursor from jumpint to bottom on command updates
(setq comint-scroll-to-bottom-on-output nil)
(setq tetris-score-file "~/.emacs.d/tetris-scores")

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

;; (defun jam-master() 
;;   (interactive)
;;   (progn
;;     (shell-command "ruby ~/fcs/ruby/lib/fcs/codegen_all.rb -e")
;;     (load (concat myemacs "/jam_master.el"))))

(defun act-on-buffers (pred action)
  (let ((count 0))
	(dolist(buffer (buffer-list))
	  (when (funcall pred buffer)
		(setq count (1+ count))
		(funcall action buffer)))
	count))
 
(defun kill-matching-buffers-by (acc arg)
  "Kill buffers whose name matches the input"
  (let* 
	  ((re arg)
	   (match (function 
			   (lambda (buf) 
				 (string-match re (funcall acc buf)))))
	   (kill #'(lambda (buf) (kill-buffer buf)))
	   (count (act-on-buffers match kill)))
 
    (message "%d buffer(s) killed" count)))

(defun kill-matching-buffers-by-name (arg)
  (interactive "sEnter buff regex: ")
  (kill-matching-buffers-by 'buffer-name arg))

(defun my-mongo ( )   
   (interactive)   
   (setq cmd "mongod --dbpath=/home/dbdavidson/data/mongo_data -vvvvv")   
   (comint-simple-send (make-comint "my-mongo" "bash") cmd)) 

(defun my-mongo-client ( )   
   (interactive)   
   (setq cmd "mongo")   
   (comint-simple-send (make-comint "mongo-client" "bash") cmd)
   ) 

(defun mongo-shutdown() (shell-command "pkill -15 mongod"))
(defun mongo() (interactive) (my-mongo) (sleep-for 0.5) (my-mongo-client) (display-buffer "*mongo-client*"))
(defun mongo-restart() (interactive) (mongo-shutdown) (sleep-for 0.5) (mongo))
(defun dbd:process_explorer() (interactive) (shell-command "gnome-system-monitor&"))
(defun dbd:pry() (interactive) (comint-simple-send (make-comint "pry" "bash") "no_pager; pry"))
(dbd:pry)

(defun check-portfolio() (interactive) 
   (shell-command "ruby ~/fcs/ruby/portfolio/reprice_portfolio.rb")
   (shell-command "ruby ~/fcs/ruby/portfolio/value_portfolio.rb")
   )

;; (eval-after-load 'sql
;;   '(progn
;;      (require 'sqlparser-mysql-complete)
;;      (defun sqlparser-setup-for-mysql()
;;        "initial some variable .some is defined in mysql.el.
;;          some is defined here."
;;        (interactive)
;;        (setq mysql-user "root")
;;        (setq mysql-password "root")
;;        (setq sqlparser-mysql-default-db-name "test")
;;        )
;;      (sqlparser-setup-for-mysql)
;;      (define-key sql-mode-map (quote [M-return]) 'anything-mysql-complete)
;;      (define-key sql-interactive-mode-map  (quote [M-return]) 'anything-mysql-complete)
;;      )
;;   )

;; ;(find-file "/home/dbdavidson/webdev/scriptin/scriptin_code_082709")

(defun xgrep-feed-view(strarg) 
"Does a grep on all files in extjs feed viewer - \nputting results in grep-mode buffer"
(interactive "sEnter txt:") 
  (grep (format "xgrep.rb -p/usr/share/nginx/plusauri/apps/feed-viewer -m%s" strarg))
  (save-excursion
    (set-buffer "*grep*")
    (rename-buffer (format "* grep:(%s) *" strarg))))

;(require 'auto-complete-config)
;; ;(ac-config-default)

(defun dbd:reset-wifi()
  (interactive)
  (shell-command "nmcli con down id DavidsonTribe&"))

(defun dbd:plusauri-model() 
(interactive) 
(shell-command "cd /tmp; nohup /usr/bin/wine /home/dbdavidson/.wine/drive_c/Program\\ Files\\ \\(x86\\)/Altova/UModel2013/UModel.exe &"))


(require 'tramp)
(setq tramp-default-method "scp")

;; (setenv "CG_LICENSE" "boost")

;; ;;;; TODO add back
;;;(dbd:plusauri-d-dev)
;; ;(require 'adoc-mode)
;; ;(python-shell)
;(load-theme 'dichromacy)
(load-theme 'tsdh-light)
(load-theme 'leuven)

(require 'package)
(add-to-list 'package-archives
             '("melpa" . "http://melpa.org/packages/") t)
(add-to-list 'package-archives '("melpa" . "http://melpa.milkbox.net/packages/"))
(package-initialize)


(require 'helm)
(require 'helm-config)

;; The default "C-x c" is quite close to "C-x C-c", which quits Emacs.
;; Changed to "C-c h". Note: We must set "C-c h" globally, because we
;; cannot change `helm-command-prefix-key' once `helm-config' is loaded.
(global-set-key (kbd "C-c h") 'helm-command-prefix)
(global-unset-key (kbd "C-x c"))

(define-key helm-map (kbd "<tab>") 'helm-execute-persistent-action) ; rebind tab to run persistent action
(define-key helm-map (kbd "C-i") 'helm-execute-persistent-action) ; make TAB works in terminal
(define-key helm-map (kbd "C-z")  'helm-select-action) ; list actions using C-z

(when (executable-find "curl")
  (setq helm-google-suggest-use-curl-p t))

(setq helm-split-window-in-side-p           t ; open helm buffer inside current window, not occupy whole other window
      helm-move-to-line-cycle-in-source     t ; move to end or beginning of source when reaching top or bottom of source.
      helm-ff-search-library-in-sexp        t ; search for library in `require' and `declare-function' sexp.
      helm-scroll-amount                    8 ; scroll 8 lines other window using M-<next>/M-<prior>
      helm-ff-file-name-history-use-recentf t)

(helm-mode 1)


(load (concat myemacs "/dbd_global_keys.el"))
(load (concat myemacs "/dbd_orgmode.el"))
(load (concat myemacs "/dbd_humor.el"))
(load (concat myemacs "/dbd_utils.el"))
(load (concat myemacs "/dbd_oscompat.el"))
(load (concat myemacs "/dbd_d.el"))
(load (concat myemacs "/column-marker.el"))
;(load (concat myemacs "/dbd_pantheios_inserts.el"))
;(load (concat myemacs "/dbd_ruby.el"))
(load (concat myemacs "/dbd_python.el"))
(load (concat myemacs "/dbd_linux_docs.el"))
(load (concat myemacs "/dbd_sql.el"))
;(load (concat myemacs "/jam_master.el"))
(load (concat myemacs "/dbd_commands_on_yank.el"))
(load (concat myemacs "/dbd_ibuffer.el"))



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
