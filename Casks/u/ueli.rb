cask "ueli" do
  arch arm: "-arm64"

  version "9.0.1"
  sha256 intel: "4c17bdee3365ebd76801fbfbc45e9895119aeff604f53059cba2d930c9ed3b5d",
         arm:   "3ea010fe3d8d7c91c310bc601260cb4f7bc33ad647039657da0d33ce3ff4d60a"

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