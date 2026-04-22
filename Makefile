.PHONY: build-paper build-presentation clean-paper clean-presentation \
        push-paper push-presentation pull-paper pull-presentation

# ── Build (run from the paper or presentation branch) ────────────────────────
build-paper:
	latexmk -pdf main.tex

build-presentation:
	latexmk -pdf main.tex

clean-paper:
	latexmk -C main.tex

clean-presentation:
	latexmk -C main.tex

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
