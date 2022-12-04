MAINFILE=thesis

GSFLAGS=-dBATCH -dNOPAUSE -sDEVICE=pdfwrite -dCompatibilityLevel=1.5 -dSubsetFonts=true -dEmbedAllFonts=true
LATEXMKFLAGS=-pdf -synctex=0 -interaction=nonstopmode -shell-escape

FIGWRAPPER=_wrapper.tex
STYLEFILE=thesis.sty

GNUPLOTFIGDIR=gnuplot
GNUPLOTSRC=$(wildcard $(GNUPLOTFIGDIR)/*.gnuplot)
GNUPLOTFIGURES=$(patsubst $(GNUPLOTFIGDIR)/%.gnuplot,%.pdf,$(GNUPLOTSRC))

TIKZFIGDIR=tikz
TIKZSRC=$(wildcard $(TIKZFIGDIR)/*.tex)
TIKZFIGURES=$(patsubst $(TIKZFIGDIR)/%.tex,%.pdf,$(TIKZSRC))

TIKZ_EXTERNAL_DIR=tikzexternal

.PHONY:
$(MAINFILE): $(MAINFILE).pdf

# Don't specify the tex files as "make" dependencies, because "latexmk" actually
# parses the source for all includes, so is much more accurate about knowing
# when to update the recipe.
$(MAINFILE).pdf: figures $(TIKZ_EXTERNAL_DIR) $(STYLEFILE)
	latexmk $(LATEXMKFLAGS) "$(MAINFILE)"
	# gs $(GSFLAGS) -o "$@.2" "$@"
	pdfsizeopt "$@" "$@.2"
	mv "$@.2" "$@"

.PHONY:
figures: $(GNUPLOTFIGURES) $(TIKZFIGURES)

$(TIKZ_EXTERNAL_DIR):
	mkdir "$(TIKZ_EXTERNAL_DIR)"

$(GNUPLOTFIGURES): %.pdf: $(GNUPLOTFIGDIR)/%.gnuplot $(FIGWRAPPER) $(STYLEFILE)
	rm -f "$@"
	cd "$(GNUPLOTFIGDIR)" && gnuplot "$$(basename $<)"
	wrapper=".wrapper_$$(basename $@).tex"; \
			cd "$(GNUPLOTFIGDIR)" \
			&& sed 's#__INPUT__#${@:.pdf=.tex}#' "../$(FIGWRAPPER)" >"$$wrapper" \
			&& TEXINPUTS="..//;" latexmk $(LATEXMKFLAGS) "$$wrapper" \
			&& mv "$${wrapper%.tex}.pdf" "../.$@.cropped" \
			&& latexmk -pdf -C "$$wrapper" \
			&& rm -f "$$wrapper"
	#gs $(GSFLAGS) -o "$@" ".$@.cropped"
	#rm -f ".$@.cropped"
	mv ".$@.cropped" "$@"

$(TIKZFIGURES): %.pdf: $(TIKZFIGDIR)/%.tex $(FIGWRAPPER) $(STYLEFILE)
	wrapper=".wrapper_$$(basename $@).tex"; \
			sed 's#__INPUT__#$<#' "$(FIGWRAPPER)" >"$$wrapper" \
			&& latexmk $(LATEXMKFLAGS) "$$wrapper" \
			&& pdfcrop "$${wrapper%.tex}.pdf" ".$@.cropped" \
			&& latexmk -pdf -C "$$wrapper" \
			&& rm -f "$$wrapper"
	#gs $(GSFLAGS) -o "$@" ".$@.cropped"
	#rm -f ".$@.cropped"
	mv ".$@.cropped" "$@"

.PHONY:
tidy:
	latexmk -pdf -c
	rm -f "$(MAINFILE).brf" "$(MAINFILE).bbl"

.PHONY:
clean: tidy
	latexmk -pdf -C
	rm -f "$(MAINFILE).bbl"
	rm -f $(TIKZFIGURES) $(GNUPLOTFIGURES)
	rm -rf "$(TIKZ_EXTERNAL_DIR)"
