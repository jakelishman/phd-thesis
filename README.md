# Robust Coherence and Entanglement Creation in Trapped Ions

This is my PhD thesis.


## Building the thesis

This was only ever really meant to build on my personal computers.
The program requirements (without modification of the Makefile) are:

- GNU `make`
- `sed` - standard POSIX `sed` should work fine; it's not used for much.
- `pdflatex`, `bibtex` and `latexmk`.  The LaTeX packages required are a reasonably full-featured set.  I used the versions from TeX Live 2022/dev.
- `pdfcrop` - should also come with a TeX distribution.  I used 2020/06/06 v1.40.
- GhostScript (as `gs`) - I used 9.55.0
- `gnuplot`: I used 5.4p3
- [`pdfsizeopt`](https://github.com/pts/pdfsizeopt), with image optimisers [`sam2p`](https://github.com/pts/sam2p), [`jbig2`](https://github.com/pts/pdfsizeopt-jbig2) and [`pngout`](http://www.jonof.id.au/kenutils.html).   I installed `pdfsizeopt` using both the macOS and Windows installation instructions in the README as of [commit 33ec5e5](https://github.com/pts/pdfsizeopt/tree/33ec5e5).  `pdfsizeopt` (and the optimisers) aren't really necessary for building the thesis if the relevant line is removed from the Makefile, they just automatically subset and merge all the relevant fonts and optimise the few raster images present to bring down the file size.

With all the requirements in place, the thesis can be built with
```
make thesis
```

(Or potentially `gmake thesis`, depending on how GNU make is installed.)
This is also a regular incremental Makefile, so re-running `make thesis` should mostly only rebuild the components that are required.

After build, the thesis is called `thesis.pdf`.

Tables 3.1 and 3.2 are generated using the Python file `python/ioneqm.py`, by calling the functions `eqms_table` and `modes_table` respectively.
This file requires only Python, Numpy and Scipy.
A known working combination is Python 3.9, Numpy 1.23 and Scipy 1.9, but relatively few features from any of these are used, so likely much older and more recent Numpys and Scipys will work fine.


## Licence

The text in the thesis was all completely created by me, and is licensed under the [Creative Commons Attribution 4.0 International licence](https://creativecommons.org/licenses/by/4.0/), with the full text in the file `CONTENT_LICENCE`.
As noted in the thesis text (in `thesis.tex`) in the "Copyright" section, some of the figures are derived from lightly modified sources of works whose copyright is assigned to the American Physical Society.
The relevant are noted and are properly cited back to their corresponding articles in various Physical Review journals from within the thesis text.
These figures cannot be reproduced elsewhere other than by following the [terms of the APS' licensing policies](https://journals.aps.org/copyrightFAQ.html).
The other figures and tables in the text are entirely my copyright, and are licensed under the same CC-BY-4.0 licence as the text.

Except where specifically noted in the relevant files (such as `style.bst`), the code used to write and build the thesis that is stored in this respository was also all created by me, and is licensed under the MIT licence with full text in the file `CODE_LICENCE`.
