;;; init.el -*- lexical-binding: t; -*-
;;
;; Author:  Henrik Lissner <henrik@lissner.net>
;; URL:     https://github.com/hlissner/doom-emacs
;;
;;   =================     ===============     ===============   ========  ========
;;   \\ . . . . . . .\\   //. . . . . . .\\   //. . . . . . .\\  \\. . .\\// . . //
;;   ||. . ._____. . .|| ||. . ._____. . .|| ||. . ._____. . .|| || . . .\/ . . .||
;;   || . .||   ||. . || || . .||   ||. . || || . .||   ||. . || ||. . . . . . . ||
;;   ||. . ||   || . .|| ||. . ||   || . .|| ||. . ||   || . .|| || . | . . . . .||
;;   || . .||   ||. _-|| ||-_ .||   ||. . || || . .||   ||. _-|| ||-_.|\ . . . . ||
;;   ||. . ||   ||-'  || ||  `-||   || . .|| ||. . ||   ||-'  || ||  `|\_ . .|. .||
;;   || . _||   ||    || ||    ||   ||_ . || || . _||   ||    || ||   |\ `-_/| . ||
;;   ||_-' ||  .|/    || ||    \|.  || `-_|| ||_-' ||  .|/    || ||   | \  / |-_.||
;;   ||    ||_-'      || ||      `-_||    || ||    ||_-'      || ||   | \  / |  `||
;;   ||    `'         || ||         `'    || ||    `'         || ||   | \  / |   ||
;;   ||            .===' `===.         .==='.`===.         .===' /==. |  \/  |   ||
;;   ||         .=='   \_|-_ `===. .==='   _|_   `===. .===' _-|/   `==  \/  |   ||
;;   ||      .=='    _-'    `-_  `='    _-'   `-_    `='  _-'   `-_  /|  \/  |   ||
;;   ||   .=='    _-'          '-__\._-'         '-_./__-'         `' |. /|  |   ||
;;   ||.=='    _-'                                                     `' |  /==.||
;;   =='    _-'                                                            \/   `==
;;   \   _-'                                                                `-_   /
;;    `''                                                                      ``'
;;
;; These demons are not part of GNU Emacs.
;;
;;; License: MIT

(defvar doom-gc-cons-threshold 16777216 ; 16mb
  "The default value to use for `gc-cons-threshold'. If you experience freezing,
decrease this. If you experience stuttering, increase this.")

(defvar doom-gc-cons-upper-limit 268435456 ; 256mb
  "The temporary value for `gc-cons-threshold' to defer it.")


(defvar doom--file-name-handler-alist file-name-handler-alist)

(defun doom|restore-startup-optimizations ()
  "Resets garbage collection settings to reasonable defaults (a large
`gc-cons-threshold' can cause random freezes otherwise) and resets
`file-name-handler-alist'."
  (setq file-name-handler-alist doom--file-name-handler-alist)
  ;; Do this on idle timer to defer a possible GC pause that could result; also
  ;; allows deferred packages to take advantage of these optimizations.
  (run-with-idle-timer
   3 nil (lambda () (setq-default gc-cons-threshold doom-gc-cons-threshold))))


(if (or after-init-time noninteractive)
    (setq gc-cons-threshold doom-gc-cons-threshold)
  ;; A big contributor to startup times is garbage collection. We up the gc
  ;; threshold to temporarily prevent it from running, then reset it later in
  ;; `doom|restore-startup-optimizations'.
  (setq gc-cons-threshold doom-gc-cons-upper-limit)
  ;; This is consulted on every `require', `load' and various path/io functions.
  ;; You get a minor speed up by nooping this.
  (setq file-name-handler-alist nil)
  ;; Not restoring these to their defaults will cause stuttering/freezes.
  (add-hook 'emacs-startup-hook #'doom|restore-startup-optimizations))


