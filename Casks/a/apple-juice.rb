cask "apple-juice" do
  version "2020.12.0"
  sha256 "32aff8e2b2de61076fca1243091ab6e0166d38b4657afedcf01ae28133b69cae"

  url "https:github.comraphaelhannekenapple-juicereleasesdownload#{version}Apple.Juice.dmg"
  name "Apple Juice"
  desc "Battery gauge that displays the remaining battery time and more"
  homepage "https:github.comraphaelhannekenapple-juice"

  depends_on macos: ">= :sierra"

  app "Apple Juice.app"

  uninstall quit: "io.raphaelhanneken.applejuice"

  zap trash: [
    "~LibraryCachesio.raphaelhanneken.applejuice",
    "~LibraryPreferencesio.raphaelhanneken.applejuice.plist",
  ]
end