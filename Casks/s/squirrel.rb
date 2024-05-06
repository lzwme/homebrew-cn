cask "squirrel" do
  version "0.18"
  sha256 "db8522e83b725e5253da04d41a76ed58eeb39f0aaf1c6e73ac4dba567dcf2286"

  url "https:github.comrimesquirrelreleasesdownload#{version}Squirrel-#{version}.pkg",
      verified: "github.comrimesquirrel"
  name "Squirrel"
  desc "Rime input method engine"
  homepage "https:rime.im"

  auto_updates true

  pkg "Squirrel.pkg"

  uninstall pkgutil: [
              "com.googlecode.rimeime.Squirrel.pkg", # Package name of older versions (< 0.10.0)
              "im.rime.inputmethod.Squirrel",
            ],
            delete:  "LibraryInput MethodsSquirrel.app"

  zap trash: [
    "~LibraryCachescom.googlecode.rimeime.inputmethod.Squirrel",
    "~LibraryCachesim.rime.inputmethod.Squirrel",
    "~LibraryPreferencescom.googlecode.rimeime.inputmethod.Squirrel.plist",
    "~LibraryPreferencesim.rime.inputmethod.Squirrel.plist",
  ]
end