# The ableC extension to Silver: silver-ableC

This extension to Silver allows ableC extension writers to express
complex ASTs by writing C code directly using its concrete syntax,
instead of manually writing complex expressions over its abstract
syntax.  For example, the new Silver expression

```
ableC_Stmt {
  int a = 1;
  int b = 2;
  return a + b;
}
```
is equivalent to writing
```
seqStmt(declStmt(variableDecls(...)), seqStmt(declStmt(variableDecls(...)), returnStmt(addExpr(...))))
```

This saves a tremendous amount to time for extension developers and
signficantly lowers the bar to entry into these efforts.

## Authors
- Lucas Kramer, University of Minnesota, krame505@umn.edu
- Eric Van Wyk, University of Minnesota, evw@umn.edu,
  ORCID: https://orcid.org/0000-0002-5611-8687

## Releases
- Release 0.1.0: made in April, 2020

## Related publications

Release 0.1.0 is discussed in the paper "Reflection of Terms in
Attribute Grammars: Design and Applications" by Lucas Kramer, Ted
Kaminski, and Eric Van Wyk.  At the time of release this paper has
been submitted to the Journal of Computer Languages (COLA).

It is an extension of ``Reflection in Attribute Grammars'' by the same
authors, presented at the 2019 ACM SIGPLAN
International Conference on Generative Programming: Concepts &
Experiences (GPCE).  See DOI https://doi.org/10.1145/3357765.3359517.


## More Information
More documentation:
* [Quick guide to silver-ableC](Quick_Guide.md)
* [Getting started with using the extension](GETTING_STARTED.md)
* [How it works](IMPLEMENTATION.md)

Some ableC extensions using this extension:
* [ableC-closure](https://github.com/melt-umn/ableC-closure)
* [ableC-vector](https://github.com/melt-umn/ableC-vector)
* [ableC-nondeterministic-search](https://github.com/melt-umn/ableC-nondeterministic-search)
* [ableC-algebraic-data-types](https://github.com/melt-umn/ableC-algebraic-data-types)

## Websites and repositories

Software downloads, documentation, and related papers are available on the
Melt group web site at http://melt.cs.umn.edu/.

Actively-developed versions of this software are available on GitHub at
https://github.com/melt-umn/silver-ableC.

Archival versions of this software are permanently available on the Data
Repository of the University of Minnesota at https://doi.org/10.13020/D6QX07.

Other software and artifacts are also archived there and can be
reached from this persistent link: http://hdl.handle.net/11299/206558.


## Acknowledgements
We are very grateful to the National Science Foundation, the McKnight
Foundation, DARPA, the University of Minnesota, and IBM for funding
different aspects of our research and the development of Silver and
Copper.


## Licensing 
Silver-ableC is distributed under the GNU Lesser General Public
License.  See the file LICENSE for details of this licenses.  More
information can be found at http://www.gnu.org/licenses/.
