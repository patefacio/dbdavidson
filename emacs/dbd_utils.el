(defun named-shell (name)
  (interactive "sEnter name: ")
  (shell (format "*sh (%s)*" name)))

(defun shell-in-dir (dir)
  (interactive "DEnter dir: ")
  (save-excursion
    (cd dir)
    (shell (format "*sh (%s)*" dir))))

 (defun work-hat ()
   "Their stuff"
   (interactive "*")
   (setq my-company "Plusauri")
   (setq my-userid "davidson")
   )

 (defun play-hat ()
   "My stuff"
   (interactive "*")
   (setq my-company "Plusauri")
   (setq my-userid "dbdavidson")
   )
 (play-hat)

(defun dbd-comment-file (&optional unknown brief)
  "Insert basic file comment with copyright"
  (interactive "P\nsbrief: ")

  (save-excursion (goto-char 0)
		  (insert 
		   (format
		    "/******************************************************************************
 *
 * Copyright (c) %s by %s
 *
 * All Rights Reserved. 
 *******************************************************************************/
/*! 
 * \\file %s
 *
 * \\brief %s  
 * 
 * Description:
 *
 * History
 *
 * date       user       comment
 * --------   --------   ------------------------------------------------------
 * %s   %s
 */
"
		    (format-time-string "%Y" (current-time))
		    my-company
		    (buffer-name)
                    brief
		    (if unknown "xxxxxxxx" (format-time-string "%D" (current-time)))
		    (if unknown "xxxxxxxx" (concat 
					    (truncate-string-to-width my-userid 11 0 32)
					    "Initial Creation."))
		    )
		   )
		  )
  )


(defun other-window-backward ()
  "Select the previous window."
  (interactive)
  (other-window -1))

