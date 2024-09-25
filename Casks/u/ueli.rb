cask "ueli" do
  arch arm: "-arm64"

  version "9.6.0"
  sha256 intel: "6ec1e1bb73e7fbf0b7b52eca4c11925d91b4de32f6f610b16b6caf96f4fddf41",
         arm:   "341345891fe8492fcecd7ec02b22f34d1ad7c89cb06ef8e71c31d3c71f24f0fd"

  url "https:github.comoliverschwendeneruelireleasesdownloadv#{version}Ueli-#{version}#{arch}.dmg",
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