;; Ensure Doom is running out of this file's directory
(setq user-emacs-directory (file-name-directory load-file-name))
;; In noninteractive sessions, prioritize non-byte-compiled source files to
;; prevent stale, byte-compiled code from running. However, if you're getting
;; recursive load errors, it may help to set this to nil.
(setq load-prefer-newer noninteractive)


;; Let 'er rip!
(require 'core (concat user-emacs-directory "core/core"))

(package-initialize)

(require 'p4)

(require 'cc-mode)

;;lsp-java starts here
;;
;; (condition-case nil
;;     (require 'use-package)
;;   (file-error
;;    (require 'package)
;;    (add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/"))
;;    (package-initialize)
;;    (package-refresh-contents)
;;    (package-install 'use-package)
;;    (require 'use-package)))

;; (use-package lsp-mode
;;   :ensure t
;;   :init (setq lsp-inhibit-message t
;;               lsp-eldoc-render-all nil
;;               lsp-highlight-symbol-at-point nil))

;; (use-package company-lsp
;;   :after  company
;;   :ensure t
;;   :config
;;   (add-hook 'java-mode-hook (lambda () (push 'company-lsp company-backends)))
;;   (setq company-lsp-enable-snippet t
;;         company-lsp-cache-candidates t)
;;   (push 'java-mode company-global-modes))

;; (use-package lsp-ui
;;   :ensure t
;;   :config
;;   (setq lsp-ui-sideline-enable t
;;         lsp-ui-sideline-show-symbol t
;;         lsp-ui-sideline-show-hover t
;;         lsp-ui-sideline-show-code-actions t
;;         lsp-ui-sideline-update-mode 'point))

;; (use-package lsp-java
;;   :ensure t
;;   :requires (lsp-ui-flycheck lsp-ui-sideline)
;;   :config
;;   (add-hook 'java-mode-hook  'lsp-java-enable)
;;   (add-hook 'java-mode-hook  'flycheck-mode)
;;   (add-hook 'java-mode-hook  'company-mode)
;;   (add-hook 'java-mode-hook  (lambda () (lsp-ui-flycheck-enable t)))
;;   (add-hook 'java-mode-hook  'lsp-ui-sideline-mode)
;;   (setq lsp-java--workspace-folders (list "/SAPDevelop/AN/src/ariba/ond/AN/mdev/")))

;;lsp-java ends here

(require 'doom-modeline)
(doom-modeline-init)

;; Tell emacs where is your personal elisp lib dir
;; (add-to-list 'load-path "~/.emacs.d/lisp/")
;; ;; load the packaged named xyz.
;; (load "sqlplus") ;; best not to include the ending “.el” or “.elc”

(projectile-register-project-type 'maven-project '("pom.xml")
                                  :compile "m"
                                  :test "mvn test"
                                  :test-suffix "Test"
                                  :src-dir "main/src/"
                                  :test-dir "main/test/")

;; intellij-lsp starts here

(with-eval-after-load 'lsp-mode
  (require 'lsp-intellij)
  (add-hook 'java-mode-hook #'lsp-intellij-enable))

(require 'lsp-ui)
(add-hook 'lsp-after-open-hook #'lsp-ui-mode)

(require 'company-lsp)
(setq company-lsp-enable-snippet t
      company-idle-delay nil
      company-lsp-cache-candidates t)
(push 'company-lsp company-backends)
(push 'java-mode company-global-modes)
(push 'kotlin-mode company-global-modes) ;; if using Kotlin

;; intellij-lsp ends here

;; sql beautify starts here
;;
(defun sql-beautify-region (beg end)
  "Beautify SQL in region between beg and END."
  (interactive "r")
  (save-excursion
    (shell-command-on-region beg end "anbt-sql-formatter" nil t)))
    ;; change sqlbeautify to anbt-sql-formatter if you
    ;;ended up using the ruby gem

(defun sql-beautify-buffer ()
 "Beautify SQL in buffer."
 (interactive)
 (sql-beautify-region (point-min) (point-max)))

;; sql beautify ends here
;;
