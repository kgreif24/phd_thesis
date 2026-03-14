PROJ := main

SRC  := $(PROJ).tex
DEP  := $(wildcard *.tex chapters/*.tex *.bib) ucithesis.cls

OUT  := .

PDF  := $(OUT)/$(PROJ).pdf

CMDLATEX := lualatex -interaction=nonstopmode -output-directory=$(OUT)

all: $(PDF)

$(PDF): $(SRC) $(DEP)
	$(CMDLATEX) $(SRC)
	-bibtex $(PROJ)
	$(CMDLATEX) $(SRC)
	$(CMDLATEX) $(SRC)

quick:
	$(CMDLATEX) $(SRC)

clean:
	rm -rf $(OUT)/*.aux
	rm -rf $(OUT)/*.bbl
	rm -rf $(OUT)/*.blg
	rm -rf $(OUT)/*.lof
	rm -rf $(OUT)/*.log
	rm -rf $(OUT)/*.lot
	rm -rf $(OUT)/*.out
	rm -rf $(OUT)/*.toc
	rm -rf $(OUT)/*.run.xml
	rm -rf $(OUT)/*.synctex.gz
	rm -rf chapters/*.aux
	rm -rf $(OUT)/$(PROJ).pdf
