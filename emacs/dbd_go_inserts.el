;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; go
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun go:main() (interactive) 
       (insert "func main() {\n\n}"))
(defun go:memusage() (interactive) 
       (insert "{ var m runtime.MemStats; runtime.ReadMemStats(&m); fmt.Printf(\"%#v\\n\", m) }"))
(defun go:numcpu() (interactive) 
       (insert "fmt.Printf(cpu count:\"%d\\n\", runtime.NumCPU())"))
(defun go:setFinalizer() (interactive) 
       (insert "runtime.SetFinalizer(o, func (o *T) { fmt.Printf(\"Finalizing:%v\\n\", o})"))
