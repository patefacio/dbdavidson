(require 'python)

;;; -*- Mode: Emacs-Lisp -*-
;;;

(defvar *pyhelper.el-RCS-Id*
  "$Id$")
(random t)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Python basic stuff
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun dbd:log(txt)
  (save-excursion 
    (set-buffer (get-buffer-create "dbd:log"))
    (insert txt)))
(setq my-name "Daniel B. Davidson")
 (setq my-address "1354 Braymore Circle\nNaperville, Il 60564\n(630) 375-1465")

(defun py:add-revision ()
  (interactive)
  (save-excursion
    (beginning-of-buffer)
    (let ((last-revision-re "\\(# [0-9x][0-9x][/x][0-9x][0-9x][/x][0-9x][0-9x].*\\)\\([#\n ]*\\)"))
      (dbd:log (buffer-substring (point) (+ (point) 10)))
      (search-forward-regexp "#\n####")
      (dbd:log (buffer-substring (point) (+ (point) 10)))
      (search-backward-regexp last-revision-re)
      (replace-regexp last-revision-re
                      (format "\\1\n# %s   %s\\2"     
                              (format-time-string "%D" (current-time))
                              (truncate-string-to-width my-userid 11 0 32)))
      (search-backward-regexp (concat my-userid ".*"))
      )
    )
  (goto-char (match-end 0))
  )

(defun py:comment-file (description)
  "Insert basic file comment with copyright"
  (interactive "sDescription (no new-lines): ")
  (save-excursion (goto-char 0)
		  (insert 
		   (format
		    "###############################################################################
#
# File: %s
#
# Copyright (c) %s by %s
#
# All Rights Reserved. 
#
# Quote: %s
#
# Description: %s
#
# History:
#
# date       user       comment
# --------   --------   ------------------------------------------------------
# %s   %s
#
##############################################################################
"
		    (buffer-name)
		    (format-time-string "%Y" (current-time))
		    my-company
                    (nth (random (length dbd:proverbs)) dbd:proverbs)
                    description
		    (format-time-string "%D" (current-time))
		    (concat (truncate-string-to-width my-userid 11 0 32)
                            "Initial Creation.")
		    )
		   )
                  (progn
                    (search-backward "Quote:")
                    (setq fill-prefix "# ")
                    (fill-paragraph-or-region nil)
                    (search-forward "Description:")
                    (fill-paragraph-or-region nil)
                    )
                  )
)

(defconst py-class-start-re "\\bclass[ \t]+\\([a-zA-Z_]+[a-zA-Z0-9_]*\\)" "Re matching start of class")
(defun py:props-section() (interactive)
       (py:section "__properties__"))
(defun py:staticmethod-section() (interactive)
       (py:section "__staticmethods__"))
(defun py:classmethod-section() (interactive)
       (py:section "__classmethods__"))
(defun py:classattributes-section() (interactive)
       (py:section "__classattributes__"))

(defun py:section(name) (interactive "sEnter section name: ")
       (save-excursion
         (let ((begin (progn (python-beginning-of-block) (point)))
               (end (progn (python-end-of-block) (point)))
               (above-init (progn (re-search-backward "def[ ]+__init__") (previous-line 1) (point)))
               )
           (message "%d %d" begin end)
           (re-search-backward py-class-start-re begin) 
           (let ((class (buffer-substring (match-beginning 1) (match-end 1))))
             (if
              (re-search-forward 
               (let 
                   ((qry (format "# begin %s" name))) 
                 (dbd:log (format "query %s limit %d\n" qry end))
                 qry)  
               end t)
              nil
              (progn
                (goto-char above-init)
                (insert "\n")
                (insert (format "# begin %s for %s " name class))
                (search-backward "#")
                (indent-for-tab-command)
                (end-of-line)
                (insert "\n")
                (insert (format "# end %s for %s " name class))
                (indent-for-tab-command)
                (insert "\n")
                (search-backward "# begin")
               )
              )
             (point)
             )
           )
         )
       )
       
(defun py:classattribute(name initial) (interactive "\sName of attribute: \n\sInitial value: ")
       (save-excursion
         (re-search-backward py-class-start-re) 
         (let ((class (buffer-substring (match-beginning 1) (match-end 1))))
           (python-beginning-of-block)
           (goto-char (py:classattributes-section))
           (search-forward "# end")
           (previous-line 1)
           (end-of-line)
           (insert (format "\n\t%s.%s = %s" class name initial)))))


(defun py:classmethod(method signature docstring)
  (interactive "sEnter class method name: \n\sEnter non-class args: \n\sEnter docstring: ")
  (save-excursion
    (python-beginning-of-block)
    (goto-char (py:classmethod-section))
    (re-search-forward "# end __classmethods__") 
    (previous-line 1)
    (insert (format "\ndef %s(cls, %s):" method signature))
    (indent-for-tab-command)
    (insert "\n\"\"\"")
    (indent-for-tab-command)
    (insert (format "%s" docstring))
    (indent-for-tab-command)
    (insert "\"\"\"")
    (insert "\npass # TODO:")
    (indent-for-tab-command)
    (insert (format "\n%s = classmethod(%s)" method method))
    (indent-for-tab-command)
    (insert "\n")
    ))

