;; Mode line setup
(setq-default
 mode-line-format
 '(; Position, including warning for 80 columns
   (:propertize "%4l:" face mode-line-position-face)
   (:eval (propertize "%3c" 'face
                      (if (>= (current-column) 80)
                          'mode-line-80col-face
                        'mode-line-position-face)))
   ; emacsclient [default -- keep?]
   mode-line-client
   "  "
   ; read-only or modified status
   (:eval
    (cond (buffer-read-only
           (propertize " RO " 'face 'mode-line-read-only-face))
          ((buffer-modified-p)
           (propertize " ** " 'face 'mode-line-modified-face))
          (t "      ")))
   "    "
   ; directory and buffer/file name
   (:propertize (:eval (shorten-directory default-directory 30))
                face mode-line-folder-face)
   (:propertize "%b"
                face mode-line-filename-face)
   ; narrow [default -- keep?]
   " %n "
   ; mode indicators: vc, recursive edit, major mode, minor modes, process, global
   (vc-mode vc-mode)
   "  %["
   (:propertize mode-name
                face mode-line-mode-face)
   "%] "
   (:eval (propertize (format-mode-line minor-mode-alist)
                      'face 'mode-line-minor-mode-face))
   (:propertize mode-line-process
                face mode-line-process-face)
   (global-mode-string global-mode-string)
   "    "
   ;; ; nyan-mode uses nyan cat as an alternative to %p
   ;; (:eval (when nyan-mode (list (nyan-create))))
   ))

;; Helper function
(defun shorten-directory (dir max-length)
  "Show up to `max-length' characters of a directory name `dir'."
  (let ((path (reverse (split-string (abbreviate-file-name dir) "/")))
        (output ""))
    (when (and path (equal "" (car path)))
      (setq path (cdr path)))
    (while (and path (< (length output) (- max-length 4)))
      (setq output (concat (car path) "/" output))
      (setq path (cdr path)))
    (when path
      (setq output (concat ".../" output)))
    output))

;; Extra mode line faces
(make-face 'mode-line-read-only-face)
(make-face 'mode-line-modified-face)
(make-face 'mode-line-folder-face)
(make-face 'mode-line-filename-face)
(make-face 'mode-line-position-face)
(make-face 'mode-line-mode-face)
(make-face 'mode-line-minor-mode-face)
(make-face 'mode-line-process-face)
(make-face 'mode-line-80col-face)

(set-face-attribute 'mode-line nil
    :foreground "gray60" :background "gray20"
    :inverse-video nil
    :box '(:line-width 2 :color "blue" ;"gray20"
                       :style nil))

(set-face-attribute 'mode-line-inactive nil
    :foreground "gray80" :background "gray40"
    :inverse-video nil
    :box '(:line-width 6 :color "gray40" :style nil))

(set-face-attribute 'mode-line-read-only-face nil
    :inherit 'mode-line-face
    :foreground "#4271ae"
    :box '(:line-width 2 :color "#4271ae"))

(set-face-attribute 'mode-line-modified-face nil
    :inherit 'mode-line-face
    :foreground "#c82829"
    :background "#ffffff"
    :box '(:line-width 2 :color "#c82829"))

;; (set-face-attribute 'mode-line-folder-face nil
;;     :inherit 'mode-line-face
;;     :foreground "gray60")

(set-face-attribute 'mode-line-filename-face nil
    :inherit 'mode-line-face
    :foreground "#eab700"
    :weight 'bold)

(set-face-attribute 'mode-line-position-face nil
    :inherit 'mode-line-face
    :family "Menlo" :height 100)

;; (set-face-attribute 'mode-line-mode-face nil
;;     :inherit 'mode-line-face
;;     :foreground "gray80")
;; (set-face-attribute 'mode-line-minor-mode-face nil
;;     :inherit 'mode-line-mode-face
;;     :foreground "gray40"
;;     :height 110)

(set-face-attribute 'mode-line-process-face nil
    :inherit 'mode-line-face
    :foreground "#718c00")

;; (set-face-attribute 'mode-line-80col-face nil
;;     :inherit 'mode-line-position-face
;;     :foreground "black" :background "#eab700")


;; ;; use setq-default to set it for /all/ modes
;; (setq-default mode-line-format
;;       (list
;;        ;; the buffer name; the file name as a tool tip
;;        '(:eval (propertize "%b " 'face 'font-lock-keyword-face
;;                            'help-echo (buffer-file-name)))

;;        ;; line and column
;;        "(" ;; '%02' to set to 2 chars at least; prevents flickering
;;        (propertize "%02l" 'face 'font-lock-type-face) ","
;;        (propertize "%02c" 'face 'font-lock-type-face) 
;;        ") "

;;        ;; relative position, size of file
;;        "["
;;        (propertize "%p" 'face 'font-lock-constant-face) ;; % above top
;;        "/"
;;        (propertize "%I" 'face 'font-lock-constant-face) ;; size
;;        "] "

;;        ;; the current major mode for the buffer.
;;        "["

;;        '(:eval (propertize "%m" 'face 'font-lock-string-face
;;                            'help-echo buffer-file-coding-system))
;;        "] "


;;        "[" ;; insert vs overwrite mode, input-method in a tooltip
;;        '(:eval (propertize (if overwrite-mode "Ovr" "Ins")
;;                            'face 'font-lock-preprocessor-face
;;                            'help-echo (concat "Buffer is in "
;;                                               (if overwrite-mode "overwrite" "insert") " mode")))

;;        ;; was this buffer modified since the last save?
;;        '(:eval (when (buffer-modified-p)
;;                  (concat ","  (propertize "Mod"
;;                                           'face 'font-lock-warning-face
;;                                           'help-echo "Buffer has been modified"))))

;;        ;; is this buffer read-only?
;;        '(:eval (when buffer-read-only
;;                  (concat ","  (propertize "RO"
;;                                           'face 'font-lock-type-face
;;                                           'help-echo "Buffer is read-only"))))  
;;        "] "

;;        ;; add the time, with the date and the emacs uptime in the tooltip
;;        '(:eval (propertize (format-time-string "%H:%M")
;;                            'help-echo
;;                            (concat (format-time-string "%c; ")
;;                                    (emacs-uptime "Uptime:%hh"))))
;;        " --"
;;        ;; i don't want to see minor-modes; but if you want, uncomment this:
;;        ;; minor-mode-alist  ;; list of minor modes
;;        "%-" ;; fill with '-'
;;        ))

(message "DBD INIT - Mode line set")
