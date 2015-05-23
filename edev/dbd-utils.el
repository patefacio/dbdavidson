
(defun clear-eshell ()
  "Clear the eshell buffer."
  (interactive)
  (let ((inhibit-read-only t))
    (erase-buffer)
    (message "erase eshell buffer")))

(defun magit()
  "Run magit-status on current file"
  (interactive)
  (magit-status (file-name-directory buffer-file-name)))


(defun fill-indented()
  "Set the fill column to 70 and then fill-paragraph"
  (interactive)
  (set-fill-column 70)
  (fill-paragraph))

(defun md-code()
  "Indent the region to 4 spaces"
  (interactive)  
  (indent-rigidly (region-beginning) (region-end) 4))
