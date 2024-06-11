cask "ueli" do
  version "8.29.0"
  sha256 "a318667a9ea75cb50eafc02ec7f416a9a91d9a675e085d3e4b7c91c8a7769868"

  url "https:github.comoliverschwendeneruelireleasesdownloadv#{version}ueli-#{version}.dmg",
      verified: "github.comoliverschwendenerueli"
  name "Ueli"
  desc "Keystroke launcher"
  homepage "https:ueli.app"

  livecheck do
    url :url
    strategy :github_latest
  end

  app "ueli.app"

  uninstall quit: "ueli"

  zap trash: [
    "~LibraryApplication Supportueli",
    "~LibraryLogsueli",
    "~LibraryPreferencescom.electron.ueli.plist",
  ]
end