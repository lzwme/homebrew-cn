cask "devtoys" do
  arch arm: "arm64", intel: "x64"

  version "2.0.4.0"
  sha256 arm:   "9dbaf65cf5059da45fec0b6669b22df06e7b24de343c648cc5fda89ceffeb4c3",
         intel: "e75d28c52cdd3f672fe6c56bf995ca5b2229e43dad8a18b2438c90c7c79df8a2"

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