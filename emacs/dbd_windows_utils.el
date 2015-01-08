(defun dbd:Linux-p () nil)
(setq mydrive "c:")
(defun explore(mydir) (interactive "D") (shell-command (concat "start explorer.exe file:///" mydir " &")))
(setq mswindows-downcase-file-names nil)
(setq mswindows-ls-sort-case-insensitive t)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Some useful directories
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun sysinternals:processExplorer() (interactive) 
       (shell-command (format "start %s\\sysinternals\\procexp &" mydrive)))
(defun sysinternals:ntfilemon() (interactive) 
       (shell-command (format "start %s\\sysinternals\\diskmon &" mydrive)))
(defun sysinternals:regmon() (interactive) 
       (shell-command (format "%s\\sysinternals\\regmon\\regmon &" mydrive)))
(defun guid() (interactive) (shell-command "\"c:/Program Files/Microsoft Visual Studio .NET 2003/Common7/Tools/guidgen\" &"))
(defun find:uuids(dir) (interactive "sDirectory to grep: ")
       (grep (format "grep -n \"[0-9a-zA-Z][0-9a-zA-Z][0-9a-zA-Z][0-9a-zA-Z][0-9a-zA-Z][0-9a-zA-Z][0-9a-zA-Z][0-9a-zA-Z]-\" %s/*.rgs %s/*.cpp %s/*.idl %s/*.h" 
                     dir dir dir dir)))

(defun workspace:vita() (interactive)
  (save-excursion
    (let ((temp-buffer (get-buffer-create "*DBD FIND*")))
      (shell-command (format "gvim %s &" 
                             (progn 
                               (shell-command "find c:/dev/projects/vita/templates -type f -name \\*.tmpl -print" temp-buffer)
                               (set-buffer temp-buffer)
                               (replace-in-string (buffer-string) "\n" " ")
                               )))
      (shell-command (format "gvim %s &" 
                             (progn 
                               (shell-command "find c:/dev/projects/vita -type f -name \\*.\\*pp  -and -not -wholename \\*vitadb\\*  -print" temp-buffer)
                               (set-buffer temp-buffer)
                               (replace-in-string (buffer-string) "\n" " ")
                               )))
;      (shell-command "C:\"\\ACE_wrappers\\examples\\C++NPv1\\C++NPv1.sln\" &")
;      (shell-command "C:\"\\ACE_wrappers\\examples\\C++NPv2\\C++NPv2.sln\" &")
      )))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Windows Commands
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun dbd:excel() (interactive)
       (shell-command "\"C:\\Program Files\\Microsoft Office\\Office\\EXCEL.EXE\" &"))
(defun dbd:word() (interactive)
       (shell-command "\"C:\\Program Files\\Microsoft Office\\Office\\WINWORD.EXE\" &"))
(defun dbd:powerpoint() (interactive)
       (shell-command "\"C:\\Program Files\\Microsoft Office\\Office\\POWERPNT.EXE\" &"))
(defun winmerge(src dest) (interactive "fLeft: \nfRight: ") 
       (shell-command (format "start C:\\\"Program Files (x86)\\WinMerge\\WinMergeU.exe\" \"%s\" \"%s\" " src dest)))

(defun intel-init() (interactive)
  (progn
    (find-file (format "%s/%s/cpp" mydrive root))
    (new-shell)
    (insert (format "cd %s/%s/cpp" mydrive root))
    (comint-send-input)
    (insert "%comspec% /k \"C:\\Program Files (x86)\\Intel\\Compiler\\11.1\\046\\bin\\iclvars.bat\" ia32")
    (comint-send-input)
    (rename-buffer "intel-sh")
    ))

(setq pdf-reader "AcroRd32.exe")

(defun docs:intel-mkl-docs() (interactive)
  (shell-command "start c:\"/Program Files/Intel/Compiler/11.0/066/cpp/Documentation/mkl/\"mklman.chm &"))

(defun docs:intel-mkl-docs-pdf() (interactive)
  (shell-command (concat pdf-reader " c:\"/Program Files/Intel/Compiler/11.0/066/cpp/Documentation/mkl/\"mklman.pdf &")))

(defun docs:intel-mkl-docs-pdf() (interactive)
  (insert (concat pdf-reader " c:\"\\Program Files\\Intel\\Compiler\\11.0\\066\\cpp\\Documentation\\mkl\\\"mklman.pdf &")))

(defun docs:hdf5-users-guide() (interactive)
  (shell-command (concat pdf-reader " c:\\jump\\etf\\docs\\hdf5\\HDF5_UG_r166.pdf &"))
)

(defun docs:hdf5-reference-manual() (interactive)
  (shell-command (concat pdf-reader " c:\\jump\\etf\\docs\\hdf5\\HDF5_RM_r166.pdf &"))
)


(defun docs:linux-performance() (interactive)
  (shell-command (concat pdf-reader " c:\\jump\\etf\\docs\\redp4285.pdf &")))

