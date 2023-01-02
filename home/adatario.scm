(use-modules
  (gnu home)
  (gnu home services)
  (gnu home services shells)
  (gnu services)
  (gnu packages)
  (guix gexp))

(define emacs-packages
  (map
   specification->package+output
   '("emacs-next"
     "inotify-tools"			; Some Emacs things need this
     "sqlite"

     "emacs-use-package"
     "emacs-general"
     "emacs-which-key"
     "emacs-restart-emacs"
     "emacs-diminish"
     "emacs-shackle"

     "emacs-writeroom"

     "emacs-pdf-tools"

     "emacs-evil"
     "emacs-evil-collection"
     "emacs-evil-commentary"

     "emacs-lispy"
     "emacs-lispyville"
     "emacs-smartparens"
     "emacs-rainbow-delimiters"

     "emacs-org-roam"

     "emacs-ivy"
     "emacs-counsel"

     "emacs-projectile"
     "emacs-counsel-projectile"

     ;; "emacs-direnv"
     "emacs-envrc"

     "emacs-magit"
     "emacs-magit-annex"
     "emacs-git-gutter"

     "emacs-flycheck"

     "emacs-tuareg"

     "emacs-eros"
     "emacs-geiser"
     "emacs-geiser-guile"
     "emacs-flycheck-guile")))

(define packages
  (map
   specification->package+output
   '(;; Guile
     "guile"
     "guile-readline"

     ;; Tools
     "ripgrep"
     "tree"
     "fd"
     "ranger"
     "direnv"
     "tmuxifier"
     "mosh"
     "zip"
     "unzip"
     "curl"
     "wget"
     "bc"

     ;; X tools
     "pavucontrol-qt"

     ;; WM
     "sway"
     "bemenu"
     "i3status"
     "xdg-utils"
     "wl-clipboard"
     "arandr"
     "foot"

     ;; Git
     "git"

     ;; GPG
     "gnupg"
     "pinentry-gtk2"
     "password-store"

     ;; OCaml / OPAM
     "make"
     "gcc-toolchain"
     "pkg-config"
     "opam"
     "ocaml"
     "ocaml-merlin"
     "ocamlformat"

     ;; Browsers
     "ungoogled-chromium"
     "icecat"

     ;; Communication
     "weechat"
     "weechat-wee-slack"

     ;; Fonts
     "font-dejavu"
     "font-bitstream-vera"
     "font-openmoji"

     ;; Speling mistakes are things computes can fix
     "aspell"
     "aspell-dict-en"
     "aspell-dict-de")))

(home-environment
 (packages (append packages emacs-packages))
 (services
  (list

   ;; bash
   (service
    home-bash-service-type
    (home-bash-configuration
     (guix-defaults? #t)
     (aliases
      '((".." . "cd ..")
	("." . "pwd")
	("l" . "ls -lh")
	("ll" . "ls -lah")
	("ltr" . "ls -ltrh")))
     (environment-variables
      '( ;; learn from history
	("HISTFILESIZE" . "-1")
	("HISTSIZE" . "-1")

	;; TODO: fix properly and upstream
	("TERMINFO" . "/gnu/store/6m6571bki2661xvs86y3fr8n3wr93i7q-foot-1.10.3/share/terminfo/")))

     (bashrc
      `(;; load direnv
	,(plain-file "direnv-hook.sh"
		     "eval \"$(direnv hook bash)\"")

	,(local-file "./dotfiles/gpg.sh")))))

   ;; Sway
   (simple-service
    'sway-config-service
    home-files-service-type
    (list `(".config/sway/config"
	    ,(local-file "./dotfiles/sway.config"))))

   ;; Dotfiles
   (simple-service
    'vimrc-service
    home-files-service-type
    (list
     `(".vimrc"      ,(local-file "./dotfiles/vimrc"))
     `(".ssh/config" ,(local-file "./dotfiles/ssh_config"))
     `(".gnupg/gpg-agent.conf" ,(local-file "./dotfiles/gpg-agent.conf"))))

   ;; Emacs init.el
   (simple-service 'emacs-init-service
		   home-files-service-type
		   (list `(".emacs.d/init.el"
			   ,(local-file "./dotfiles/init.el"))))

   ;; Git
   (simple-service 
    'git-config-service
    home-files-service-type
    (list `(".gitignore_global" ,(local-file "./dotfiles/gitignore_global"))
	  `(".gitconfig" ,(local-file "./dotfiles/gitconfig"))))
   
   )))
