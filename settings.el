
(require 'cl)

(require 'package)

;--Adding archives for packages.
(add-to-list 'package-archives '("marmalade" . "https://marmalade-repo.org/packages/"))
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/"))
(add-to-list 'package-archives '("org" . "http://orgmode.org/elpa/") t) 
(package-initialize)

; Defining packages to be installed from archives.
(defvar my-packages
  '(yasnippet
    noctilux-theme
    atom-one-dark-theme
    org-beautify-theme
    helm
    auto-complete
        org-bullets
        evil
        evil-leader
        evil-nerd-commenter
        powerline
        powerline-evil
        smex
        linum-relative
        bash-completion
        which-key
        flymake-jslint
        evil-leader
        origami
        autopair)
 
  "A list of packages to ensure are installed at launch.")
 
(defun my-packages-installed-p ()
  (loop for p in my-packages
        when (not (package-installed-p p)) do (return nil)
        finally (return t)))
 
(unless (my-packages-installed-p)
  ;; check for new packages (package versions)
  (package-refresh-contents)
  ;; install the missing packages
  (dolist (p my-packages)
    (when (not (package-installed-p p))
      (package-install p))))

(require 'origami)
(global-origami-mode)

(require 'bash-completion)
(bash-completion-setup)
(require 'which-key)
(which-key-mode)

(require 'linum-relative)
(linum-on)
(global-linum-mode)

(require 'evil)
(global-evil-leader-mode)
(evil-mode 1)

(global-set-key (kbd "C-w") 'evil-window-map)
(define-key evil-normal-state-map (kbd "C-h") 'evil-window-left)
(define-key evil-normal-state-map (kbd "C-j") 'evil-window-down)
(define-key evil-normal-state-map (kbd "C-k") 'evil-window-up)
(define-key evil-normal-state-map (kbd "C-l") 'evil-window-right)
(define-key evil-normal-state-map (kbd "C-w C-h") 'evil-window-left)
(define-key evil-normal-state-map (kbd "C-w C-j") 'evil-window-down)
(define-key evil-normal-state-map (kbd "C-w C-k") 'evil-window-up)
(define-key evil-normal-state-map (kbd "C-w C-l") 'evil-window-right)

(setq evil-leader/leader "<SPC>")
(require 'evil-leader)
(evil-leader/set-key
  "f" 'ctl-x-5-prefix
  "k" 'kill-buffer
  "SPC" 'recentf-open-files)

(loop for (mode . state) in
      '((minibuffer-inactive-mode . emacs)
        (ggtags-global-mode . emacs)
        (grep-mode . emacs)
        (Info-mode . emacs)
        (term-mode . emacs)
        (sdcv-mode . emacs)
        (anaconda-nav-mode . emacs)
        (log-edit-mode . emacs)
        (vc-log-edit-mode . emacs)
        (magit-log-edit-mode . emacs)
        (inf-ruby-mode . emacs)
        (direx:direx-mode . emacs)
        (yari-mode . emacs)
        (erc-mode . emacs)
        (neotree-mode . emacs)
        (w3m-mode . emacs)
        (gud-mode . emacs)
        (help-mode . emacs)
        (eshell-mode . emacs)
        (shell-mode . emacs)
        ;;(message-mode . emacs)
        (fundamental-mode . emacs)
        (weibo-timeline-mode . emacs)
        (weibo-post-mode . emacs)
        (sr-mode . emacs)
        (dired-mode . emacs)
        (compilation-mode . emacs)
        (speedbar-mode . emacs)
        (magit-commit-mode . normal)
        (magit-diff-mode . normal)
        (js2-error-buffer-mode . emacs)
        )
      do (evil-set-initial-state mode state))

(require 'powerline)

(require 'powerline-evil)
(powerline-evil-center-color-theme)

(add-hook 'js-mode-hook 'flymake-jslint-load)

(require 'helm)
(require 'helm-config)
(define-key helm-map (kbd "C-j") 'helm-next-line) ; Rebind
(define-key helm-map (kbd "C-k") 'helm-previous-line) ; Rebind
(helm-mode 1)

(require 'yasnippet)
(yas-global-mode 1)

(ac-config-default)
(global-auto-complete-mode t)

(require 'autopair)
(autopair-global-mode)

(require 'org-bullets)
(add-hook 'org-mode-hook (lambda () (org-bullets-mode 1)))

(global-set-key "\C-ca" 'org-agenda)
(global-set-key (kbd "C-c c") 'org-capture)

(setq org-directory "~/Org")
;; Tells org WHERE the noted from capture will be stored.
(setq org-default-notes-file "~/Org/organiser.org")
(setq org-log-done 'time)
(setq org-agenda-include-all-todo t)    
(setq org-agenda-files (list "~/Org/agenda"))
(setq org-archive-location (concat "~/Org/archive/" (format-time-string "%Y-%m") ".org::"))

(setq org-tag-alist '(("@work" . ?w)
                      ("@home" . ?h)
                      ("@errands" . ?e)
                      ("@coding" . ?c)
                      ("@phone" . ?p)
                      ("@reading" . ?r)
                      ("@computer" . ?l)
                      ("lowenergy" . ?0)
                      ("highenergy" . ?1)))

(setq org-todo-keywords
 '((sequence
    "TODO(t)"  ; next action
    "STARTED(s)"
    "WAITING(w@/!)"
    "SOMEDAY(.)" "|" "DONE(x!)" "CANCELLED(c@)")
   (sequence "LEARN" "DO" "TEACH" "|" "COMPLETE(x)")
   (sequence "TODELEGATE(-)" "DELEGATED(d)" "|" "COMPLETE(x)")))

(setq org-todo-keyword-faces
      '(("TODO" . (:foreground "green" :weight bold))
        ("DONE" . (:foreground "cyan" :weight bold))
        ("WAITING" . (:foreground "red" :weight bold))
        ("SOMEDAY" . (:foreground "gray" :weight bold))))

(setq org-use-fast-todo-selection t)

(defun org-archive-done-tasks ()
  "Archive finished or cancelled tasks."
  (interactive)
  (org-map-entries
   (lambda ()
     (org-archive-subtree)
     (setq org-map-continue-from (outline-previous-heading)))
   "TODO=\"DONE\"|TODO=\"CANCELLED\"" (if (org-before-first-heading-p) 'file 'tree)))

(require 'recentf)
(recentf-mode 1)
(setq recentf-max-saved-items 200
      recentf-max-menu-items 20)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(initial-buffer-choice (quote recentf-open-files))
 )

(split-window-horizontally)
(set-window-buffer (next-window) (find-file "~/Org/Main.org"))

(defun nolinum ()
  (interactive)
  (message "Deactivated linum mode")
  (global-linum-mode 0)
  (linum-mode 0)
)

(global-set-key (kbd "<f6>") 'nolinum)

(add-hook 'org-mode-hook 'nolinum)
(add-hook 'doc-view-mode-hook' nolinum)

(defun my-evil-modeline-change (default-color)
  "changes the modeline color when the evil mode changes"
  (let ((color (cond ((evil-insert-state-p) '("#002233" . "#ffffff"))
                     ((evil-visual-state-p) '("#330022" . "#ffffff"))
                     ((evil-normal-state-p) default-color)
                     (t '("#440000" . "#ffffff")))))
    (set-face-background 'mode-line (car color))
    (set-face-foreground 'mode-line (cdr color))))

(lexical-let ((default-color (cons (face-background 'mode-line)
                                   (face-foreground 'mode-line))))
  (add-hook 'post-command-hook (lambda () (my-evil-modeline-change default-color))))

(defun my-new-shell ()
  (interactive)

  (let (
        (currentbuf (get-buffer-window (current-buffer)))
        (newbuf     (generate-new-buffer-name "*shell*"))
       )

   (generate-new-buffer newbuf)
   (set-window-dedicated-p currentbuf nil)
   (set-window-buffer currentbuf newbuf)
   (shell newbuf)
  )
)

;; example. template insertion command
(defun insert-my-list ()
    (interactive)
    (insert "- [ ] "))

(set-frame-font "Source Code Pro-16" nil t)
(menu-bar-mode -1)
(toggle-scroll-bar -1)
(tool-bar-mode -1)

(load-theme 'atom-one-dark t)

(global-set-key (kbd "C-c C--") 'insert-my-list)
(global-set-key (kbd "M-s")'my-new-shell)
(global-set-key (kbd "M-d") 'recentf-open-more-files)
(global-set-key (kbd "C-a") 'org-archive-done-tasks)

(add-hook 'origami-mode-hook
          (lambda () (local-set-key (kbd "C-c j") 'origami-recursively-toggle-node)))

(add-hook 'origami-mode-hook
          (lambda () (local-set-key (kbd "C-c k") 'origami-show-node)))

(add-hook 'origami-mode-hook
          (lambda () (local-set-key (kbd "C-c l") 'origami-close-all-nodes)))

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(powerline-evil-normal-face ((t (:inherit powerline-evil-base-face :background "dark green")))))

(fset 'yes-or-no-p 'y-or-n-p)
