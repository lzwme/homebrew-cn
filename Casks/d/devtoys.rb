cask "devtoys" do
  arch arm: "arm64", intel: "x64"

  version "2.0.1.0"
  sha256 arm:   "15b81d500ec20f608abf837acdc52c1fd6d22163de789c72683e5fc166808ec5",
         intel: "f397473471b1b9cae40ae005912c096bd4cda8572325bd0d515a07fbf6a6b1a6"

  url "https:github.comDevToys-appDevToysreleasesdownloadv#{version}devtoys_osx_#{arch}.zip"
  name "DevToys"
  desc "Utilities designed to make common development tasks easier"
  homepage "https:github.comDevToys-appDevToys"

  depends_on macos: ">= :catalina"

  app "DevToys.app"

  zap trash: [
    "~LibraryCachescom.devtoys.preview",
    "~Librarycom.devtoys.preview",
    "~LibraryPreferencescom.devtoys.plist",
    "~LibraryPreferencescom.yuki.DevToys.plist",
    "~LibraryWebKitcome.devtoys.app",
  ]
end