(defun docs:i-dont-know-doc() (interactive)
  (shell-command "start c:\\jump\\etf\\docs\\c.doc &"))

(defun docs:boost-doc-folder() (interactive)
  (find-file (format "%s/%s/docs/boost_1_38" mydrive root))

(defun docs:c++_standard() (interactive)
  (shell-command (concat pdf-reader " c:\\Users\\dbdavidson\\Desktop\\c++ standard(draft).pdf &")))

(defun docs:eda() (interactive)
  (shell-command (concat pdf-reader " c:\\Users\\dbdavidson\\Desktop\\1-eda.pdf &")))


(defun bj-init() (interactive)
  (progn
    (find-file (format "c:/%s/cpp" root))
    (new-shell)
    (insert (format "cd c:/%s/cpp" root))
    (comint-send-input)
    (insert "%comspec% /k \"c:\\Program Files (x86)\\Microsoft Visual Studio 9.0\\VC\\vcvarsall.bat\" x86")
    (comint-send-input)
    (insert (format "set RUBYLIB=%s\\%s\\ruby\\lib" mydrive root))
    (comint-send-input)
    (rename-buffer "bjam-work-sh")
    ))

(defun bj-init2() (interactive)
  (progn
    (find-file (format "%s/%s/cpp" mydrive root))
    (eshell)
    (rename-buffer "bjam-work-sh")
    (insert (format "cd %s/%s/cpp
$comspec /k \"c:\\Program Files (x86)\\Microsoft Visual Studio 9.0\\VC\\vcvarsall.bat\" x86
set RUBYLIB=%s\\%s\\ruby\\lib
" mydrive root mydrive root))
    (comint-send-input)
    ))

(defun txt:liball() (interactive)
  (insert (format "ruby c:/%s/ruby/lib/%s/lib_all.rb" root root)))

(defun txt:dirhelper() (interactive)
  (insert "python c:/dbdavidson/mypython/codegen/DirHelper.py"))

(defun docs:downloads() (interactive)
  (find-file "C:/Users/dbdavidson/Documents/Downloads"))

(defun windows:eventViewer() (interactive) 
       (shell-command "C:\\WINDOWS\\system32\\eventvwr.msc &"))

(defun windows:sysInfo() (interactive) 
       (shell-command "C:\"\\Program Files\\Common Files\\Microsoft Shared\\MSInfo\\msinfo32.exe\""))

(defun ace:docs() (interactive)
  (shell-command "start c:\\doxydocs\\ace\\ace.chm"))

(defun docs:boost() (interactive)
  (shell-command "\"c:\\usr\\boost_1_39_0\\doc\\html\\index.html\""))

(defun docs:pexpect() (interactive)
  (shell-command "start C:\\pexpect\\doc\\index.html"))

(defun docs:msdev() (interactive)
  (shell-command "start C:\"\\Program Files\\Common Files\\Microsoft Shared\\Help 8\\dexplore.exe\" /helpcol ms-help://MS.MSDNQTR.v80.en /LaunchNamedUrlTopic DefaultPage"))

(defun docs:DesignPatterns() (interactive)
  (shell-command "start d:\\dev\\docs\\books\\DesignPatterns\\index.htm"))

(defun windows:depends(target) (interactive "fExecutable/Dll ")
       (my-shell-command (format "c:\\sysinternals\\depends\\depends %s &" target)) 
)

(defun windows:c++filt(target) (interactive "fMap file or mangled name file ")
  (my-shell-command (format "c:\"\\Program Files\\Microsoft Visual Studio 8\\VC\\bin\\undname\" %s" target)))

(defun resourceParser() (interactive)
  (find-file "c:\\dev\\python\\wingui\\ResourceFile.py"))

(defun grep:boostdocs(strarg) (interactive "sEnter txt:") 
  (grep (format "c:\\cygwin\\bin\\find \"%s\" %s -printf  \" \\\"\%%h/\%%f\\\"\\n\" | xargs grep -n -e %s" 
                (windowsToLinux "C:/boost_1_33_0/libs/python/doc") "  \\( -name \\*.htm\\* \\) " strarg))
  (save-excursion
    (set-buffer "*grep*")
    (rename-buffer (format "* grep:boostdoc %s *" strarg)))
)

(defun msdev8() (interactive)
  (shell-command "\"C:\\Program Files\\Common Files\\Microsoft Shared\\Help 8\\dexplore.exe\" /helpcol ms-help://MS.MSDNQTR.v80.en /LaunchNamedUrlTopic DefaultPage&"))

(defun msdn() (interactive)
  (shell-command "C:\"\\Program Files (x86)\\Common Files\\microsoft shared\\Help 9\\dexplore.exe\" /helpcol ms-help://ms.vscc.v90 /LaunchNamedUrlTopic DefaultPage /usehelpsettings VisualStudio.9.0&"))

(defun dbd:vcvars() (interactive) (insert "c:\"\\Program Files\\Microsoft Visual Studio 8\\VC\\bin\\vcvars32.bat\""))
(defun dbd:ildasm(target) (interactive "fEnter File:") 
  (shell-command (format
                  "c:\"\\Program Files\\Microsoft Visual Studio 8\\SDK\\v2.0\\bin\\ildasm\" \"%s\""
                  target)))

(defun dbd:depends(target) (interactive "fEnter File:") 
  (shell-command (format
                  "c:\"\\sysinternals\\depends\\depends\" \"%s\" &"
                  target)))

(defun dbd:loadEmbedded() (interactive)
  (find-file "c:/mercury_patches/core/lib/embed/rel/1.9.1/include/CME/CMEEClient.hxx")
  (find-file "c:/mercury_patches/core/lib/embed/rel/1.9.1/include/CME/FastFeedCommon.hxx")
  (find-file "c:/mercury_patches/core/lib/embed/rel/1.9.1/include/embed.hxx")
  (find-file "c:/mercury_patches/core/lib/embed/rel/1.9.1/include/jcme.hxx")
  (find-file "c:/mercury_patches/core/lib/embed/rel/1.9.1/include/jcmefast.hxx")
  (find-file "c:/mercury_patches/core/lib/embed/rel/1.9.1/include/jEurexEFast.hxx")
  (find-file "c:/mercury_patches/core/lib/trade2/rel/1.9.1/include/jitch.hxx")
  (find-file "c:/mercury_patches/core/lib/embed/rel/1.9.1/include/mdarbiter.hxx")
  (find-file "c:/mercury_patches/core/lib/embed/rel/1.9.1/include/mfarbiter.hxx")
  (find-file "c:/mercury_patches/core/lib/embed/rel/1.9.1/src/CME/FastFeedCommon.cxx")
  (find-file "c:/mercury_patches/core/lib/embed/rel/1.9.1/src/embed.cxx")
  (find-file "c:/mercury_patches/core/lib/embed/rel/1.9.1/src/jcme.cxx")
  (find-file "c:/mercury_patches/core/lib/embed/rel/1.9.1/src/jcmefast.cxx")
  (find-file "c:/mercury_patches/core/lib/embed/rel/1.9.1/src/jEurexEFast.cxx")
;  (find-file "c:/mercury_patches/core/lib/trade2/rel/1.9.1/src/jitch.cxx")
  (find-file "c:/mercury_patches/core/lib/embed/rel/1.9.1/src/mfarbiter.cxx")
  (find-file "c:/mercury_patches/core/lib/FIX-FAST/rel/1.9.1/src/CMEMsgDefinitionPI/CMEMsgPI.cpp")
  (find-file "c:/mercury_patches/core/lib/FIX-FAST/rel/1.9.1/include/CMEMsgDefinitionPI/CMEMsgPI.h")
  (find-file "c:/mercury_patches/core/lib/FIX-FAST/rel/1.9.1/include/FixFastTemplateDefinition/TemplateField/TemplateField.h")
  (find-file "c:/mercury_patches/core/lib/FIX-FAST/rel/1.9.1/include/FixFastTemplateDefinition/TemplateField/StringField.h")
  (find-file "c:/mercury_patches/core/lib/FIX-FAST/rel/1.9.1/include/FixFastTemplateDefinition/TemplateField/Int32Field.h")
  )


(defun downloadsFolder() (interactive) 
  (shell-command "start C:/Users/dbdavidson/Documents/Downloads"))


(defun grepDir(gdir strarg) (interactive "DEnter Dir: \nsEnter txt: ") 
  (grep (format "c:\\cygwin\\bin\\find \"%s\" %s -printf  \" \\\"\%%h/\%%f\\\"\\n\" | xargs grep -n -e %s" 
                (windowsToLinux gdir) find:args strarg))
  (save-excursion
    (set-buffer "*grep*")
    (rename-buffer (format "* grep:%s %s *" gdir strarg)))
)

(defun find-files(strarg) (interactive "DEnter dir:") 
  (grep (format "c:\\cygwin\\bin\\find \"%s\" %s -printf  \" \\\"\%%h/\%%f\\\"\\n\" | xargs grep -n -e %s" 
                (windowsToLinux dirs:liffe_codegen) find:args strarg))
  (save-excursion
    (set-buffer "*grep*")
    (rename-buffer (format "* grep:liffe_codegen %s *" strarg)))
)

;;;; Special - to find all files (since system headers have no suffix)
(defun grep:stl(strarg) (interactive "sEnter txt:") 
  (find-grep (format "find '%s' %s -print0 | xargs -0 -e grep -nH %s" 
                (windowsToLinux dirs:stl) "" strarg))
  (save-excursion
    (set-buffer "*grep*")
    (rename-buffer (format "* grep:%s(stl) *" strarg)))
)

(defun cs:headerProtection() (interactive) 
  (insert "
#pragma warning( disable : 4561 )
#pragma managed(push, off)
#include \"...\"
#pragma managed(pop)"
))

