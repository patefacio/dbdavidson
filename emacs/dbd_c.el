(cond ((fboundp 'c-initialize-cc-mode)
       (c-initialize-cc-mode))
      (t (require 'cc-mode)))

(defun dbd:c-mode-hook ()
  (turn-on-auto-fill)
  (define-key c-mode-map [(meta backspace)] nil)
  (setq c-tab-always-indent t)
  (setq c-toggle-electric-state t)
  (setq c-toggle-auto-newline t)
  (c-set-style "stroustrup")
  (column-marker-1 81)
  (c-set-offset 'substatement-open 0 t)
  (c-set-offset 'case-label 1)
  (c-set-offset 'statement-case-intro 3)
  (c-set-offset 'access-label -2)
  (c-set-offset 'inline-open 0)
  ;;
  (setq-default c-basic-offset 2)
  (setq c-basic-offset 2)
  (setq-default indent-tabs-mode nil)
  (setq tab-width 2)
  (setq indent-tabs-mode nil))

(defun dbd:c++-mode-hook () (dbd:c-mode-hook))
(add-hook 'c++-mode-hook 'dbd:c++-mode-hook)
(add-hook 'c-mode-hook 'dbd:c-mode-hook)

;; cpp macros
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun cpp:insertHardBreak() (interactive) (insert "{\nstatic bool wantHardBreak=true;\nif(wantHardBreak)\n{_asm { int 3 }\n}\n}"))
(defun cpp:main() (interactive) (insert "int main(int argc, char** argv) {\n  return 0;\n}\n"))
(defun cpp:iso646() (interactive) (insert "#include <iso646.h>\n"))
(defun cpp:iosfwd() (interactive) (insert "#include <iosfwd>\n"))
(defun cpp:quiet_nan () (interactive) (insert "std::numeric_limits<double>::quiet_NaN()"))

(defun cpp:ostreamInsertion(vname typename stream separator) 
  (interactive "sSrc var: \nsSource type: \nsStream: \nsSep [blank for no sep]: ") 
  (insert 
   (format "std::copy(%s.begin(), %s.end(), std::ostream_iterator<%s>(%s%s)); " 
           vname vname typename stream
           (if (string-match separator "")
               ""
               (format ", %s" separator)
               ))))

