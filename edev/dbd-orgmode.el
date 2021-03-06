(setq diary-file "~/.diary")
(setq mark-diary-entries-in-calendar t)

;; The following lines are always needed. Choose your own keys.
(add-to-list 'auto-mode-alist '("\\.\\(org\\|org_archive\\)$" . org-mode))
(global-set-key "\C-cl" 'org-store-link)
(global-set-key "\C-ca" 'org-agenda)
(global-set-key "\C-cb" 'org-iswitchb)
(add-hook 'org-mode-hook 'turn-on-font-lock)

(require 'org-capture)
(require 'remember)

(setq org-directory
      (concat (file-name-as-directory dbd:home) "/orgfiles/"))

(setq org-directory-todo (concat org-directory "todo/"))
(setq org-default-notes-file (concat org-directory "notes.org"))
(setq todo-org-capture (concat org-directory "TODO.org"))
(setq todo-plusauri (concat org-directory "/plusauri/PLUSAURI.org"))
(setq todo-ebisu-ang (concat org-directory "/plusauri/EBISU_ANG.org"))
(setq todo-ebisu-capnp (concat org-directory "/plusauri/EBISU_CAPNP.org"))
(setq todo-ebisu-postgres (concat org-directory "/plusauri/EBISU_POSTGRES.org"))
(setq todo-ebisu-py (concat org-directory "/plusauri/EBISU_PY.org"))

(setq org-todo-keywords (quote ((sequence "TODO(t)" "STARTED(s!)" "|" "DONE(d!/!)")
 (sequence "WAITING(w@/!)" "SOMEDAY(S!)" "OPEN(O@)" "|" "CANCELLED(c@/!)")
 )))

(setq org-todo-keyword-faces (quote (("TODO" :foreground "red" :weight bold)
 ("STARTED" :foreground "blue" :weight bold)
 ("DONE" :foreground "forest green" :weight bold)
 ("WAITING" :foreground "orange" :weight bold)
 ("SOMEDAY" :foreground "magenta" :weight bold)
 ("CANCELLED" :foreground "forest green" :weight bold)
 ("QUOTE" :foreground "red" :weight bold)
 ("QUOTED" :foreground "magenta" :weight bold)
 ("APPROVED" :foreground "forest green" :weight bold)
 ("EXPIRED" :foreground "forest green" :weight bold)
 ("REJECTED" :foreground "forest green" :weight bold)
 ("OPEN" :foreground "blue" :weight bold))))

(setq org-use-fast-todo-selection t)
(setq org-treat-S-cursor-todo-selection-as-state-change nil)

(setq org-tag-alist 
  (quote (
    ("javascript" . ?j)
    ("django" . ?J)
    ("dlang" . ?D)
    ("ebisu_pod" . ?p)
    ("sqlalchemy" . ?A)
    ("pyramid" . ?P)
    ("go" . ?g)
    ("@work" . ?w)
    ("@home" . ?H)
    ("@karen" . ?k)
;    ("adoption" . ?a)
    ("auction" . ?a)
    ("business_hours" . ?b)
    ("build" . ?B)
    ("codegen" . ?c)
    ("cpp" . ?C)
    ("database" . ?d)
    ("emacs" . ?E)
    ("family" . ?f)
    ("hdf5" . ?h)
    ("health" . ?m)
    ("orm" . ?o)
    ("quick" . ?q)
    ("reminder" . ?r)
    ("ruby" . ?R)
    ("store" . ?s)
    ("school" . ?S)
    ("tickler" . ?t)
    ("USEFUL_INFO" . ?U)
)))

(setq org-tag-faces
   '(
     ("@work" . (:background "white" :foreground "black" :weight "bold" :italic t))
     ("@home" . (:background "white" :foreground "navy" :weight "bold" :italic nil))
     ("@karen" . (:background "white" :foreground "navy" :weight "bold" :italic nil))
     ("adoption" . (:background "white" :foreground "navy" :weight "bold" :italic nil))
     ("business_hours" . (:background "white" :foreground "dark red" :weight "bold" :italic nil))
     ("build" . (:background "white" :foreground "DeepPink3" :weight "bold" :italic nil))
     ("codegen" . (:background "white" :foreground "DeepPink4" :weight "bold" :italic nil))
     ("cpp" . (:background "white" :foreground "OliveDrab4" :weight "bold" :italic nil))
     ("database" . (:background "white" :foreground "OliveDrab4" :weight "bold" :italic nil))
     ("emacs" . (:background "white" :foreground "DarkOliveGreen4" :weight "bold" :italic nil))
     ("family" . (:background "white" :foreground "navy" :weight "bold" :italic nil))
     ("hdf5" . (:background "white" :foreground "PaleGreen4" :weight "bold" :italic nil))
     ("health" . (:background "white" :foreground "navy" :weight "bold" :italic nil))
     ("orm" . (:background "white" :foreground "DarkOliveGreen4" :weight "bold" :italic nil))
     ("quick" . (:background "white" :foreground "honeydew4" :weight "bold" :italic nil))
     ("reminder" . (:background "white" :foreground "black" :weight "bold" :italic nil))
     ("ruby" . (:background "white" :foreground "dark red" :weight "bold" :italic nil))
     ("store" . (:background "white" :foreground "dark red" :weight "bold" :italic nil))
     ("school" . (:background "white" :foreground "dark red" :weight "bold" :italic nil))
     ("tickler" . (:background "white" :foreground "dark goldenrod" :weight "bold" :italic nil))
     ("USEFUL_INFO" . (:background "white" :foreground "black" :weight "bold" :italic nil))
     )
)

(setq org-stuck-projects 
      '("+LEVEL=2/-DONE" ("NEXT" "NEXTACTION" "BLOGS") ("DOCONLY") "NEXTACTION"))


(setq org-todo-state-tags-triggers
      (quote (("CANCELLED" ("CANCELLED" . t))
              ("WAITING" ("WAITING" . t) ("NEXT"))
              ("SOMEDAY" ("WAITING" . t))
              (done ("NEXT") ("WAITING"))
              ("TODO" ("WAITING") ("CANCELLED") ("NEXT"))
              ("DONE" ("WAITING") ("CANCELLED") ("NEXT")))))
;; Change task state to STARTED when clocking in
(setq org-clock-in-switch-to-state "STARTED")

(define-key global-map "\C-cr" 'org-capture)
(setq org-agenda-files 
      (list 
       (concat todo-plusauri)
       (concat todo-ebisu-ang)
       (concat todo-ebisu-capnp)
       (concat todo-ebisu-postgres)       
       (concat todo-ebisu-py)                     
       (concat org-directory-todo "CODEGEN.org")       
       (concat org-directory "TODO.org")
      ))
    
(string= todo-org-capture
         (concat (file-name-as-directory dbd:home) "orgfiles/TODO.org"))

(setq org-capture-templates
      '(("t" "Todo" entry (file+headline todo-org-capture "Tasks")
         "* TODO %U %?\n %i\n %a")
        ("D" "dart" entry (file+headline todo-dart "Tasks")
         "* TODO %U %?\n %i\n %a")        
        ("p" "plusauri" entry (file+headline todo-plusauri "Tasks")
         "* TODO %U %?\n %i\n %a")        
        ("a" "ebisu-ang" entry (file+headline todo-ebisu-ang "Tasks")
         "* TODO %U %?\n %i\n %a")
        ("c" "ebisu-capnp" entry (file+headline todo-ebisu-capnp "Tasks")
         "* TODO %U %?\n %i\n %a")        
        ("m" "ebisu-postgres" entry (file+headline todo-ebisu-postgres "Tasks")
         "* TODO %U %?\n %i\n %a")        
        ("P" "ebisu-py" entry (file+headline todo-ebisu-py "Tasks")
         "* TODO %U %?\n %i\n %a")        
        ))

(setq org-startup-folded t)
(find-file todo-org-capture)
(find-file todo-plusauri)
(find-file todo-ebisu-ang)
(find-file todo-ebisu-capnp)
(find-file todo-ebisu-postgres)
(find-file todo-ebisu-py)

(defun org-code-block () (interactive)
       (insert "#+BEGIN_SRC C++\n\n#+END_SRC"))

(message "DBD INIT - org-mode [ `org-code-block`,... ]")