(global-set-key "\C-xp" 'other-window-backward)
(global-set-key "\M-g" 'goto-line)


(defun dbd-revision ()
  (interactive)
  (beginning-of-buffer)
  (replace-regexp "\\([ ]*\\* [0-9x][0-9x][/x][0-9x][0-9x][/x][0-9x][0-9x].*\\)\\([\*\n ]*/\\)" 
		  (format "\\1\n * %s   %s\\2"     
			  (format-time-string "%D" (current-time))
			  (truncate-string-to-width my-userid 11 0 32)))
  (search-backward-regexp (concat my-userid ".*"))
  (goto-char (match-end 0))
  )

(defun list-to-string (lst)
  (let ((result ""))
    (while (< 0 (length lst))
      (setq result (concat result " " (car lst)))
      (setq lst (cdr lst))
      )
    result)
  )

;(setq indent-tabs-mode nil)

(defun dbd:codegen_all ()
  (interactive)
  (let ((bname "*codegen all*"))
  (shell-command (format "ruby %s/fcs/ruby/lib/fcs/codegen_all.rb &" dbd:home) bname)
  (display-buffer bname)))

(defun dbd:gitk-current-buffer ()
  (interactive)
  (my-shell-command (format "nohup gitk %s > /dev/null &" (buffer-file-name (current-buffer)))))

(defun dbd:giggle-current-buffer ()
  (interactive)
  (my-shell-command (format "nohup giggle %s > /dev/null &" (buffer-file-name (current-buffer)))))

(defun google-c++-ng (desideratum) (interactive "sEnter search key: ")
  (let ((search-tag 
         (concat "http://groups.google.com/group/comp.std.c++/search?group=comp.std.c%%2B%%2B&q='"
                 desideratum
                 "'&qt_g=Search+this+group")))
    (message (concat "Searching for: " search-tag))
    (org-open-link-from-string search-tag)))

(defun google-.com (desideratum) (interactive "sEnter search key: ")
  (let ((search-tag 
         (concat "http://www.google.com/search?q='"
                 desideratum
                 "'&safe&as_sitesearch=.com")))
    (message (concat "Searching for: " search-tag))
    (org-open-link-from-string search-tag)))

(defun google-.org (desideratum) (interactive "sEnter search key: ")
  (let ((search-tag 
         (concat "http://www.google.com/search?q='"
                 desideratum
                 "'&safe&as_sitesearch=.org")))
    (message (concat "Searching for: " search-tag))
    (org-open-link-from-string search-tag)))

(defun google-all (desideratum) (interactive "sEnter search key: ")
  (let ((search-tag 
         (concat "http://www.google.com/search?q='"
                 desideratum
                 "'&safe")))
    (message (concat "Searching for: " search-tag))
    (org-open-link-from-string search-tag)))

(defun py-profile (args)
  (interactive "sEnter args:")
  (let (cmdStr buffname)
    (setq cmdStr (concat "python -m cProfile -s time " (buffer-file-name) " " args))
    (setq buffname (format "*Profile(%s)*" cmdStr))
    (message (concat "Profiling:" cmdStr))
    (shell-command cmdStr buffname)))

(defun unittest-d-file (args)
  (interactive "sEnter args:")
  (setq fname (buffer-file-name))
  (setq cmdStr (concat "time unittest \""   fname "\" " args))
  (setq buffname (format "*%s*" cmdStr))
  (save-excursion
    (message (concat "Running:" cmdStr))
    (if (not (eq nil (get-buffer buffname))) (kill-buffer buffname))
    (setq compilation-scroll-output t)
    (compile cmdStr)
    (set-buffer "*compilation*")
    (rename-buffer buffname t)
    ))

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
;            ("dart" . "dart --checked")
;            ("dart" . "dart")
            ("cpp" . "runcpp.rb")
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
  
(defun dbd:plusauri-go-dev()
  (interactive)
  (my-shell-command "nohup plusauri_dev 2>&1 > /dev/null &")
  (find-file "/home/dbdavidson/plusauri/scripts/go_fmt.bash")
  (find-file "/home/dbdavidson/fcs/ruby/lib/plusauri/webapp/plus.rb")
  (find-file "/home/dbdavidson/plusauri/scripts/gen.bash")
  (find-file "/usr/share/nginx/plusauri/apps/plus")
  )

(defun dbd:plusauri-d-dev()
  (interactive)
  (find-file "/home/dbdavidson/fcs/ruby/portfolio/value_portfolio.rb")
  (find-file "/home/dbdavidson/portfolio/eoy_earnings.txt")
  (find-file "/home/dbdavidson/portfolio/dlang/dbdavidson.d")
  ; code generation for d
  (find-file "/home/dbdavidson/plusauri/dart/plus/codegen/dlang/*.dart" t)
  (find-file "/home/dbdavidson/plusauri/dlang/plus/tvm/*.d" t)
  (find-file "/home/dbdavidson/plusauri/dlang/plus/forecast/*.d" t)
  (find-file "/home/dbdavidson/plusauri/dlang/plus/tax/*.d" t)
  (find-file "/home/dbdavidson/plusauri/dlang/plus/tvm/*.d" t)
  (find-file "/home/dbdavidson/plusauri/dlang/plus/utils/*.d" t)
  ; code generation for dart
  (find-file "/home/dbdavidson/plusauri/dart/plus/codegen/dart")
  ; open source code gen base
  (find-file "/home/dbdavidson/open_source/codegen/dart/ebisu/lib/src/ebisu_compiler/*.dart" t)  
  (find-file "/home/dbdavidson/open_source/codegen/dart/ebisu/lib/src/ebisu_dart_meta/*.dart" t)  
  (find-file "/home/dbdavidson/open_source/codegen/dart/ebisu/lib/src/ebisu/*.dart" t)  
  ;;; soon to be legacy
  (find-file "/home/dbdavidson/plusauri/dlang/plusauri/statement/ies.d")
  (find-file "/home/dbdavidson/plusauri/dlang/plusauri/statement/balance_sheet.d")
  (find-file "/home/dbdavidson/plusauri/dlang/plusauri/forecast/forecaster.d")
  (find-file "/home/dbdavidson/plusauri/dlang/plusauri/forecast/iem.d")
  (find-file "/home/dbdavidson/plusauri/dlang/plusauri/tvm/cflow.d")
  (find-file "/home/dbdavidson/plusauri/ruby/lib/plusauri/dlang/pkg_forecast.rb")
  (find-file "/home/dbdavidson/plusauri/ruby/lib/plusauri/dlang/pkg_statement.rb")
  (find-file "/home/dbdavidson/plusauri/ruby/lib/plusauri/dlang/pkg_taxes.rb")
  (find-file "/home/dbdavidson/plusauri/ruby/lib/plusauri/dlang/all_pkg.rb")
  )

(defun dbd:migrate-from-nginx()
  (interactive)
  (my-shell-command "rungo.sh /home/dbdavidson/plusauri/go/src/plusauri/scripts/migrate_from_nginx.go")
  (magit-status "/home/dbdavidson/plusauri"))

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

(defun my-compilation-mode-hook ()
  (setq truncate-lines t) ;; automatically becomes buffer local
  (set (make-local-variable 'truncate-partial-width-windows) t))
(add-hook 'compilation-mode-hook 'my-compilation-mode-hook)

(defun dbd:dart() (interactive)
  (my-shell-command "nohup /home/dbdavidson/stage/dart/DartEditor 2>&1 > /dev/null &"))
