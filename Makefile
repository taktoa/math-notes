.RECIPEPREFIX = >
DISABLED_RULES=WHITESPACE_RULE,COMMA_PARENTHESIS_WHITESPACE,CURRENCY,EN_QUOTES,CURRENCY_SPACE,ENGLISH_WORD_REPEAT_BEGINNING_RULE

proj = Notes

out_dir = out/
fig_dir = figures/
src_dir = src/
msc_dir = misc/
res_dir = result/

pandoc_args = --chapters --toc --no-highlight
pdflatex_args = -halt-on-error -shell-escape

template = $(src_dir)/template.tex
orginput = $(src_dir)/$(proj).org
pandoced = $(out_dir)/$(proj).tex
res_pdf = $(out_dir)/$(proj).pdf

pdflatex = pdflatex.sh
latexmk = latexmk -pdf $(pdflatex_args)
pandoc = cd $(out_dir); \
         pandoc ../$(orginput) \
                -o ../$(pandoced) \
                $(pandoc_args) \
                --template ../$(template); \
         cd ..

lm_command = $(latexmk) ../$(pandoced)
latexmk_command = cd $(out_dir); $(lm_command); cd ..

lm_cont = $(latexmk) -pdflatex="./$(pdflatex)" -pvc ../$(orginput)
latexmk_cont = cd $(out_dir); $(lm_cont); cd ..

out_pl = $(out_dir)/$(pdflatex)
out_fig = $(out_dir)/$(fig_dir)

all: pandoc
> $(latexmk_command)
> make clean

pandoc: $(orginput) $(template) $(out_fig)
> -if [ ! -d $(out_dir) ]; then mkdir $(out_dir); fi
> $(pandoc)

continuous: $(out_pl) pandoc
> $(latexmk_cont); \
  make full-clean

view-latex: $(orginput) $(template) $(out_fig)
> pandoc $(orginput) -t latex --template $(template) \
    | pygmentize -s -l latex \
    | cat -n | less

$(out_pl):
> -if [ ! -d $(out_dir) ]; then mkdir $(out_dir); fi
> cp $(msc_dir)/$(pdflatex) $(out_dir)

$(out_fig):
> -if [ ! -d $(out_dir) ]; then mkdir $(out_dir); fi
> cp -R $(fig_dir) $(out_dir)/

GET_EVINCE_PID = ps | grep evince | grep -o '^[ 0-9]* '

kill-evince:
> -kill $$(${GET_EVINCE_PID}) &>/dev/null || true

clean: kill-evince
> -if [ ! -d $(res_dir) ]; then mkdir $(res_dir); fi
> -cp -p $(res_pdf) $(res_dir) &>/dev/null || true
> -if [ ! -d $(out_dir) ]; then mkdir $(out_dir); fi
> rm -I -rf $(out_dir)/*
> rmdir $(out_dir)

full-clean: clean
> rm -I -f $(res_dir)/*
> rmdir $(res_dir)

test:
> languagetool -d $(DISABLED_RULES) $(orginput)
