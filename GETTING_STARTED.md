# Getting Started

## Installation
This extension depends on Silver and ableC, and so both of these repos must be cloned.  In addition, the default composed artifact also includes ableC-closure, ableC-refcount-closure, and ableC-templating, so these repositories are also needed if using the default build.  The build scripts expect silver and ableC to be cloned in a top-level workspace also including an `extensions` directory that contains silver-ableC and the ableC extensions:

    |-- silver/
    |-- ableC/
    |-- extensions/
        |-- ableC-closure/
        |-- ableC-refcount-closure/
        |-- ableC-templating/
        |-- silver-ableC/

First ensure that Silver is installed correctly and up to date by running `./update && ./self-compile` in the `silver/` repository, and ensure that the `silver` and `silver-custom` scripts have been installed by running `./support/bin/install-silver-bin`.  

To compile the default composition of silver-ableC from a fresh installation, run `./bootstrap-compile`.  As the ableC-closure and ableC-refcount-closure both utilize the new syntax of silver-ableC, a multi-step compilation process is needed.  This script does the following steps:
1. Build silver + silver-ableC with "vanilla" Silver
2. Build silver + silver-ableC + ableC extensions using the result of 1
3. Clean build silver + silver-ableC + ableC extensions using the result of 2, to ensure nothing went wrong

Once this "bootstrapped" compiler has been built, when any components are updated a fresh bootstrapped build isn't needed, instead the faster `./self-compile` script can be used, which only performs a single cycle of compilation using the existing composed compiler.  

The `silver-ableC` script can be installed globally, similarly to `silver`, by running `./support/bin/install-silver-bin`.  

## Using the Extension
To use silver-ableC extension in creating an ableC extension, it is sufficient to simply replace all uses of the `silver` command with `silver-ableC` throughout the build scripts.  Further information on the syntax of the extension, and links to example ableC extensions using silver-ableC, may be found in [README.md](README.md).  

## Alternative Compositions
When building an ableC extension on existing extension(s), it may be useful to include the existing extension(s) in the composition of Silver.  If such a base extension exists within the MELT organization and may be considered commonly useful, then we may consider adding it to the default silver-ableC `with_all` artifact.  

Otherwise, to create a new composition of silver-ableC, it is sufficient to create a new artifact with the required ableC extensions, and duplicate the `self-compile` script (and possibly also the `bootstrap-compile` script, if included extensions also require silver-ableC.)  The compiled jar file may then be invoked as `silver-custom [silver_composed].jar [usual arguments to silver]`.  
