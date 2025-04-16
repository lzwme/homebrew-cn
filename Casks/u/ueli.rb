cask "ueli" do
  arch arm: "-arm64"

  version "9.21.1"
  sha256 intel: "f547bd2100a7711031b21e177a881bfa7d96d26bd0741682b1dfce29f0c2a17d",
         arm:   "0682821ebeeb361147cc09b4ff10cf38c23461aa583ea276ef1cfbd356d5b6e3"

  url "https:github.comoliverschwendeneruelireleasesdownloadv#{version}Ueli-#{version}#{arch}.dmg",
      verified: "github.comoliverschwendenerueli"
  name "Ueli"
  desc "Keystroke launcher"
  homepage "https:ueli.app"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on macos: ">= :big_sur"

  app "ueli.app"

  uninstall quit: "ueli"

  zap trash: [
    "~LibraryApplication Supportueli",
    "~LibraryLogsueli",
    "~LibraryPreferencescom.electron.ueli.plist",
  ]
end