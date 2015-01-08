(setq ibuffer-saved-filter-groups
      (quote (("plusauri"
               ("Runs" (or
                        (name . "*time ")))
               ("D-CG" (or
                        (filename . "/plusauri/dart/plus/codegen/dlang/")))
               ("D" (or
                        (filename . "/plusauri/dlang/plus/")))
               ("CG-Base" (or
                           (filename . "/open_source/codegen/dart/ebisu.*\\.dart")))
               ("Dart-CG" (or
                           (filename . "/plusauri/dart/plus/codegen/dart")))
               ("Dart" (or
                           (filename . "/plusauri/dart/plus/")))
               ("CG-Base" (or
                           (filename . "/open_source/codegen/dart/ebisu.*\\.dart")))
               ("PLUSAURI" (or
                            (name . "PLUSAURI.org")
                            (name . "eoy_earnings.txt")
                            (name . "dbdavidson.d")
                            (filename . "/plusauri/schema/")
                            (filename . "/fcs/ruby/portfolio/value_portfolio.rb")))
               ("Legacy-D" (or
                           (filename . "/plusauri/dlang/plusauri/")))
               ("Legacy-CG" (or
                           (filename . "/plusauri/ruby/lib/plusauri/dlang")
                           ))
               )
              ("plusauri-legacy"
               ("PLUSAURI" (or
                            (name . "PLUSAURI.org")
                            (name . "eoy_earnings.txt")
                            (name . "dbdavidson.d")
                            (filename . "/plusauri/dlang/")
                            (filename . "/plusauri/schema/")
                            (filename . "/plusauri/ruby/lib/plusauri/dlang")
                            (filename . "/fcs/ruby/portfolio/value_portfolio.rb")
                            (name . "/plusauri/dlang/plusauri/"))))
              ("auction"
               ("AUCTION" (or
                           (name . "AUCTION.org")
                           (filename . "open_source/auction")))))))

(add-hook 'ibuffer-mode-hook
          (lambda ()
            (ibuffer-auto-mode 1)
            (setq ibuffer-sorting-mode 'recency)
            (ibuffer-switch-to-saved-filter-groups "plusauri")))
(setq ibuffer-expert t)
(setq ibuffer-show-empty-filter-groups nil)
