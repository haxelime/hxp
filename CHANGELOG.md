1.1.2 (04/11/2019)
------------------

* Added 'lib' to native library search path


1.1.1 (04/11/2019)
------------------

* Improved support for Haxe 4
* Moved internal code style to use the Haxe "formatter" library for consistency


1.1.0 (02/12/2019)
------------------

* Added `System.deleteFile` and `System.renameFile`
* Added `System.makeDirectory` (alias for `System.mkdir`)
* Added `System.readBytes`/`System.readText`
* Added `System.writeBytes`/`System.writeText`


1.0.5 (10/30/2018)
------------------

* Fixed a remaining issue in Haxe 4 preview 5
* Removed Node binaries, moved to `http-server` project


1.0.4 (10/30/2018)
------------------

* Fixed a regression between Haxe 4 preview 4 and Haxe 4 preview 5
* Fixed the behavior of `hxml.hasDefine` and `hxml.getDefine`
* Fixed setting `HXML` boolean arguments to false


1.0.3 (09/25/2018)
------------------

* Improved Haxe version check for script execution to occur on the user machine


1.0.2 (09/20/2018)
------------------

* Improved the default command name to be "default" when unspecified


1.0.1 (08/10/2018)
------------------

* Added `hxp --install-hxp-alias` for installing the `hxp` command alias
* Improved argument order by making script path the first optional argument


1.0.0 (08/06/2018)
------------------

* Initial release