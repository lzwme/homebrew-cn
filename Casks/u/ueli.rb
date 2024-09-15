cask "ueli" do
  arch arm: "-arm64"

  version "9.5.1"
  sha256 intel: "d09f9a8364194b486bb93ddb6fae0df9f55712d038e9b6f20c071ecb5f40b074",
         arm:   "fbb30b0e7a37d676e6c2d3b170a2750a0289aad85ee02526c6ea97d3a9c82746"

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