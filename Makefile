EMACS = emacs


test-deps/ert-async.el:
	mkdir test-deps || echo ""
	wget "https://raw.githubusercontent.com/rejeep/ert-async.el/master/ert-async.el" -O ./test-deps/ert-async.el

check: compile print-encoding test-deps/ert-async.el
	$(EMACS) -q -batch -l langtool.el -l test-deps/ert-async.el -l .test-init.el -l langtool-test.el \
		-f ert-run-tests-batch-and-exit
	$(EMACS) -q -batch -l langtool.elc -l test-deps/ert-async.el -l .test-init.el -l langtool-test.el \
		-f ert-run-tests-batch-and-exit

compile:
	$(EMACS) -q -batch -l subr-x.el -f batch-byte-compile \
		langtool.el

# print encoding conversion
print-encoding:
	@$(EMACS) -batch -l "./langtool.el" -eval "(mapc (lambda (cs) (let ((jcs (langtool--java-coding-system cs))) (princ (format \"%s -> %s\n\" cs jcs)))) (sort (coding-system-list) 'string-lessp))" 

save-encoding:
	@$(MAKE) -s print-encoding > ./encodings/`date +%Y%m%dT%H%M%S`.txt
