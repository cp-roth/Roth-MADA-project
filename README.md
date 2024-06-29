# Overview

This is Cassia Roth's project repository for a data analysis project done with R/Quarto/GitHub. This is the master README, which supersedes all others in cases of discrepancies. 

If reproducing this analysis, please run code in the following order. `.Qmd` files are the master files, and I prefer you use those.

1) `processingfile-v1.qmd` or `processingcode.R` in the `processing-code` folder;
2) `eda-v1.qmd` or `edacode.R` in the `eda-code` folder;
3) `introanalyis-v1.qmd` or `introanalysis.R` in the `analysis-code` folder;
4) `fullanalysis-v1.qmd` or `fullanalysiscode.R` in the `analysis-code` folder.
5) `Manuscript_Final.qmd1` in the `products`, `manuscript` folder.
7) `Supplement_Cassia.qmd` in the `products`, `manuscript`, `supplement` folder.

In addition, there is a `Manuscript_Draft.qmd` in the `products`, `manuscript` folder, which was the first version of this project.

If you find any discrepancy between .qmd and .R documents, please run the .qmd documents. Please also notify me, so I can fix these mistakes.

# Template structure

* All data goes into the subfolders inside the `data` folder or subfolders.
* All code goes into the `code` folder or subfolders.
* All results (figures, tables, computed values) go into `results` folder or subfolders. All final files will have a _final in the name.
* All products (manuscripts, supplement, presentation slides, web apps, etc.) go into `products` subfolders.
* The `renv` folder is automatically generated by the `renv` package, and is used to keep track of packages.
* See the various `README.md` files in those folders for some more information.

You can read about keeping track of projects with `renv`
[here](https://rstudio.github.io/renv/articles/renv.html).
Whenever you install new packages or update old packages, please run `renv::snapshot()` to update the `renv.lock` file, which is a list of packages and versions that the package uses. When you open the R project on a new computer, you can run `renv::restore()` to reinstall all the packages that you recorded in the `renv.lock` file.