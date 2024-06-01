cask "squirrel" do
  version "1.0.1"
  sha256 "5ae733b69f3324e3a8ff5cf2aa426262019dbb907579dfb18064b9b2952f34a9"

  url "https:github.comrimesquirrelreleasesdownload#{version}Squirrel-#{version}.pkg",
      verified: "github.comrimesquirrel"
  name "Squirrel"
  desc "Rime input method engine"
  homepage "https:rime.im"

  auto_updates true
  depends_on macos: ">= :ventura"

  pkg "Squirrel-#{version}.pkg"

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