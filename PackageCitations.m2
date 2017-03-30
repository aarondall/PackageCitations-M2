-- -*- coding: utf-8 -*-
--  PackageCitations.m2
--
--  Copyright (C) 2017 Aaron Dall <aaronmdall@gmail.com>
--
-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--
--  This program is free software; you can redistribute it
--  and/or modify  it under the terms of the GNU General
--  Public License as   published by  the Free Software Found-
--  ation; either version 2 of the License, or (at  your
--  option) any later version.
--
--  This program is distributed in the hope that it will be
--  useful, but  WITHOUT ANY WARRANTY; without even the
--  implied warranty of  MERCHANTABILITY or FITNESS FOR A
--  PARTICULAR PURPOSE.  See the GNU  General Public License
--  for more details.
--
--  You should have received a copy of the GNU General
--  Public License along with this program; if not, write
--  to the Free Software Foundation, Inc.,  59 Temple Place,
--  Suite 330, Boston, MA 02111-1307 USA.
--
-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--
--  Release 0.1 (2017 03)
--      NEW:
--          A method for obtaining a bibtex citation for a Macaulay2 package.
-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
newPackage (
    "PackageCitations",
    Version => "0.1", 
    Date => "2017 03 28",
    Authors => {{
        Name => "Aaron Dall",
        Email => "aaronmdall -at- gmail.com",
        HomePage => "https://www.aarondall.com"}},
    Headline => "A Macaulay2 software package facilitating citation of Macaulay2 packages",
    DebuggingMode => false,
    HomePage => "https://github.com/aarondall/PackageCitations-M2"
    )

export {"cite"}

