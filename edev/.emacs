(menu-bar-mode -1)
(tool-bar-mode -1)

(setq dbd:name "Daniel B. Davidson")

(defun dbd:lang-modes() (interactive)
       (load-file "dbd-lang-modes.el")
       )

(defun dbd:global-keys() (interactive)
       (load-file "dbd-global-keys.el")
       (dbd:add-global-keys))

(dbd:global-keys)
(dbd:lang-modes)

(if t
    (progn
      ;; (load-theme 'wheatgrass)
      (load-theme 'leuven)
      ;; (load-theme 'tango)
      ))

(find-file "/home/dbdavidson/dev/open_source/fcs/cpp/ebisu/linux_specific")
(find-file "/home/dbdavidson/dev/open_source/fcs/cpp/ebisu/linux_specific/cpu_info.hpp")
(find-file "/home/dbdavidson/dev/open_source/fcs/codegen/bin/libs/linux_specific.dart")




