OVERLEAF_PAPER        ?= # set via: make push-paper OVERLEAF_PAPER=https://git.overleaf.com/...
OVERLEAF_PRESENTATION ?= # set via: make push-presentation OVERLEAF_PRESENTATION=https://git.overleaf.com/...

.PHONY: build-paper build-presentation clean-paper clean-presentation \
        push-paper push-presentation pull-paper pull-presentation

# ── LaTeX ────────────────────────────────────────────────────────────────────
build-paper:
	latexmk -pdf -cd paper/main.tex

build-presentation:
	latexmk -pdf -cd presentation/main.tex

clean-paper:
	latexmk -C -cd paper/main.tex

clean-presentation:
	latexmk -C -cd presentation/main.tex

# ── Overleaf push (subtree) ──────────────────────────────────────────────────
push-paper:
	git subtree push --prefix=paper overleaf-paper master

push-presentation:
	git subtree push --prefix=presentation overleaf-presentation master

# ── Overleaf pull (subtree merge) ───────────────────────────────────────────
pull-paper:
	git subtree pull --prefix=paper overleaf-paper master --squash

pull-presentation:
	git subtree pull --prefix=presentation overleaf-presentation master --squash
