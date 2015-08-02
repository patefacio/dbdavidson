(defvar dbd:user (getenv "USER"))
(defvar dbd:home (file-name-as-directory (getenv "HOME")))

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
(load-file "dbd-commands-on-yank.el")
(load-file "dbd-c.el")
(load-file "dbd-orgmode.el")
(load-file "dbd-ibuffer.el")
(load-file "dbd-mode-line.el")
(if (file-exists-p "~/.xgrep.el") (load "~/.xgrep.el"))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; The following provides color enabled comint
(require 'ansi-color)
(defun colorize-compilation-buffer ()
  (toggle-read-only)
  (ansi-color-apply-on-region (point-min) (point-max))
  (toggle-read-only))
(add-hook 'compilation-filter-hook 'colorize-compilation-buffer)
(autoload 'ansi-color-for-comint-mode-on "ansi-color" nil t)
(add-hook 'shell-mode-hook 'ansi-color-for-comint-mode-on)
(add-hook 'comint-mode-hook 'ansi-color-for-comint-mode-on)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Look-and-feel
(global-linum-mode t)
(line-number-mode t)
(column-number-mode t)

(add-hook 'c-mode-common-hook
  (lambda()
    (add-hook 'write-contents-functions
      (lambda()
        (save-excursion
          (delete-trailing-whitespace))))))

;; (if t
;;     (progn
;;       ;; (load-theme 'wheatgrass)
;;       (load-theme 'leuven)
;;       (load-theme 'adwaita)
;;       ;; (load-theme 'tango)
;;       ))


(require 'color-theme)
(color-theme-initialize)
(color-theme-emacs-21)
(set-face-foreground 'minibuffer-prompt "black")

(defun fr:cg() (interactive)
       (let ((color-theme-is-global nil))
         (select-frame (make-frame))
         (set-frame-name "code generation")
         (color-theme-scintilla)
         (set-face-foreground 'minibuffer-prompt "black")
         ))

(defun fr:run() (interactive)
       (let ((color-theme-is-global nil))
         (select-frame (make-frame))
         (set-frame-name "run")         
         (color-theme-rotor)
         (set-face-foreground 'minibuffer-prompt "black")
         ))

;;; (toggle-debug-on-error t)

(load-file "dbd-current-projects.el")

;;; Following enables jump to written files from ebisu codeten
(add-to-list 'compilation-error-regexp-alist
             '("\\(Wrote\\|Created\\):[ ]*\\(.*\\)" 2 nil nil))
