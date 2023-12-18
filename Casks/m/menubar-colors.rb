cask "menubar-colors" do
  version "2.3.0"
  sha256 "b12188d45b57ae8614d9fc25d97c8302936916655ac6c8b19b9ca629c9ee7367"

  url "https:github.comnvzqzmenubar-colorsreleasesdownloadv#{version}Menubar-Colors.zip"
  name "Menubar Colors"
  desc "Menu bar app for convenient access to the system color panel"
  homepage "https:github.comnvzqzMenubar-Colors"

  app "Menubar Colors.app"

  uninstall quit: "com.nikolaivazquez.Menubar-Colors"

  zap trash: [
    "~LibraryCachescom.nikolaivazquez.Menubar-Colors",
    "~LibraryPreferencescom.nikolaivazquez.Menubar-Colors.plist",
  ]
end