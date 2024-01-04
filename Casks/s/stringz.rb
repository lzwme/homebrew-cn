cask "stringz" do
  version "0.7.5"
  sha256 "12b4172a1c98802fdadcd22777d6d9574906acdd09184019664fd3aef3edd722"

  url "https:github.commohakaptStringzreleasesdownloadv#{version}Stringz-#{version}.dmg"
  name "Stringz"
  desc "Editor for localizable files"
  homepage "https:github.commohakaptStringz"

  depends_on macos: ">= :catalina"

  app "Stringz.app"

  zap trash: [
    "~LibraryApplication Supportdev.stringz.stringz",
    "~LibraryCachesdev.stringz.stringz",
    "~LibraryPreferencesdev.stringz.stringz.plist",
  ]
end