-- an internal method for checking if a package headline is a good candidate for use in the citation title
-- a good package headline satisfies the following conditions
--  (1) is 10 words or fewer,
--  (2) is not a repeat of the title, and
--  (3) does not contain a colon
hasGoodHeadline = method (TypicalValue => Boolean)
hasGoodHeadline Package := P -> (
    T := P#"title";
    H := P#Options#Headline;
    -- check for a colon in the headline
    if regex(":", H) =!= null then false else
    -- check length of headline
    L := separate (" ", H);
    if #L > 10 then false else
    -- check for nontrivial headline content
    -- first list each word of headline with first letter removed
    reducedHeadline := apply (L, w -> substring (w, 1, #w));
    -- list each word (starting with an upper case letter) of title with first letter removed
    reducedTitle := delete("" ,separate(" ", replace ("[[:upper:]]", " ", T)));
    -- compare reducedTitle and reducedHeadline
    if #reducedHeadline == #reducedTitle and all (
        #reducedTitle,
        i -> isSubset (
                characters reducedHeadline#i,
                characters reducedTitle#i)
            or isSubset (
                characters reducedTitle#i,
                characters reducedHeadline#i)
            )
        then false
    else true
    )


-- the cite method
cite = method (TypicalValue => String)
cite Package := P -> (
    T := P#"title";
    isInternalPackage := member(T, separate (" ", version#"packages"));
    --isInternalSource := substring (0,46, P#"source directory") === prefixDirectory | currentLayout#"packages";
    isInternalSource := P#"source directory" === prefixDirectory | currentLayout#"packages";
    certificationInfo := if P#Options#Certification =!= null then hashTable P#Options#Certification else null;
    -- bibtex author content
    packageAuthors := apply(P#Options#Authors, a -> a#0#1);
    bibPackageAuthors := demark (" and ", packageAuthors);
    if packageAuthors === {}
        then print concatenate ("Warning: no authors associated with package", T)
    else
    -- set up bibtex string for certified packages: easy
    if certificationInfo =!= null
        then (
            bibYear := substring ((regex ("[[:digit:]]{4}", certificationInfo#"acceptance date"))#0, certificationInfo#"acceptance date");
            return concatenate (
                "@article{", T, ",\n",
                    concatenate ("  title = {", certificationInfo#"article title", "},\n"),
                    concatenate ("  author = {", bibPackageAuthors, "},\n"), -- authors
                    concatenate ("  journal = {", certificationInfo#"journal name", "}\n"),
                    concatenate ("  volume = {", certificationInfo#"volume number", "},\n"),
                    concatenate ("  year = {",  bibYear, "},\n"),
                "}\n"))
            else
    -- set up bibtex string for uncertified packages
    -- title
    -- bibtex title content: name of package followed either by a good headline or "A Macaulay2 package"
    bibPackageTitle :=  if hasGoodHeadline P
        then concatenate ("{", T, ": ", replace(" Macaulay2 ", " \\emph{Macaulay2} ", P#Options#Headline), "}")
        else concatenate ("{", T, ": A \\emph{Macaulay2} package}");
    -- bibtex howpublished content
    bibPackageSource :=
        if isInternalPackage and isInternalSource
            then "\\url{https://github.com/Macaulay2/M2/tree/master/M2/Macaulay2/packages}"
        else if isInternalPackage and not isInternalSource
            then if P#Options#HomePage =!= null
                then concatenate("\"", toString (P#Options#HomePage), "\"")
            else "\"\\url{https://github.com/Macaulay2/M2/tree/master/M2/Macaulay2/packages}\""
        else if P#Options#HomePage === null
            then (print concatenate ("Package \"", T, "\" provides insufficient citation data"), null)
        else concatenate("\\url{" ,toString (P#Options#HomePage), "}");
    bibtexString :=
        concatenate (
            "@misc{", T, ",\n",
                concatenate ("  title = {", bibPackageTitle, "},\n"),
                concatenate ("  author = {", bibPackageAuthors, "},\n"),
                concatenate ("  howpublished = {Available at ", bibPackageSource, "}\n"),
            "}\n"
            );
    bibtexString
    )


cite String := S -> (
    if S === "M2" then return (
        concatenate (
            "@misc{M2,\n",
            "  author = {Grayson, Daniel R. and Stillman, Michael E.},\n",
            "  title = {Macaulay2, a software system for research in algebraic geometry},\n",
            "  howpublished = {Available at ", ///\///, "url{http://www.math.uiuc.edu/Macaulay2/}}\n",
            "}\n",
            ))
    else P := loadPackage (S, Reload => true);
    return cite P)  

cite Symbol := S -> (
    cite toString (S))

cite List := L -> scan (L, P -> cite P)


------------------------
-- End of source code --
------------------------

-------------------------
-- Begin documentation --
-------------------------
beginDocumentation()
doc ///
    Key
        PackageCitations
    Headline
        a package facilitating citation of Macaulay2 packages
    Description
        Text
            This is a modest package with lofty goals. It is modest because it is a package for a powerful open-source mathematical software suite but it contains only one method and adds exactly zero computational ability to the platform. The one method, called @TO cite@, can be called on any @HREF {"http://www.math.uiuc.edu/Macaulay2/", "Macaulay2"}@ package and will return a bibtex citation for inclusion in a @HREF {"https://www.latex-project.org", "LaTeX"}@ document. For example, a citation for this package can be obtained as follows.
        Example
            cite PackageCitations    
        Text
            The inner workings of @TO cite@ are explained on the @TO2 {cite, "documentation page"}@ so we won't give any details here except to point out that the preferred citation for Macaulay2 can also be obtained with ease.
        Example
            cite M2        
        Text    
            The initial benefit of having a fast and facile mechanism for citing packages should be that more users of the software will include citations in their work. This, of course, will benefit the community in a number of ways. First it will recognize the hard work of the coders in the Macaulay2 community and second it will serve as valuable promotion for the platform and encourage new users and coders to join the community. 
    SeeAlso
        cite
///

doc ///
    Key
        cite
        (cite, Package)
        (cite, String)
        (cite, Symbol)
        (cite, List)
    Headline
        obtain bibtex citations for Macaulay2 packages
    Usage
        cite (X)
    Inputs
        X:Thing
            either a @TO2 {"packages provided with Macaulay2", "package"}@, a @TO2 {String, "string"}@, a @TO2 {Symbol, "symbol"}@, or a @TO2 {List, "list"}@ of these
    Outputs
        S:String
            bibtex entry or entries
    Description
        Text
            When applied to a loaded package or a list of loaded packages, @TO cite@ returns a bibtex citation for inclusion in a LaTeX document, assuming there is enough information included in the package to build it. The method may somethimes work for unloaded packages, though results vary. The user is strongly encouraged to confirm all data included in a citation. 
        Example
            cite PackageCitations
    SeeAlso
        PackageCitations
///

-- End exported documentation --
-- Begin Tests --
-- End Tests --
end

restart
uninstallPackage "PackageCitations"
installPackage ("PackageCitations", RemakeAllDocumentation => true)
cite Dmodules
cite EdgeIdeals
cite PackageCitations
cite Graphs

loadPackage ("PackageCitations", Reload => true)
cite M2
viewHelp PackageCitations
