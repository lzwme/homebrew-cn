cask "menubar-colors" do
  version "2.3.0"
  sha256 "b12188d45b57ae8614d9fc25d97c8302936916655ac6c8b19b9ca629c9ee7367"

  url "https:github.comnvzqzmenubar-colorsreleasesdownloadv#{version}Menubar-Colors.zip"
  name "Menubar Colors"
  desc "Menu bar app for convenient access to the system colour panel"
  homepage "https:github.comnvzqzMenubar-Colors"

  no_autobump! because: :requires_manual_review

  deprecate! date: "2024-07-27", because: :unmaintained

  app "Menubar Colors.app"

  uninstall quit: "com.nikolaivazquez.Menubar-Colors"

  zap trash: [
    "~LibraryCachescom.nikolaivazquez.Menubar-Colors",
    "~LibraryPreferencescom.nikolaivazquez.Menubar-Colors.plist",
  ]

  caveats do
    requires_rosetta
  end
end