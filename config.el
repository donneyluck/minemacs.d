;;; config.el -*- lexical-binding: t; -*-

;; Copyright (C) 2022 Abdelhak Bougouffa

;; Personal info
(setq user-full-name "donney.luck"
      user-mail-address "donney.luck@gmail.com")

;; Set the default GPG key ID, see "gpg --list-secret-keys"
;; (setq-default epa-file-encrypt-to '("XXXX"))

(setq
 ;; Set a theme for MinEmacs, supported themes include these from `doom-themes'
 ;; or built-in themes
 ;; minemacs-theme 'doom-one ; `doom-one' is a dark theme, `doom-one-light' is the light one
 minemacs-theme 'doom-monokai-classic
 ;; Set Emacs fonts, some good choices include:
 ;; - Cascadia Code
 ;; - Fira Code, FiraCode Nerd Font
 ;; - Iosevka, Iosevka Fixed Curly Slab
 ;; - IBM Plex Mono
 ;; - JetBrains Mono
 minemacs-fonts
 '(:font-family "Courier New"
 ;;'(:font-family "Iosevka Fixed Curly Slab"
 ;;'(:font-family "JetBrains Mono"
   :font-size 15
   :variable-pitch-font-family "IBM Plex Serif"
   :variable-pitch-font-size 15))

;; When `me-daemon' and `me-email' are enabled, MinEmacs will try to start
;; `mu4e' in background at startup. To disable this behavior, you can set
;; `+mu4e-auto-start' to nil here.
;; (setq +mu4e-auto-start nil)

(+deferred!
 ;; Auto enable Eglot in modes `+eglot-auto-enable-modes' using
 ;; `+eglot-auto-enable' (from the `me-prog' module). You can use
 ;; `+lsp-auto-enable' instead to automatically enable LSP mode in supported
 ;; modes (from the `me-lsp' module).
 (+eglot-auto-enable)

 ;; Add `ocaml-mode' to `eglot' auto-enable modes
 (add-to-list '+eglot-auto-enable-modes 'ocaml-mode)

 (with-eval-after-load 'eglot
   ;; You can use this to fill `+eglot-auto-enable-modes' with all supported
   ;; modes from `eglot-server-programs'
   (+eglot-use-on-all-supported-modes eglot-server-programs)))

;; If you installed Emacs from source, you can add the source code
;; directory to enable jumping to symbols defined in Emacs' C code.
;; (setq source-directory "~/Sources/emacs-git/")

;; I use Brave, and never use Chrome, so I replace chrome program with "brave"
(setq browse-url-chrome-program (or (executable-find "brave") (executable-find "chromium")))

;; Install some third-party packages. MinEmacs uses `use-package' and `straight'
;; for package management. It is recommended to use the same to install
;; additional packages. For example, to install `devdocs' you can use something
;; like:
(use-package devdocs
  ;; The installation recipe (from Github)
  :straight (:host github :repo "astoff/devdocs.el" :files ("*.el"))
  ;; Autoload the package when invoking these commands, note that if the
  ;; commands are already autoloaded (defined with `autoload'), this is not
  ;; needed.
  :commands devdocs-install
  ;; MinEmacs sets the `use-package-always-defer' to t, so by default, packages
  ;; are deferred to save startup time. If you want to load a package
  ;; immediately, you need to explicitly use `:demand t'.
  ;; :demand t
  ;; Set some custom variables, using the `:custom' block is recommended over
  ;; using `setq'. This will ensure calling the right setter function if it is
  ;; defined for the custom variable.
  :custom
  (devdocs-data-dir (concat minemacs-local-dir "devdocs/")))

;; Module: `me-natural-langs' -- Package: `spell-fu'
(with-eval-after-load 'spell-fu
  ;; We can use MinEmacs' helper macro `+spell-fu-register-dictionaries!'
  ;; to enable multi-language spell checking.
  (+spell-fu-register-dictionaries! "en" "cn"))

