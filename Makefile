# v2.0
.PHONY: all paper presentation clean clean-paper clean-presentation \
        push-paper push-presentation pull-paper pull-presentation

OUTDIR := output

all: paper presentation

$(OUTDIR):
	mkdir -p $(OUTDIR)

# ── LaTeX builds (aux files stay alongside source; PDF copied to OUTDIR) ────
paper: $(OUTDIR)
	latexmk -pdf -cd paper/main.tex
	cp paper/main.pdf $(OUTDIR)/paper.pdf

presentation: $(OUTDIR)
	latexmk -pdf -cd presentation/main.tex
	cp presentation/main.pdf $(OUTDIR)/presentation.pdf

clean-paper:
	latexmk -C -cd paper/main.tex

clean-presentation:
	latexmk -C -cd presentation/main.tex

clean: clean-paper clean-presentation
	rm -rf $(OUTDIR)

# ── Overleaf push (overlay paper/ or presentation/ onto Overleaf tip) ───────
# git subtree push cannot be used: Overleaf was bootstrapped without subtree
# add, so split history has no common ancestor. Instead: fetch Overleaf tip,
# overlay local subdirectory contents at root, commit, push.
push-paper:
	git fetch overleaf-paper master && \
	git checkout -b _paper-sync overleaf-paper/master && \
	git rm -rf . && \
	git checkout master -- paper/ && \
	git mv paper/main.tex main.tex && \
	git mv paper/references.bib references.bib && \
	git mv paper/sections sections && \
	(test -e paper/main.pdf && git mv paper/main.pdf main.pdf || true) && \
	(test -d paper/figures  && git mv paper/figures  figures  || true) && \
	git commit -m "Sync from local" && \
	git push overleaf-paper _paper-sync:master && \
	git checkout master && \
	git branch -D _paper-sync

push-presentation:
	git fetch overleaf-presentation master && \
	git checkout -b _pres-sync overleaf-presentation/master && \
	git rm -rf . && \
	git checkout master -- presentation/ && \
	git mv presentation/main.tex main.tex && \
	(test -e presentation/main.pdf && git mv presentation/main.pdf main.pdf || true) && \
	(test -d presentation/figures  && git mv presentation/figures  figures  || true) && \
	(test -d presentation/archive  && git mv presentation/archive  archive  || true) && \
	git commit -m "Sync from local" && \
	git push overleaf-presentation _pres-sync:master && \
	git checkout master && \
	git branch -D _pres-sync

# ── Overleaf pull (overlay Overleaf tip back into subdirectory) ─────────────
pull-paper:
	git fetch overleaf-paper master && \
	git checkout overleaf-paper/master -- . && \
	mkdir -p paper && \
	(test -e main.tex       && git mv main.tex       paper/main.tex       || true) && \
	(test -e references.bib && git mv references.bib paper/references.bib || true) && \
	(test -d sections       && git mv sections       paper/sections       || true) && \
	(test -e main.pdf       && git mv main.pdf       paper/main.pdf       || true) && \
	(test -d figures        && git mv figures        paper/figures        || true) && \
	git commit -m "Pull from Overleaf (paper)"

pull-presentation:
	git fetch overleaf-presentation master && \
	git checkout overleaf-presentation/master -- . && \
	mkdir -p presentation && \
	(test -e main.tex && git mv main.tex presentation/main.tex || true) && \
	(test -e main.pdf && git mv main.pdf presentation/main.pdf || true) && \
	(test -d figures  && git mv figures  presentation/figures  || true) && \
	(test -d archive  && git mv archive  presentation/archive  || true) && \
	git commit -m "Pull from Overleaf (presentation)"
