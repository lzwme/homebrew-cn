cask "squirrel" do
  version "0.16.2"
  sha256 "e08d28fd72445bccbdbccc06b16a9e300c07371f67d576cd4ed35731be9d4ad6"

  url "https:github.comrimesquirrelreleasesdownload#{version}Squirrel-#{version}.zip",
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