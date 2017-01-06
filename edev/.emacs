(defvar dbd:user (getenv "USER"))
(defvar dbd:home (file-name-as-directory (getenv "HOME")))

(add-to-list 'load-path (concat dbd:home "dev/open_source/dbdavidson/edev"))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; First require packages and initialize them before trying to load others
(require 'package)
(add-to-list 'package-archives
             '("melpa" . "http://melpa.org/packages/") t)
(add-to-list 'package-archives '("melpa" . "http://melpa.milkbox.net/packages/"))
(package-initialize)

;(require 'flx-ido)
(require 'swiper)
(require 'ivy)
(require 'ffap)
(ffap-bindings)

;(ido-mode 1)
;(ido-everywhere 1)
;(flx-ido-mode 1)
;; disable ido faces to see flx highlights.
;(setq ido-enable-flex-matching t)
;(setq ido-use-faces nil)

;; (add-to-list 'load-path "~/dev/open_source/helm")
;; (load "helm")
;; (defun dbd:helm() (interactive)
;;        (load-file "dbd-helm.el")
;;        (dbd:configure-helm))
;; (dbd:helm)
;; (setq helm-buffer-max-length 40)

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

(ivy-mode 1)
(setq ivy-use-virtual-buffers t)
;(global-set-key "\C-s" 'swiper)
(global-set-key (kbd "C-c C-r") 'ivy-resume)
(global-set-key (kbd "<f6>") 'ivy-resume)
;(global-set-key (kbd "M-x") 'counsel-M-x)
(global-set-key (kbd "C-x C-f") 'counsel-find-file)
(global-set-key (kbd "<f1> f") 'counsel-describe-function)
(global-set-key (kbd "<f1> v") 'counsel-describe-variable)
(global-set-key (kbd "<f1> l") 'counsel-load-library)
(global-set-key (kbd "<f2> i") 'counsel-info-lookup-symbol)
(global-set-key (kbd "<f2> u") 'counsel-unicode-char)
(global-set-key (kbd "C-c g") 'counsel-git)
(global-set-key (kbd "C-c j") 'counsel-git-grep)
(global-set-key (kbd "C-c k") 'counsel-ag)
(global-set-key (kbd "C-x l") 'counsel-locate)
(global-set-key (kbd "C-S-o") 'counsel-rhythmbox)
(setq magit-completing-read-function 'ivy-completing-read)
(setq ivy-re-builders-alist '((t . ivy--regex-ignore-order)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

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


(load-file "dbd-current-projects.el")

(require 'color-theme)
(color-theme-initialize)
;(color-theme-arjen)
					;(color-theme-emacs-21)
(color-theme-katester)
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

;;; Following enables jump to written files from ebisu codeten
(add-to-list 'compilation-error-regexp-alist
             '("\\(Wrote\\|Created\\):[ ]*\\(.*\\)" 2 nil nil))

(setq custom-re "// custom <\\(.*\\)>\\(?:.*\\|\n\\)*// end <\\1>")

(load-file "capnp-mode.el")
(add-to-list 'auto-mode-alist '("\\.capnp\\'" . capnp-mode))

(load-file "dbd-humor.el")

(setq create-lockfiles nil)
(setq backup-directory-alist
      `((".*" . ,temporary-file-directory)))
(setq auto-save-file-name-transforms
      `((".*" ,temporary-file-directory t)))
