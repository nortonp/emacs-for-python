;;; epy-completion.el --- A few common completion tricks

;; Matching parentheses for all languages and so on
(require 'autopair)
(autopair-global-mode t)
(setq autopair-autowrap t)
;; Fix for triple quotes in python
(add-hook 'python-mode-hook
          #'(lambda ()
              (setq autopair-handle-action-fns
                    (list #'autopair-default-handle-action
                          #'autopair-python-triple-quote-action))))

(defun ac-eshell-mode-setup ()
  (add-to-list 'ac-sources 'ac-source-files-in-current-dir))

;; Live completion with auto-complete
;; (see http://cx4a.org/software/auto-complete/)
(require 'auto-complete-config)
(add-to-list 'ac-dictionary-directories (concat epy-install-dir "extensions/auto-complete/dict/"))
(ac-config-default)

;; set also the completion for eshell
(add-hook 'eshell-mode-hook 'ac-eshell-mode-setup)
;; custom keybindings to use tab, enter and up and down arrows
(define-key ac-complete-mode-map "\t" 'ac-expand)
(define-key ac-complete-mode-map "\r" 'ac-complete)
(define-key ac-complete-mode-map "\M-n" 'ac-next)
(define-key ac-complete-mode-map "\M-p" 'ac-previous)

;; ropemacs Integration with auto-completion
(defun ac-ropemacs-candidates ()
  (mapcar (lambda (completion)
      (concat ac-prefix completion))
    (rope-completions)))

(ac-define-source nropemacs
  '((candidates . ac-ropemacs-candidates)
    (symbol     . "p")))

(ac-define-source nropemacs-dot
  '((candidates . ac-ropemacs-candidates)
    (symbol     . "p")
    (prefix     . c-dot)
    (requires   . 0)))

(defun ac-nropemacs-setup ()
  (setq ac-sources (append '(ac-source-nropemacs
                             ac-source-nropemacs-dot) ac-sources)))
(defun ac-python-mode-setup ()
  (add-to-list 'ac-sources 'ac-source-yasnippet))

(add-hook 'python-mode-hook 'ac-python-mode-setup)
(add-hook 'rope-open-project-hook 'ac-nropemacs-setup)

(provide 'epy-completion)
;;; epy-completion.el ends here
