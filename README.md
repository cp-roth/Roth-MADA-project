# Overview

A template file and folder structure for a data analysis project/paper done with R/Quarto/Github. 

This is Cassia Roth's class project repository.

# Template structure

* All data goes into the subfolders inside the `data` folder.
* All code goes into the `code` folder or subfolders.
* All results (figures, tables, computed values) go into `results` folder or subfolders.
* All products (manuscripts, supplement, presentation slides, web apps, etc.) go into `products` subfolders.
* The `renv` folder is automatically generated by the `renv` package, and is
used to keep track of packages.
* See the various `README.md` files in those folders for some more information.

You can read about keeping track of projects with `renv`
[here](https://rstudio.github.io/renv/articles/renv.html).
Basically, whenever you install new packages or update old packages, you need
to run `renv::snapshot()` to update the `renv.lock` file, which is a list of
packages and versions that the package uses. When you open the R project on a
new computer, you can run `renv::restore()` to reinstall all the packages that
you recorded in the `renv.lock` file.


