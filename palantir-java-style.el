;;; palantir-java-style.el --- Indentation style matching palantir-java-format -*- lexical-binding: t -*-

;; Author: Will Dey
;; Maintainer: Will Dey
;; Version: 1.0.0
;; Package-Requires: ()
;; Homepage: homepage
;; Keywords: java import

;; This file is not part of GNU Emacs

;; This program is free software: you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <https://www.gnu.org/licenses/>.

;;; Commentary:

;;; Code:

(declare-function c-langelem-col "cc-defs" (langelem &optional preserve-point))

;;;###autoload
(defun palantir-java-style-lineup-anchor (langelem)
  (vector (c-langelem-col langelem :preserve-point)))

(defvar c-syntactic-context)
;;;###autoload
(defun palantir-java-style-lineup-single-arg (_langelem)
  (save-excursion
    (forward-line)
    (when (assq 'statement-cont (c-guess-basic-syntax))
      '++)))

;;;###autoload
(defun palantir-java-style-lineup-cascaded-calls (_langelem)
  (save-excursion
    (back-to-indentation)
    (when (looking-at (rx ?.))
      '++)))

;;;###autoload
(defconst palantir-java-style
  '("java"
    (indent-tabs-mode . nil)
    (c-basic-offset . 4)
    (c-offsets-alist . ((statement-cont . ++)
			(statement-block-intro . (add palantir-java-style-lineup-anchor +))
			(block-close . palantir-java-style-lineup-anchor)
			(arglist-cont . (first palantir-java-style-lineup-cascaded-calls 0))
			(arglist-intro . (add palantir-java-style-lineup-anchor ++ palantir-java-style-lineup-single-arg))
			(arglist-cont-nonempty . ++)
			(arglist-close . ++)
			(case-label . +)
			(topmost-intro-cont . 0)
			(template-args-cont . 16)))))

;;;###autoload
(c-add-style "palantir" palantir-java-style)

(provide 'palantir-java-style)

;;; palantir-java-style.el ends here
