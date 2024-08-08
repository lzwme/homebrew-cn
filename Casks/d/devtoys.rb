cask "devtoys" do
  arch arm: "arm64", intel: "x64"

  version "2.0.5.0"
  sha256 arm:   "34742eb7e10652044599ca08ccef174cf84e804513fd9ae2522c1229b9e36cf3",
         intel: "9f9e31d64330349538a61a635ccae758c7ad850a94de12f40df24ab7acb522ab"

  url "https:github.comDevToys-appDevToysreleasesdownloadv#{version}devtoys_osx_#{arch}.zip"
  name "DevToys"
  desc "Utilities designed to make common development tasks easier"
  homepage "https:github.comDevToys-appDevToys"

  depends_on macos: ">= :monterey"

  app "DevToys.app"

  zap trash: [
    "~LibraryCachescom.devtoys",
    "~LibraryCachescom.devtoys.preview",
    "~LibraryPreferencescom.devtoys.plist",
    "~LibraryPreferencescom.yuki.DevToys.plist",
    "~LibraryWebKitcom.devtoys",
    "~LibraryWebKitcom.devtoys.app",
  ]
end