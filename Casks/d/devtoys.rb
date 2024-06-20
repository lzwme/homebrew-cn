cask "devtoys" do
  arch arm: "arm64", intel: "x64"

  version "2.0.2.0"
  sha256 arm:   "f2dc1e17356fbc0de2b3a9c28c0ce3acd4fd6d03730ad762a8ef0f9af8882da8",
         intel: "a42316ced458994328170c906182d869b7a4b1fc12f7a0f5a843fbd99620dc05"

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