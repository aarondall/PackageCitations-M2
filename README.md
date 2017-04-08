<a name="packagecitations-m2"></a>
# PackageCitations-M2
A [Macaulay2][M2] software package for obtaining [bibtex][bib] entries of Macaulay2 packages for inclusion in [LaTeX][latex] documents.

	* [Functionality](#functionality)
	   * [Citing Macaulay2](#citing-macaulay2)
	   * [Citing a loaded package](#citing-a-loaded-package)
	   * [Citing unloaded packages](#citing-unloaded-packages)
	* [Advice for package creators](#advice-for-package-creators)
	   * [Titles in CamelCase](#titles-in-camelcase)
	   * [Headlines: Short and Descriptive](#headlines-short-and-descriptive)
	   * [Authors](#authors)
	   * [Package HomePage](#package-homepage)

<a name="functionality"></a>
## Functionality ##
The `PackageCitations` package has precisely one command: `cite`.

### Citing Macaulay2 ###

When called without an argument, `cite` produces the desired reference to Macaulay2.

	i1 : cite

	o1 = @misc{M2,
	       author = {Grayson, Daniel R. and Stillman, Michael E.},
	       title = {Macaulay2, a software system for research in algebraic geometry},
	       howpublished = {Available at \url{http://www.math.uiuc.edu/Macaulay2/}}
	     }

### Citing a loaded package ###
When applied to a loaded package `cite` returns a bibtex citation for inclusion in a `LaTeX` document, assuming there is enough information included in the package to build it. Compare the following.

	i2 : cite PackageCitations

	o2 = @misc{PackageCitationsSource,
				 title = {{PackageCitations: A \emph{Macaulay2} software package facilitating citation of \emph{Macaulay2} packages. Version~0.1}},
				 author = {Aaron Dall},
				 howpublished = {Available at \url{https://github.com/aarondall/PackageCitations-M2}}
			 }


	i3 : cite Text
	Warning: The "Text" package provides insufficient citation data: author.

	o3 = @misc{TextSource,
				 title = {{Text: documentation and hypertext. Version~0.0}},
				 author = {},
				 howpublished = {Available at \url{https://github.com/Macaulay2/M2/tree/master/M2/Macaulay2/packages}}
			 }

### Citing unloaded packages  ###

If `cite` is given a string "Foo", then it will will load the package Foo if necessary and issue the corresponding citation. Note that if the package is *certified* then two bibtex entries will be produced: one for the article witnessing the certification and one for the source code. Moreover, if the headline of a package does not meet a certain set of criteria then a more generic title containing  "A *Macaulay2* package" is produced. For example, the package `PieriMaps` is a certified Macaulay2 package whose headline is deemed too long by the `cite` command.


	i4 : cite "PieriMaps"

	o4 = @misc{PieriMapsSource,
	       title = {{PieriMaps: A \emph{Macaulay2} package. Version~1.0}},
	       author = {Steven V Sam},
	       howpublished = {Available at \url{https://github.com/Macaulay2/M2/tree/master/M2/Macaulay2/packages}}
	     }

	     @article{PieriMapsArticle,
	       title = {{Computing inclusions of Schur modules}},
	       author = {Steven V Sam},
	       journal = {The Journal of Software for Algebra and Geometry: Macaulay2},
	       volume = {1},
	       year = {2009},
	     }


No effort is made to correct apparent typos in the package data. The user is urged to check for correct spelling and grammar.

	i5 : cite "Bruns"

	o5 = @misc{BrunsSource,
	       title = {{Bruns: make a 3-generator ideal with an ``any" resolution. Version~2.0}},
	       author = {David Eisenbud},
	       howpublished = {Available at \url{https://github.com/Macaulay2/M2/tree/master/M2/Macaulay2/packages}}
	     }

<a name="advice-for-package-creators"></a>
## Advice for package creators ##

Here we offer some guidelines so that the `cite` command will work out of the box with an (uncertified) package "Foo". Let's look at a typical OptionTable for a package and define some nomenclature.

		newPackage (
				"Foo", -- the name of your package in upper CamelCase
				Version => "0.1", -- the version of your package
				Date => "YYYY MM DD", -- the date of this version
				Authors => { -- a list of authors' data (see note below)
						{Name => "Author1", Email => "author1@email.net", HomePage => "https://www.author1.com"},
						{Name => "Author2", Email => "author2@email.net", HomePage => "https://www.author2.com"}},
				Headline => "A Macaulay2 package for computing Bar", -- the headline of your package
				HomePage => "https://www.someSite.com/packageHomepage" -- the homepage of your package
				)

The command `cite` will then make a citation of the form

		@misc{Foo,
					 title = {{Foo: A \emph{Macaulay2} package for computing Bar},
					 author = {Author1 and Author2},
					 howpublished = {Available at \url{https://www.someSite.com/packageHomepage}}
				 }

<a name="titles-in-camelcase"></a>
### Titles in CamelCase ###

In keeping with M2 style guidelines, the name of your package should be in CamelCase.

<a name="headlines-short-and-descriptive"></a>
### Headlines: Short and Descriptive ###

Keep package headlines short, descriptive, and `LaTeX`-free. The `cite` command gives a bibtex `title` tag of the form `Name: Headline` as long as the headline of the package satisfies the following conditions:
  1. it has at least one word and no more than 10 words;
  2. it is not a trivial variation of the name of the package; and
  3. it does not contain a colon `:`.
The requirement that a headline be no longer than 10 words is somewhat arbitrary but encourages precision and we hope leaves enough room to be descriptive even if one begins the headline with `A Macaulay2 package for computing ...` or some such phrase. The rationale behind the other two constraints should be rather obvious.

If a headline does not satisfy all of the conditions above a citation will still be produced, but in it the headline will be replaced by the generic `A Macaulay2 package`.

<a name="authors"></a>
### Authors ###

Packages sometimes have "main" authors and "contributing" authors. Only include the main authors in the `Authors` key in the `OptionsTable` of the package. Contributing authors should either be considered as authors (and hence included in the `Authors` key just as any other author is) or credited for their contributions in the documentation of the package and not in the `OptionsTable`.

<a name="package-homepage"></a>
### Package HomePage ###

For packages distributed with Macaulay2, a link to the [GitHub repository](https://github.com/Macaulay2/M2/tree/master/M2/Macaulay2/packages) is given. Authors of an external package should always include a `url` for the current source code of their package.

[M2]: https://github.com/Macaulay2/M2
[bib]: http://www.bibtex.org
[latex]: https://www.latex-project.org