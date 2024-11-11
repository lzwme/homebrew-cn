cask "devtoys" do
  arch arm: "arm64", intel: "x64"

  version "2.0.6.0"
  sha256 arm:   "feb60c02590c1d11e14c67af9e14d32f3a2d5a3bde53800841e3d801d64ec8f8",
         intel: "a5d3783608dbe8a01e2c08cd8e01ab684027bf2871de595a8c80668d147320e6"

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