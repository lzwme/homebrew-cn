cask "ueli" do
  arch arm: "-arm64"

  version "9.0.4"
  sha256 intel: "43af9fbbaf64b110296da04fbf5d1c1d0141fe958746e8c96627cc7a16e111e0",
         arm:   "4b050a637aecc64d1210ba5778acaf95568d328cd5c44523474ebfa9dfc7c43a"

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