;; Module: `me-rss' -- Package: `elfeed'
(with-eval-after-load 'elfeed
  ;; Add news feeds for `elfeed'
  (setq elfeed-feeds
        '("https://itsfoss.com/feed"
          "https://lwn.net/headlines/rss"
          "https://linuxhandbook.com/feed"
          "https://www.omgubuntu.co.uk/feed"
          "https://this-week-in-rust.org/rss.xml"
          "https://planet.emacslife.com/atom.xml")))

;; Module: `me-email' -- Package: `mu4e'
(with-eval-after-load 'mu4e
  ;; Load personal aliases, a file containing aliases, for example:
  ;; alias gmail "Firstname Lastname <some.user.name@gmail.com>"
  ;; alias work  "Firstname Lastname <some.user.name@work.com>"

  ;; (setq mail-personal-alias-file (concat minemacs-config-dir "private/mail-aliases.mailrc"))

  (setq +mu4e-auto-bcc-address "always.bcc@this.email") ;; Add an email address always included as BCC

  ;; Register email accounts with mu4e
  ;; Use MinEmacs' `+mu4e-register-account' helper function to register multiple accounts
  (+mu4e-register-account
   "Google mail" ;; Account name
   "gmail" ;; Maildir
   `((user-mail-address     . "account1@gmail.com")
     (mu4e-sent-folder      . "/gmail/Sent Mail")
     (mu4e-drafts-folder    . "/gmail/Drafts")
     (mu4e-trash-folder     . "/gmail/Trash")
     ;; These settings aren't mandatory if a `msmtp' config is used.
     (smtpmail-smtp-server  . "smtp.googlemail.com")
     (smtpmail-smtp-service . 587)
     ;; Define account aliases
     (+mu4e-account-aliases . ("account1-alias@somesite.org"
                               "account1-alias@othersite.org"))
     ;; Org-msg greeting and signature
     (org-msg-greeting-fmt  . "Hi%s,")
     ;; Generate signature
     (org-msg-signature     . ,(+org-msg-make-signature
                                "Regards," ;; Closing phrase
                                "Firstname" ;; First name
                                "Lastname" ;; Last name
                                "/R&D Engineer at Some company/")))
   'default ;; Use it as default in a multi-accounts setting
   'gmail)) ;; This is a Gmail account, store it and treat it accordingly (see `me-mu4e-gmail')

;; Module: `me-org' -- Package: `org'
(with-eval-after-load 'org
  ;; Set Org-mode directory
  (setq org-directory "~/work/org/" ; let's put files here
        org-default-notes-file (concat org-directory "inbox.org"))
  ;; Customize Org stuff
  ;; (setq org-todo-keywords
  ;;       '((sequence "IDEA(i)" "TODO(t)" "NEXT(n)" "PROJ(p)" "STRT(s)" "WAIT(w)" "HOLD(h)" "|" "DONE(d)" "KILL(k)")
  ;;         (sequence "[ ](T)" "[-](S)" "|" "[X](D)")
  ;;         (sequence "|" "OKAY(o)" "YES(y)" "NO(n)")))

  (setq org-export-headline-levels 5)

  ;; Your Org files to include in the agenda
  (setq org-agenda-files
        (mapcar
         (lambda (f) (concat org-directory f))
         '("inbox.org"
           "agenda.org"
           "projects.org"))))

;; Module: `me-notes' -- Package: `org-roam'
;; For better integration with other packages (like `citar-org-roam'), it is
;; recommended to set the `org-roam-directory' before loading the package.
(setq org-roam-directory "~/work/org/slip-box/")

(with-eval-after-load 'org-roam
  (setq org-roam-db-location (concat org-roam-directory "org-roam.db"))

  ;; Register capture template (via Org-Protocol)
  ;; Add this as bookmarklet in your browser
  ;; javascript:location.href='org-protocol://roam-ref?template=r&ref=%27+encodeURIComponent(location.href)+%27&title=%27+encodeURIComponent(document.title)+%27&body=%27+encodeURIComponent(window.getSelection())
  (setq org-roam-capture-ref-templates
        '(("r" "ref" plain "%?"
           :if-new (file+head "web/%<%Y%m%d%H%M%S>-${slug}.org" "#+title: ${title}\n#+created: %U\n\n${body}\n")
           :unnarrowed t))))

