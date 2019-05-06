;; from https://stackoverflow.com/questions/3964715/what-is-the-correct-way-to-join-multiple-path-components-into-a-single-complete
(defun catdir (root &rest dirs)
  (apply 'concat (mapcar
          (lambda (name) (file-name-as-directory name))
          (push root dirs))))

(defvar file:vsc-insider "/Applications/Visual Studio Code - Insiders.app/Contents/Resources/app/bin/code")
(defvar file:vsc "/Applications/Visual Studio Code.app/Contents/Resources/app/bin/code")
(defvar dir:open_source (catdir dbd:home "dev" "open_source"))

(defvar dir:ebisu_pod (catdir dir:open_source "ebisu_pod" ))
(defun load:ebisu_pod_dart() (interactive) (concat (find-file (catdir dir:ebisu_pod "lib")  "ebisu_pod.dart")))

(defvar dir:plusauri (catdir dir:open_source "plusauri"))
(defvar dir:plusauri-dart (catdir dir:plusauri-dart "dart"))
(defvar dir:rust-plusauri (catdir dir:plusauri "rust"))
(defvar dir:json_schema (catdir dir:plusauri "models" "json_schema"))
(defvar dir:dart-pod-models (catdir dir:plusauri "dart" "tool" "pod_models"))
(defvar dir:tasks (catdir dir:plusauri "elixir" "tasks"))
(defvar dir:kojin (catdir dir:open_source "kojin"))
(defvar file:json_schema (cat dir:json_schema "plusauri.schema.json"))

(defun load:ebisu_pod () (interactive) (find-file dir:ebisu_pod))

(defun load:json_schema () (interactive) (find-file dir:json_schema))
(defun load:plusauri () (interactive) (find-file dir:plusauri))
(defun load:rust-plusauri () (interactive) (find-file dir:rust-plusauri))
(defun load:dart-pod-models () (interactive) (find-file dir:dart-pod-models))
(defun load:tasks () (interactive) (find-file dir:tasks))
(defun load:kojin () (interactive) (find-file dir:kojin))

(defun rg-plusauri-dart(needle)
  (interactive "sEnter needle: ")
  (run-in-compile
   (concat "rg --with-filename --no-heading " needle " " dir:plusauri-dart)))

(defun rg-plusauri(needle)
  (interactive "sEnter needle: ")
  (run-in-compile
   (concat "rg --with-filename --no-heading " needle " " dir:plusauri)))

(defun @:vsc-insiders-dir (dir)
  (interactive "DEnter Dir: ")
  (shell-command (concat "'" file:vsc-insider "' " dir))
  )

(defun @:vsc-dir (dir)
  (interactive "DEnter Dir: ")
  (shell-command (concat "'" file:vsc "' " dir))
  )

(defun @:vsc-insiders-file (file)
  (interactive "FEnter File: ")
  (shell-command (concat "'" file:vsc-insider "' " file))
  )

(defun @:vsc-file (file)
  (interactive "FEnter File: ")
  (shell-command (concat "'" file:vsc "' " file))
  )

(defun @:vsc-json-schema () (interactive) (@:vsc-file file:json_schema))
(defun @:vsc-rust-plusauri () (interactive) (@:vsc-dir dir:rust-plusauri))

(defun @:vsc-tasks () (interactive) (@:vsc-dir dir:tasks))

(defun @:kojin-tests ()
  (interactive)
  (run-in-compile "cd ${HOME}/dev/open_source/kojin; time mix test"))

(defun @:run-tasks ()
  (interactive)
  (run-in-compile "cd ${HOME}/dev/open_source/plusauri/elixir/tasks; time mix test"))

(defun @:format-tasks ()
  (interactive)
  (run-in-compile "cd ${HOME}/dev/open_source/plusauri/elixir/tasks; time mix format"))

(defun @:generate-rust-pods ()
  (interactive)
  (run-in-compile "cd ${HOME}/dev/open_source/plusauri/elixir/tasks; time mix run bin/generate_rust_pods.exs"))

(defun @:regenerate-rust-pods ()
  (interactive)
  (run-in-compile "cd ${HOME}/dev/open_source/plusauri/elixir/tasks; time mix run bin/regenerate_rust_pods.exs"))

(defun @:help-elixir(key) (interactive "sEnter key: ")
       (run-in-compile
        (format "cd /Users/dbdavidson/dev/open_source/plusauri/elixir/tasks;
elixir -e \"require IEx.Helpers; IEx.Helpers.h(%s)\"" key)))

(defun @:help-elixir(key) (interactive "sEnter key: ")
       (run-in-compile
        (format "cd ${HOME}/dev/open_source/plusauri/elixir/tasks; mix run bin/help.exs %s" key)))

(defun @:load-tasks-dir ()
  (interactive)
  (find-file (concat (getenv "HOME") "/dev/open_source/plusauri/elixir/tasks")))

(defun @:vsc-tasks ()
  (interactive)
  (run-in-compile
   (concat "code " (getenv "HOME") "/dev/open_source/plusauri/elixir/tasks")))

;(load-theme 'misterioso)

(message "DBD Plusauri loaded")
