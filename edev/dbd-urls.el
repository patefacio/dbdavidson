
(defun url:ebisu()
  (interactive)
  (org-open-link-from-string "https://pub.dartlang.org/packages/ebisu"))

(defun url:ebisu-cpp()
  (interactive)
  (org-open-link-from-string "https://pub.dartlang.org/packages/ebisu_cpp"))

(defun url:doc:ebisu()
  (interactive)
  (org-open-link-from-string "http://www.dartdocs.org/documentation/ebisu/0.6.0/index.html#ebisu/ebisu"))

(defun url:doc:ebisu-cpp()
  (interactive)
  (org-open-link-from-string "http://www.dartdocs.org/documentation/ebisu_cpp/0.3.1/index.html#ebisu_cpp"))

(defun url:pub()
  (interactive)
  (org-open-link-from-string "https://pub.dartlang.org/"))

(defun url:gh()
  (interactive)
  (org-open-link-from-string "https://github.com/"))

(defun url:gh:ebisu()
  (interactive)
  (org-open-link-from-string "https://github.com/patefacio/ebisu"))

(defun url:gh:ebisu-cpp()
  (interactive)
  (org-open-link-from-string "https://github.com/patefacio/ebisu_cpp"))

(defun url:gh:magus()
  (interactive)
  (org-open-link-from-string "https://github.com/patefacio/magus"))

(defun url:wsjblogs()
  (interactive)
  (org-open-link-from-string "http://blogs.wsj.com/moneybeat/"))

(message "DBD INIT - Urls available [ `url:ebisu`, `url:wsjblogs`,...]")
