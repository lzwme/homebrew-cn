cask "devtoys" do
  arch arm: "arm64", intel: "x64"

  version "2.0.7.0"
  sha256 arm:   "fe8a8e5d378495a5ec3368f5634e6b03db60f2e33d1d97c78b16139f70c31932",
         intel: "8c67eac087b3d0ac220c2182a772630027baa1ad847d26a2c65b137b251a1dde"

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