;; Module: `me-media' -- Package: `empv'
(with-eval-after-load 'empv
  ;; Set the radio channels, you can get streams from radio-browser.info
  (setq empv-radio-channels
        '(("El-Bahdja FM" . "http://webradio.tda.dz:8001/ElBahdja_64K.mp3")
          ("El-Chaabia" . "https://radio-dzair.net/proxy/chaabia?mp=/stream")
          ("Quran Radio" . "http://stream.radiojar.com/0tpy1h0kxtzuv")
          ("Algeria International" . "https://webradio.tda.dz/Internationale_64K.mp3")
          ("JOW Radio" . "https://str0.creacast.com/jowradio")
          ("Europe1" . "http://ais-live.cloud-services.paris:8000/europe1.mp3")
          ("France Iter" . "http://direct.franceinter.fr/live/franceinter-hifi.aac")
          ("France Info" . "http://direct.franceinfo.fr/live/franceinfo-hifi.aac")
          ("France Culture" . "http://icecast.radiofrance.fr/franceculture-hifi.aac")
          ("France Musique" . "http://icecast.radiofrance.fr/francemusique-hifi.aac")
          ("FIP" . "http://icecast.radiofrance.fr/fip-hifi.aac")
          ("Beur FM" . "http://broadcast.infomaniak.ch/beurfm-high.aac")
          ("Skyrock" . "http://icecast.skyrock.net/s/natio_mp3_128k"))
        ;; See: docs.invidious.io/instances/
        empv-invidious-instance "https://invidious.projectsegfau.lt/api/v1"))

;; Module: `me-ros' -- Package: `ros'
(with-eval-after-load 'ros
  (setq ros-workspaces
        (list
         (ros-dump-workspace
          :tramp-prefix "/docker:ros@ros-machine:"
          :workspace "~/ros_ws"
          :extends '("/opt/ros/noetic/"))
         (ros-dump-workspace
          :tramp-prefix "/docker:ros@ros-machine:"
          :workspace "~/ros2_ws"
          :extends '("/opt/ros/foxy/")))))

(use-package evil-surround
  :straight t
  :demand t
  :config
  (global-evil-surround-mode 1))

(use-package protobuf-mode
  :straight t
  :demand t
  :mode ("\\.proto\\'" . protobuf-mode))

(defun tempel-include (elt)
  (when (eq (car-safe elt) 'i)
    (if-let (template (alist-get (cadr elt) (tempel--templates)))
        (cons 'l template)
      (message "Template %s not found" (cadr elt))
      nil)))
(add-to-list 'tempel-user-elements #'tempel-include)

(use-package string-inflection
  :straight t
  :commands (string-inflection-all-cycle
             string-inflection-toggle
             string-inflection-camelcase
             string-inflection-lower-camelcase
             string-inflection-kebab-case
             string-inflection-underscore
             string-inflection-capital-underscore
             string-inflection-upcase)
  :init
  (+map!
        "c~~" '(string-inflection-all-cycle :wk "cycle")
        "c~t" '( string-inflection-toggle :wk "toggle")
        "c~c" 'string-inflection-camelcase
        "c~d" #'string-inflection-lower-camelcase
        "c~k" #'string-inflection-kebab-case
        "c~_" #'string-inflection-underscore
        "c~u" #'string-inflection-capital-underscore
        "c~U" #'string-inflection-upcase)
  (with-eval-after-load 'evil
    (evil-define-operator evil-operator-string-inflection (beg end _type)
      "Define a new evil operator that cycles symbol casing."
      :move-point nil
      (interactive "<R>")
      (string-inflection-all-cycle)
      (setq evil-repeat-info '([?g ?~])))
    (+nmap! "g~" 'evil-operator-string-inflection)))

(use-package screenshot
  :straight (:type git :host github :repo "tecosaur/screenshot")
  :config
  (setq screenshot-line-numbers-p nil)
  (setq screenshot-min-width 120)
  (setq screenshot-max-width 300)
  (setq screenshot-truncate-lines-p nil)
  (setq screenshot-text-only-p nil)
  (setq screenshot-font-size 10)
  (setq screenshot-border-width 16)
  (setq screenshot-upload-fn "upload %s 2>/dev/null")
  ;;(setq screenshot-radius 0)
  ;; (setq screenshot-shadow-radius 0)
  ;; (setq screenshot-shadow-offset-horizontal 0)
  ;; (setq screenshot-shadow-offset-vertical 0)
  :hook
  ((screenshot-buffer-creation . g-screenshot-on-buffer-creation)))