(defun py:staticmethod(method signature docstring)
  (interactive "sEnter static method name: \n\sEnter args: \n\sEnter docstring: ")
  (save-excursion
    (python-beginning-of-block)
    (goto-char (py:staticmethod-section))
    (re-search-forward "# end __staticmethods__") 
    (previous-line 1)
    (insert (format "\ndef %s(%s):" method signature))
    (indent-for-tab-command)
    (insert "\n\"\"\"")
    (indent-for-tab-command)
    (insert (format "%s" docstring))
    (indent-for-tab-command)
    (insert "\"\"\"")
    (insert "\npass # TODO:")
    (indent-for-tab-command)
    (insert (format "\n%s = staticmethod(%s)" method method))
    (indent-for-tab-command)
    (insert "\n")
    ))

(defun py:add-prop(field readonly default comment add-to-init) 
  (save-excursion 
    (python-beginning-of-block)
    (re-search-forward "def *__init__") 
    (if 
     add-to-init
     (save-excursion
       (progn
         (setq assigned default)
         (re-search-forward ")[ \t]*:")
         (search-backward ")")
         (insert (format ",\n%s = %s" field default))
         (beginning-of-line)
         (indent-for-tab-command)
         ))
     )        
    (re-search-forward "\"\"\"" nil nil 2)
    (previous-line 1)
    (if
     add-to-init
     (insert (format "\t%s -- assigns property %s - defaulted to %s\n" field field default))
     )
    (re-search-forward "\"\"\"" nil nil 1)
    (next-line 1)
    (beginning-of-line)
    (insert (format "self.__%s = %s\n" field (if add-to-init field default)))
    (previous-line 1)
    (beginning-of-line)
    (indent-for-tab-command)
    )

  (save-excursion
    (re-search-backward "# begin __properties__")
    (re-search-forward "# end __properties__")
    (previous-line 1)
    (end-of-line)
    (if readonly
        (progn 
          (insert (format "\n%s = property(lambda self: self.__%s, None, None, r\"\"\"" field field))
          (indent-for-tab-command)
          (insert "\n" comment)
          (insert "\"\"\")")
          (indent-for-tab-command)
          )
        (progn 
          (insert (format "\ndef __set_%s(self, %s): self.__%s = %s" field field field field))
          (indent-for-tab-command)
          (insert (format "\n%s = property(lambda self: self.__%s, __set_%s, None, r\"\"\"" field field field))
          (indent-for-tab-command)
          (insert "\n" comment)
          (insert "\"\"\")")
          (indent-for-tab-command)
          )
        )
    (insert "\n")
    )
  )


(defun py:prop(prop comment default is-read-only add-to-init) 
  (interactive "sEnter prop name: \nsComment: \nsDefault (None): \nsRead only (y|n): \nsAdd to init (y|n): ") 
  (setq default (if (equal default "") "None" default))
;  (message "isequal" (equal 'y' is-read-only) (equal 'y' add-to-init))
  (py:add-prop prop (if (equal "y" is-read-only) t nil) default comment (if (equal "y" add-to-init) t nil)))

;  (py:add-prop prop (yes-or-no-p (format "Is %s read only:" prop))
;               default comment (yes-or-no-p (format "Add %s to __init__:" prop))))

(defun py:class(name docstring) (interactive "sEnter class name: \nsEnter docstring contents: ") 
       (insert (format "class %s(object):" name))
       (insert "\n")
       (insert "r\"\"\"")
       (indent-for-tab-command)
       (insert (format "\n%s\n\"\"\"" docstring))
       (indent-for-tab-command)
       (insert "\n\n")
       (indent-for-tab-command)
       (insert "def __init__(self):")
       (indent-for-tab-command)
       (insert "\n")
       (indent-for-tab-command)
       (insert "\"\"\"\n\n\"\"\"")
       (indent-for-tab-command)
       (insert "\n\n")
       (indent-for-tab-command)
       (py:props-section)
       (py:staticmethod-section)
       (py:classmethod-section)
       )

(defun py:main() (interactive)  
       (end-of-buffer)
       (insert "\nif __name__ == \"__main__\":\n")
       (indent-for-tab-command)
       )

(defun py:clsPropTest() (interactive)
       (py:class "PropTest" "Test\nout\nproperty\nlisp\nfunctions")
       (py:prop "roNoInitProp" "this is the read-only no-init prop - make it so" "42" "y" "n")
       (py:prop "roInitProp" "this is the read-only init prop - make it so" "-42" "y" "y")
       (py:prop "rwNoInitProp" "this is the read-write no-init prop - make it so" "(1,2,3)" "n" "n")
       (py:prop "rwInitProp" "this is the read-write init prop - make it so" "'voracious'" "n" "y")
       (py:main)
       (insert "p=PropTest('ro_init1', 'rw_init2')

    print p.roNoInitProp,p.roInitProp,p.rwNoInitProp,p.rwInitProp
    p.rwNoInitProp = 'new rwNoInitProp'; p.rwInitProp = 'new rwInitProp'
    print p.roNoInitProp,p.roInitProp,p.rwNoInitProp,p.rwInitProp    
")
)

(defun nosetest() (interactive)
  (message "Running nosetest...")
  (my-shell-command (concat "nosetests " (buffer-file-name (current-buffer)))))