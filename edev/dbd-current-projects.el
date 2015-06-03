
(defvar dbd:ebisu (concat (file-name-as-directory dbd:home) "dev/open_source/ebisu/" ))
(defvar dbd:ebisu-cpp (concat (file-name-as-directory dbd:home) "dev/open_source/ebisu_cpp/" ))
(defvar dbd:cpp-ebisu (concat (file-name-as-directory dbd:home) "dev/open_source/fcs/" ))

(defun load-dart-project(dir)
  (interactive "DEnter path: ")
  (dired dir)
  (rename-buffer (concat "DP(" (file-name-base (directory-file-name dir)) ")"))
  (dired-maybe-insert-subdir "codegen")
  (dired-maybe-insert-subdir "lib")
  (dired-maybe-insert-subdir "lib/src")
  (find-file (concat (file-name-as-directory dir) "test/runner.dart"))
  (find-file (concat (file-name-as-directory dir) "codegen/*.dart") t))

(defun load-cpp-project(dir)
  (interactive "DEnter path: ")
  (dired dir)
  (let ((bname (file-name-base (directory-file-name dir))))
    (rename-buffer (concat "CP(" bname ")"))
    (dired-maybe-insert-subdir "codegen")
    (dired-maybe-insert-subdir "cpp")
    (dired-maybe-insert-subdir "cpp/app")
    (dired-maybe-insert-subdir (concat "cpp" bname))
    (dired-maybe-insert-subdir "cpp/tests")
    (dired-maybe-insert-subdir "cmake_build")
    (dired "cmake_build/debug")
    (named-shell (concat "BLD(" (file-name-base (directory-file-name dir)) ")")))
  )

(defun dbd:cpp-ebisu-dev()
  (interactive)
  (load-cpp-project dbd:cpp-ebisu))

(defun dbd:ebisu-cpp-dev()
  (interactive)
  (load-dart-project dbd:ebisu-cpp))

(defun dbd:ebisu-dev()
  (interactive)
  (load-dart-project dbd:ebisu))

(find-file
 (concat
  (file-name-as-directory dbd:home)
  "dev/open_source/fcs/cpp/ebisu/linux_specific"))

(find-file
 (concat
  (file-name-as-directory dbd:home)
  "dev/open_source/fcs/cpp/ebisu/linux_specific/cpu_info.hpp"))

(find-file
 (concat
  (file-name-as-directory dbd:home)
  "dev/open_source/fcs/codegen/bin/libs/linux_specific.dart"))

(find-file
 (concat
  (file-name-as-directory dbd:home)
  "dev/open_source/dbdavidson/edev/.emacs"))

(dbd:ebisu-cpp-dev)
(dbd:cpp-ebisu-dev)

