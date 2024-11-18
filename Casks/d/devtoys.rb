cask "devtoys" do
  arch arm: "arm64", intel: "x64"

  version "2.0.8.0"
  sha256 arm:   "98d2c97c9a06496657e7ffb67273f8fb44d446a3c000d22de4b6a94d9b3debc7",
         intel: "16408e9b10db408dc529882570e982cc08a212f89ef592d61c591ba30b4da977"

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