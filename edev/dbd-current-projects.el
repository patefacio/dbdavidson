
(defvar dbd:ebisu (concat (file-name-as-directory dbd:home) "dev/open_source/ebisu/" ))
(defvar dbd:ebisu-cpp (concat (file-name-as-directory dbd:home) "dev/open_source/ebisu_cpp/" ))

(defun load-dart-project(dir)
  (interactive "DEnter path: ")
  (dired dir)
  (rename-buffer (concat "DP(" (file-name-base (directory-file-name dir)) ")"))
  (dired-maybe-insert-subdir "codegen")
  (dired-maybe-insert-subdir "lib")
  (dired-maybe-insert-subdir "lib/src")
  (find-file (concat (file-name-as-directory dir) "test/runner.dart"))
  (find-file (concat (file-name-as-directory dir) "codegen/*.dart") t))

(defun dbd:ebisu-cpp-dev()
  (interactive)
  (load-dart-project dbd:ebisu-cpp))

(defun dbd:ebisu-dev()
  (interactive)
  (load-dart-project dbd:ebisu))
