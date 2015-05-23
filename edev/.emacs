(menu-bar-mode -1)
(tool-bar-mode -1)

(setq dbd:name "Daniel B. Davidson")

(defun dbd:lang-modes() (interactive)
       (load-file "dbd-lang-modes.el")
       )

(defun dbd:global-keys() (interactive)
       (load-file "dbd-global-keys.el")
       (dbd:add-global-keys))

(defun dbd:lang-keys() (interactive)
       (load-file "dbd-lang-keys.el")
       (dbd:add-lang-keys))

(defun dbd:helm() (interactive)
       (load-file "dbd-helm.el")
       (dbd:configure-helm))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(require 'package)
(add-to-list 'package-archives
             '("melpa" . "http://melpa.org/packages/") t)
(add-to-list 'package-archives '("melpa" . "http://melpa.milkbox.net/packages/"))
(package-initialize)


(dbd:helm)

(dbd:global-keys)
(dbd:lang-keys)
(dbd:lang-modes)

(load-file "dbd-utils.el")
(load-file "dbd-urls.el")

(if t
    (progn
      ;; (load-theme 'wheatgrass)
      (load-theme 'leuven)
      ;; (load-theme 'tango)
      ))

(find-file "/home/dbdavidson/dev/open_source/fcs/cpp/ebisu/linux_specific")
(find-file "/home/dbdavidson/dev/open_source/fcs/cpp/ebisu/linux_specific/cpu_info.hpp")
(find-file "/home/dbdavidson/dev/open_source/fcs/codegen/bin/libs/linux_specific.dart")
(find-file "/home/dbdavidson/dev/open_source/dbdavidson/edev/dbd-lang-modes.el")




