cask "ueli" do
  arch arm: "-arm64"

  version "9.3.5"
  sha256 intel: "a28d659ecffda183e6939026063b0fb9addb4fd624db0158f066965827ff7b37",
         arm:   "2921f17cea32a4e1b42ea1d9943677baf0c21bf15eaa8bf34652dee730ac4e46"

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