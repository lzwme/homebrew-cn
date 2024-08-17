cask "ueli" do
  arch arm: "-arm64"

  version "9.3.2"
  sha256 intel: "bf7216b649d1fe61f408eb0661a72e82a85cac351e2b8022d70c29eb5ab7806b",
         arm:   "26fb34ee00e34a9359b7ce29ce67a82d80cf28a8291b637a23016d9855881640"

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