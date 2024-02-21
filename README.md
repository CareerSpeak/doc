# App for Resume-Based Job Matching with Speech Interviews and Grammar Analysis: A Review

This is the source-code for our review article published online on [arXiv](https://arxiv.org/abs/2311.14729) and offline in our college's Chaitanya Magazine.

## Compiling

[Make](https://www.gnu.org/software/make/) and [Pandoc](https://github.com/jgm/pandoc) are used for compiling the metadata and markdown files into LaTeX. [pdfTeX](https://ctan.org/pkg/pdftex) and [BibTeX](https://ctan.org/pkg/bibtex) from [TeX Live](https://tug.org/texlive/) is used for generating the final PDF and resolving citations.

The Pandoc filter [pandoc-crossref](https://github.com/lierdakil/pandoc-crossref) is used for numbering figures and references.

Note: Make sure that you are using the same version of Pandoc that pandoc-crossref was compiled with.

The formatting of the paper can be arbitrarily changed without changing the content using the `template.latex` file in the `templates` directory.

Options for Pandoc, such as `link-citations` can be specified through the `metadata.yaml` file.

The citation style can be specified using a CSL file in the root directory called `citation-style.csl`. By default, it uses the [IEEE style](http://www.zotero.org/styles/ieee) from the [Zotero Style Repository](https://www.zotero.org/styles/).

### Compiling Using Make

Make has a recipe to create a PDF file of arbitrary name using:

```shell
make $(paper_name).pdf
```

A final ZIP file, which can be used for publishing the paper, is compiled using:

```shell
make publish
```

The `cleanIntermediates` recipe removes the `intermediates` folder, which is used as a temporary directory for generating PDF with pdfTeX and BibTeX.

```shell
make cleanIntermediates
```

Everything inside the `build` directory can be removed for a clean build using:

```shell
make clean
```

### Compiling Using Visual Studio Code Tasks:

The `make` commands can be invoked from tasks in [Visual Studio Code](https://code.visualstudio.com/) using the Command Palette. The default keyboard shortcuts for the command Palette are <kbd>F1</kbd> and <kbd>Ctrl</kbd> + <kbd>Shift</kbd> + <kbd>P</kbd>.

These tasks can also be used from the 'Run and Debug' menu. It will also open the generated PDF file in Visual Studio Code automatically after compiling.

## Citation

You can cite this article using the following BibTeX citation:

```bibtex
@article{review_resume_job_interview,
    title={App for Resume-Based Job Matching with Speech Interviews and Grammar Analysis: A Review},
    author={Tanmay Kulkarni and Yash Shah and Yuvraj Pardeshi and Vaishnvi Sakat and Sapana Bhirud},
    year={2023},
    journal={Chaitanya Magazine},
    eprint={2311.14729},
    archivePrefix={arXiv},
    primaryClass={cs.CL},
    pubstate={inpress},
    doi={10.48550/arXiv.2311.14729}
}
```

## Attribution

The `template.latex` is a modified version of the IEEE template from [stsewd/ieee-pandoc-template](https://github.com/stsewd/ieee-pandoc-template)

The `Makefile` automatically downloads the `ieee.csl` file from the [Zotero Styles Repository](https://www.zotero.org/styles/) if no `citation-style.csl` exists in the root directory.
