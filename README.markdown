Packager is a very simple package manager to facilitate application
deployments. It consists of simple compressed tar files with descriptors and
install scripts.

Tar files
=========
All non-special files are extracted to the root of the deployment target.

The following files have a special meaning.
    - pkg/info - Package information file
    - pkg/desc - Optional description of the package contents
    - pkg/pre-install  - Executable which is executed before installing
    - pkg/post-install - Executable which is executed after installing
    - pkg/post-initial - Executable which is executed after the first time
                         the package is installed.


Package information file
========================
The pkg/info file is a flat text file with key/value pairs. All keys are
separated from their value with colons.

Example:
    name: frontend-guide-detail
    version: 3.ReleaseName.12
    sha1: 2da2ad0828dacb8e873bd633c7062d89884085c2
    depends: frontend-general
    depends: frontend-language (> 2)
    depends-rpm: php, php-pecl, php-pear


List of keys
============
The following keys can be included in the package information file. Unless
otherwise stated, each field can only appear once in the file.

  * name: Name of the package, used for installing and dependencies.
  * version: Version of the package. To determine which version is higher, the
    version identifiers are split by dashes/dots and the individual parts are
    sorted numerically. So the version 1.Something.2 is lower than
    1.Something.10.
  * sha1: SHA1 hash of the contents of the file minus this line itself. To
    calculate this hash use the following command line from the package root
    directory:
      `find . -type f | xargs cat | grep -v '^sha1: ' | sha1`
  * depends: Coma-separated list of dependencies to other packager packages.
    After each packages an optional version identifier can be included in
    brackets. The version identifier knows about the operators '>', '>=', '<',
    '<=' and '='. This key can be repeated.
  * depends-rpm: The same as depends, but these packages will be installed
    using the 'yum' package manager. Additionally each dependency must be
    specified in a way that yum will understand. So for doing version
    dependencies, use 'name-ver' or similar. See the 'Specifying package
    names' section of the yum man page for allowed names.


Motivation
==========
Packager was developed for local.ch to handle application deployments. We grew
out of simple Subversion-based deployments as servers now have to be able to
pull the current version of all applications. This was hard to achieve with
the current deployment framework which was using Capistrano.

Then the hunt started for a simple tar-based deployment tool. Nothing
appropriate was found as most formats were already way too complex for our
needs.


Installation
============
To install the packger you can execute the following commands:

`
$ cd /tmp
$ git clone git://github.com/local-ch/packager.git packager
$ cd packager
$ cp packager.cfg.dist packager.cfg
$ $EDITOR packager.cfg
$ cd ..
$ sudo mkdir -p /usr/local/lib
$ sudo move packager /usr/local/lib/packager
$ sudo ln -s /usr/local/lib/packager/packager.py /usr/local/bin/packager
`


Configuration
=============
You can edit *source* in *packager.cfg* to point it to your repository.
The log file configured in *registry* will keep track of your installed 
packages.


Host a packager repository
==========================
Given you configured your repository *source* in *packager.cfg* is 
_/packager/latest_, this is the recommended files and folder structure:

  * Put your packages to a folder outside your webroot.
  * You can group packages in subfolders.
  * Name your packages with name and version: ex. *foobar-yyyymmdd.tgz*.
  * Symlink the latest version to *packager/latest* folder inside your 
    webroot.
  * Name your symlinks without the version: ex. foobar.tgz
  * Automate the package upload and 

This keep your packages sortable by name and makes sure you can always 
install the latest version with `$ sudo packager install foobar`.
See also in the example package creation script *create.sh*.