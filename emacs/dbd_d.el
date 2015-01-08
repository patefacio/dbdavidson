(defun d:stdio() (interactive)
  (save-excursion
    (goto-char 0)
    (insert "import std.stdio;\n")))

(defun d:main() (interactive) (insert "void main() {\n\n}\n"))

(defun d:sink() (interactive) 
  (insert "import std.stdio;
import std.traits;
import std.typecons;
import std.container;
import pprint.pp;

void main() {
}
"))
