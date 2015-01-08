(setq sql-sybase-options '("-w" "5000"))
(autoload 'sql-mode "sql-mode" "Interactive SQL interpreter" t)
(require 'sql)

;; emacs
;; Make mysql not buffer sending stuff to the emacs-subprocess-pipes
;; -n unbuffered -B batch(tab separated) -f force(go on after error) -i ignore spaces -q no caching -t table format 
(setq-default sql-mysql-options (quote ("-n" "-B" "-f" "-i" "-q" "-t")))
