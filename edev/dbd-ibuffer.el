(setq ibuffer-saved-filter-groups
      (quote (("plusauri"
               ("Runs" (or
                        (name . "*time ")))
               ("CG-Base" (or
                           (filename . "/open_source/codegen/dart/ebisu.*\\.dart")))
               ("Dart-CG" (or
                           (filename . "/plusauri/dart/plus/codegen/dart")))
               ("Dart" (or
                           (filename . "/plusauri/dart/plus/")))
               ("PLUSAURI" (or
                            (name . "PLUSAURI.org")
                            (name . "eoy_earnings.txt")
                            (name . "dbdavidson.d")
                            (filename . "/plusauri/schema/")
                            (filename . "/fcs/ruby/portfolio/value_portfolio.rb")))))))

(add-hook 'ibuffer-mode-hook
          (lambda ()
            (ibuffer-auto-mode 1)
            (setq ibuffer-sorting-mode 'recency)
            (ibuffer-switch-to-saved-filter-groups "plusauri")))
(setq ibuffer-expert t)
(setq ibuffer-show-empty-filter-groups nil)

(message "DBD INIT - ibuffer")
