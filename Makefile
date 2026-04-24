# v1.0
.PHONY: all presentation paper clean push-paper push-presentation \
        pull-paper pull-presentation

OUTDIR := output

all: presentation paper

$(OUTDIR):
	mkdir -p $(OUTDIR)

presentation: $(OUTDIR)
	latexmk -cd -pdf presentation/main.tex
	cp presentation/main.pdf $(OUTDIR)/presentation.pdf

paper: $(OUTDIR)
	latexmk -cd -pdf paper/main.tex
	cp paper/main.pdf $(OUTDIR)/paper.pdf

clean:
	latexmk -cd -C presentation/main.tex
	latexmk -cd -C paper/main.tex
	rm -rf $(OUTDIR)

# ── Overleaf push ─────────────────────────────────────────────────────────────
push-paper:
	git push overleaf-paper paper:master

push-presentation:
	git push overleaf-presentation presentation:master

# ── Overleaf pull ─────────────────────────────────────────────────────────────
# Fast-forwards the local branch to Overleaf's tip without checking it out.
pull-paper:
	git fetch overleaf-paper master && \
	git merge-base --is-ancestor paper overleaf-paper/master && \
	git update-ref refs/heads/paper overleaf-paper/master

pull-presentation:
	git fetch overleaf-presentation master && \
	git merge-base --is-ancestor presentation overleaf-presentation/master && \
	git update-ref refs/heads/presentation overleaf-presentation/master
