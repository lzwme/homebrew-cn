cask "devtoys" do
  arch arm: "arm64", intel: "x64"

  version "2.0.3.0"
  sha256 arm:   "2549fe01c482a4b0c19f623d4ddef4283ca8148841ca066bc85f8eaeb950e995",
         intel: "061fefeeade8541a874cd743766dc503741e8ed1fcaf8cfa5a5ba8269350a375"

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