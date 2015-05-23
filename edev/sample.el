#!/usr/local/bin/emacs --script

(defun fmt-stdout (&rest args)
  (princ (apply 'format args)))
(defun fmtln-stdout (&rest args)
  (princ (apply 'format
                (if (and args (stringp (car args)))
                    (cons (concat (car args) "\n") (cdr args))
                  args))))

(defun test-fmt ()
  (message "Hello, %s!" "message to stderr")
  (fmt-stdout "Hello, %s!\n" "fmt-stdout, explict newline")
  (fmtln-stdout "Hello, %s!" "fmtln-stdout, implicit newline"))

(message "bam")

(ert-deftest addition-test ()
  (should (= (+ 2 2) 4)))

(ert-run-tests-batch nil)

(message nil)
(type-of (buffer-string))
(princ (buffer-string))


(save-excursion
  (describe-bindings)
  (switch-to-buffer "*Help*")
  (princ (buffer-string)))

(message "FAM")
