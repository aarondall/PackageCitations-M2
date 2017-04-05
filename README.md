<!-- MarkdownTOC -->

- [PackageCitations-M2][packagecitations-m2]
	- [Functionality][functionality]
	- [Advice for package creators][advice-for-package-creators]

<!-- /MarkdownTOC -->

<a name="packagecitations-m2"></a>
# PackageCitations-M2
a Macaulay2 software package for obtaining bibtex entries for Macaulay2 packages

The following is, as of 2015 04 05, slightly outdated. A new `README` will be ready in short order. For the time being see the proof of concept pdf [here](https://github.com/aarondall/PackageCitations-M2/blob/master/proofOfConcept/testCite.pdf).

<a name="functionality"></a>
## Functionality ##
The `PackageCitations` package has precisely one method: `cite`. For a Macaulay2 package `P`, calling `cite P` produces a string that can be copied into a bibtex bibliography. If the package `P` is `certified` then the result is a reference to the journal article certifying `P`. For example, the `Binomials` package is certified and calling `cite` on it yields the following:

	i1 : cite "Binomials"

	o1 = @article{Binomials,
	       title = {Decompositions of binomial ideals},
	       author = {Thomas Kahle},
	       journal = {The Journal of Software for Algebra and Geometry: Macaulay2}
	       volume = {4},
	       year = {2012},
	     }

Notice that we fed `cite` the name of the package in quotes (in M2 speak, as a `string`). This is necessary only when `cite` is being called on a package is that is not loaded in the current session. A result of running `cite "P"` is that the package `P` is loaded.

	i2 : loadedPackages

	o2 = {Binomials, PackageCitations, SimpleDoc, Elimination, LLLBases, ...

If the package `P` is not certified, then `cite P` yields a reference of the form

	@misc{P,
	  author = {author1 and author2 and ...},
	  title = {{P: the headline of P}},
	  howpublished = {Available at \url{https://an/appropiate/url}}
	}

For example, `PackageCitations` is not a certified package so when we call `cite` on it we obtain

	i3 : cite PackageCitations

	o3 = @misc{PackageCitations,
	       title = {{PackageCitations: A \emph{Macaulay2} software package facilitating citation of \emph{Macaulay2} packages}},
	       author = {Aaron Dall},
	       howpublished = {Available at \url{https://github.com/aarondall/PackageCitations-M2}}
	     }

Note that we didn't need to wrap `PackageCitations` in quotes when we called `cite` on it because it was already loaded. At the moment this package is not part of the `M2` distribution, so `cite` provides the link to the source code given by the `HomePage` key in the options table of the package. Here's the full option table.

	OptionTable{Authors => {{Name => Aaron Dall, Email => aaronmdall -at- gmail.com, HomePage => https://www.aarondall.com}}}
	            AuxiliaryFiles => false
	            CacheExampleOutput => null
	            Certification => null
	            Configuration => OptionTable{}
	            Date => 2017 03 28
	            DebuggingMode => false
	            Headline => A Macaulay2 software package facilitating citation of Macaulay2 packages
	            HomePage => https://github.com/aarondall/PackageCitations-M2
	            InfoDirSection => Macaulay2 and its packages
	            PackageExports => {}
	            PackageImports => {}
	            Reload => false
	            Version => 0.1


<a name="advice-for-package-creators"></a>
## Advice for package creators ##

Here we offer some guidelines so that the `cite` method will work out of the box with an (uncertified) package "Foo". Let's look at a typical OptionTable for a package and define some nomenclature.

    newPackage (
        "Foo", -- the name of your package in upper CamelCase
        Version => "0.1", -- the version of your package
        Date => "YYYY MM DD", -- the date of this version
        Authors => { -- a list of authors' data (see note below)
            {Name => "Author1", Email => "author1@email.net", HomePage => "https://www.author1.com"},
            {Name => "Author2", Email => "author2@email.net", HomePage => "https://www.author2.com"}},
        Headline => "Brief description of Package", -- the headline of your package
        DebuggingMode => false,
        HomePage => "https://github.com/aarondall/PackageCitations-M2" -- the homepage of your package
        )

The method cite will then make a citation of the form

    @misc{PackageCitations,
           title = {{PackageCitations: $Gr_{m,n}$ is $\triangle$ not $\int$}},
           author = {Aaron Dall},
           howpublished = {Available at \url{https://github.com/aarondall/PackageCitations-M2}}
         }

In keeping with M2 style guidelines, the name of your package should be in CamelCase.

