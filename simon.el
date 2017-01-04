;; (add-to-list 'load-path "/Users/simon/dev/r/ess-15.09-1/lisp/")
;; (load "ess-site")

;;; Code:

(defun my-c-mode-common-hook ()
  ;; my customizations for all of c-mode and related modes
  (linum-mode)
  (flycheck-mode -1)
  )
(add-hook 'c-mode-common-hook 'my-c-mode-common-hook)

;; performance fix for font coloring - 2 is less expensive than 3
(setq font-lock-maximum-decoration '((c-mode . 2) (c++-mode . 2)))

;; linum-mode fix for font size changes
(eval-after-load "linum"
  '(set-face-attribute 'linum nil :height 100))

;; leverage ggtags - find definition support
(add-hook 'c-mode-common-hook
          (lambda ()
            (when (derived-mode-p 'c-mode 'c++-mode 'java-mode)
              (ggtags-mode 1))))

;; (require 'prelude-helm-everywhere)

(provide 'simon)
;;; simon.el ends here
