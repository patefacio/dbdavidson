
(if t
    (progn
      (message "default-dir")
      (message default-directory)
      (message "load-path")
      (princ load-path)
      (message "setting load-path")))


(add-to-list 'load-path
             (concat (file-name-as-directory default-directory) "lang-modes"))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; dart support
(require 'dart-mode)
(autoload 'dart-mode "dart-mode" "Major mode for editing Dart code." t)
(add-to-list 'auto-mode-alist '("\\.dart\\'" . dart-mode))
