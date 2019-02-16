(setq dbd:name "Daniel B. Davidson")
(defvar dbd:user (getenv "USER"))
(defvar dbd:home (file-name-as-directory (getenv "HOME")))

(menu-bar-mode -1)
(tool-bar-mode -1)

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

(defun dbd:global-keys() (interactive)
       (load "dbd-global-keys.el")
       (dbd:add-global-keys))

(defun dbd:lang-keys() (interactive)
       (load "dbd-lang-keys.el")
       (dbd:add-lang-keys))

(dbd:global-keys)
(dbd:lang-keys)
(load "dbd-utils.el")
(load "dbd-urls.el")
(load "dbd-commands-on-yank.el")
(load "dbd-c.el")
(load "dbd-orgmode.el")
(load "dbd-ibuffer.el")
(load "dbd-mode-line.el")
(load "dbd-current-projects.el")
(load "dbd-humor.el")

;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ;; The following provides color enabled comint
;; (require 'ansi-color)
;; (defun colorize-compilation-buffer ()
;;   (toggle-read-only)
;;   (ansi-color-apply-on-region (point-min) (point-max))
;;   (toggle-read-only))
;; (add-hook 'compilation-filter-hook 'colorize-compilation-buffer)
;; (autoload 'ansi-color-for-comint-mode-on "ansi-color" nil t)
;; (add-hook 'shell-mode-hook 'ansi-color-for-comint-mode-on)
;; (add-hook 'comint-mode-hook 'ansi-color-for-comint-mode-on)


;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ;;; Look-and-feel
(global-linum-mode t)


;; ;; (if t
;; ;;     (progn
;; ;;       ;; (load-theme 'wheatgrass)
;; ;;       (load-theme 'leuven)
;; ;;       (load-theme 'adwaita)
;; ;;       ;; (load-theme 'tango)
;; ;;       ))


;; ;;; (toggle-debug-on-error t)

(setq create-lockfiles nil)
(setq backup-directory-alist `(("." . "~/.saves")))
(setq backup-by-copying t)
(setq next-line-add-newlines nil)
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
(setq line-number-mode t)
(global-linum-mode)

;; This is brought in by magit but don't want it
(fmakunbound 'ido-enter-magit-status)

;;; ivy is more powerful and can do everything ido dos
;;; https://www.reddit.com/r/emacs/comments/6na75b/ido_versus_ivy_questions_of_a_neophyte/
;; (add-hook 'ido-setup-hook
;;           (lambda ()
;;             (define-key ido-completion-map
;;               (kbd "C-x g") 'ido-enter-magit-status)))


;; (setq backup-directory-alist
;;       `((".*" . ,temporary-file-directory)))
;; (setq auto-save-file-name-transforms
;;       `((".*" ,temporary-file-directory t)))


;(add-hook 'emacs-lisp-mode-hook
;          (lambda () (add-to-list 'write-file-functions 'delete-trailing-whitespace)))


(mapcar
 (lambda (mode-hook)
   (progn
     (add-hook
      mode-hook
      (lambda () (add-to-list 'write-file-functions 'delete-trailing-whitespace)))
     ))
 (list 'emacs-lisp-mode-hook 'c-mode-hook))

(autoload 'enable-paredit-mode "paredit" "Turn on pseudo-structural editing of Lisp code." t)
(add-hook 'emacs-lisp-mode-hook       #'enable-paredit-mode)
(add-hook 'eval-expression-minibuffer-setup-hook #'enable-paredit-mode)
(add-hook 'ielm-mode-hook             #'enable-paredit-mode)
(add-hook 'lisp-mode-hook             #'enable-paredit-mode)
(add-hook 'lisp-interaction-mode-hook #'enable-paredit-mode)
(add-hook 'scheme-mode-hook           #'enable-paredit-mode)

(global-auto-revert-mode t)
(find-file (concat dbd:home ".emacs"))
(load-theme 'leuven)

(message "DBD Emacs init complete")
