
(defvar dbd:ebisu (concat (file-name-as-directory dbd:home) "dev/open_source/ebisu/" ))
(defvar dbd:ebisu-ang (concat (file-name-as-directory dbd:home) "dev/open_source/ebisu_ang/" ))
(defvar dbd:ebisu-pod (concat (file-name-as-directory dbd:home) "dev/open_source/ebisu_pod/" ))
(defvar dbd:ebisu-cpp (concat (file-name-as-directory dbd:home) "dev/open_source/ebisu_cpp/" ))
(defvar dbd:cpp-ebisu (concat (file-name-as-directory dbd:home) "dev/open_source/cpp_ebisu/" ))
(defvar dbd:ebisu-capnp (concat (file-name-as-directory dbd:home) "dev/open_source/ebisu_capnp/" ))
(defvar dbd:plus (concat (file-name-as-directory dbd:home) "dev/open_source/plusauri/dart/plus" ))
(defvar dbd:plus-infra (concat (file-name-as-directory dbd:home) "dev/open_source/plusauri/infra" ))

(defun load-dart-project(dir)
  (interactive "DEnter path: ")
  (dired dir)
  (rename-buffer (concat "DP(" (file-name-base (directory-file-name dir)) ")"))
  (dired-maybe-insert-subdir "codegen")
  (if (file-exists-p "lib") (dired-maybe-insert-subdir "lib"))
  (if (file-exists-p "lib/src") (dired-maybe-insert-subdir "lib/src"))
  (let ((cgdir (concat (file-name-as-directory dir) "codegen")))
    (if (directory-files cgdir nil "*.dart")
        (find-file (concat (file-name-as-directory cgdir) "*.dart") t)))
  (let ((runner (concat (file-name-as-directory dir) "test/runner.dart")))
    (if (file-exists-p runner) (find-file runner))))
  

(defun load-cpp-project(dir namespace)
  (interactive "DEnter path:\nnamespace: ")
  (dired dir)
  (let ((bname (file-name-base (directory-file-name dir))))
    (rename-buffer (concat "CP(" bname ")"))
    (dired-maybe-insert-subdir "codegen")
    (dired-maybe-insert-subdir "cpp")
    (dired-maybe-insert-subdir "cpp/app")
    (dired-maybe-insert-subdir (concat "cpp/" namespace))
    (dired-maybe-insert-subdir "cpp/tests")
    ;(dired-maybe-insert-subdir "cmake_build")
    ;(dired "cmake_build/debug")
    (named-shell (concat "BLD(" (file-name-base (directory-file-name dir)) ")")))
  )

(defun dbd:cpp-ebisu-dev()
  (interactive)
  (load-cpp-project dbd:cpp-ebisu "ebisu"))

(defun dbd:ebisu-cpp-dev()
  (interactive)
  (load-dart-project dbd:ebisu-cpp))

(defun dbd:ebisu-dev()
  (interactive)
  (load-dart-project dbd:ebisu))

(defun dbd:ebisu-ang-dev()
  (interactive)
  (load-dart-project dbd:ebisu-ang))

(defun dbd:ebisu-pod-dev()
  (interactive)
  (load-dart-project dbd:ebisu-pod))

(defun dbd:plus-dev()
  (interactive)
  (load-dart-project dbd:plus))

(defun dbd:plus-cpp-dev()
  (interactive)
  (load-dart-project dbd:plus-infra))

(defun dbd:ebisu-capnp-dev()
  (interactive)
  (load-dart-project dbd:ebisu-capnp))

(find-file
 (concat
  (file-name-as-directory dbd:home)
  "dev/open_source/cpp_ebisu/cpp/ebisu/linux_specific"))

(find-file
 (concat
  (file-name-as-directory dbd:home)
  "dev/open_source/cpp_ebisu/cpp/ebisu/linux_specific/cpu_info.hpp"))

(find-file
 (concat
  (file-name-as-directory dbd:home)
  "dev/open_source/cpp_ebisu/codegen/bin/libs/linux_specific.dart"))

(find-file
 (concat
  (file-name-as-directory dbd:home)
  "dev/open_source/dbdavidson/edev/.emacs"))

(cond (nil (progn
             (dbd:ebisu-cpp-dev)
             (dbd:cpp-ebisu-dev)
             (dbd:ebisu-dev)
             (dbd:ebisu-ang-dev)
             (dbd:ebisu-pod-dev)
             (dbd:ebisu-capnp-dev)
             (dbd:plus-dev)
             (dbd:plus-cpp-dev))))

(defun dbd:webstorm() (interactive)
       (shell-command
        (concat (file-name-as-directory dbd:home)
                "install/WebStorm-141.1550/bin/webstorm.sh&")))


;; (defun fr:cg() (interactive)
;;        (let ((color-theme-is-global nil))
;;          (select-frame (make-frame))
;;          (set-frame-name "code generation")
;;          (color-theme-scintilla)
;;          (set-face-foreground 'minibuffer-prompt "black")
;;          ))

;; (defun fr:run() (interactive)
;;        (let ((color-theme-is-global nil))
;;          (select-frame (make-frame))
;;          (set-frame-name "run")         
;;          (color-theme-rotor)
;;          (set-face-foreground 'minibuffer-prompt "black")
;;          ))

;; (load-file "capnp-mode.el")
;; (add-to-list 'auto-mode-alist '("\\.capnp\\'" . capnp-mode))

;; (setq custom-re "// custom <\\(.*\\)>\\(?:.*\\|\n\\)*// end <\\1>")

;; ;;; Following enables jump to written files from ebisu codeten
;; (add-to-list 'compilation-error-regexp-alist
;;              '("\\(Wrote\\|Created\\):[ ]*\\(.*\\)" 2 nil nil))


(message "DBD Current Projects - C(PP) [ `dbd:ebisu-cpp-dev`,...]")


