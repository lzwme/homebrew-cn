cask "squirrel" do
  version "0.18"
  sha256 "52522e2c5083a718bb7c2d2ed153cb5cfb001e040ef34cbe1b99faa3caf48266"

  url "https:github.comrimesquirrelreleasesdownload#{version}Squirrel-#{version}.pkg",
      verified: "github.comrimesquirrel"
  name "Squirrel"
  desc "Rime input method engine"
  homepage "https:rime.im"

  auto_updates true

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