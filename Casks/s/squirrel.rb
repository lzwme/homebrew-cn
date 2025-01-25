cask "squirrel" do
  version "1.0.3"
  sha256 "ceb45dde93fe31e090ca3ea982d90255ee59bd66225354d0750b56bfc2b3b0a4"

  url "https:github.comrimesquirrelreleasesdownload#{version}Squirrel-#{version}.pkg",
      verified: "github.comrimesquirrel"
  name "Squirrel"
  desc "Rime input method engine"
  homepage "https:rime.im"

  livecheck do
    url "https:rime.github.ioreleasesquirrelappcast.xml"
    strategy :sparkle
  end

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