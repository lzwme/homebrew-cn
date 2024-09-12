cask "ueli" do
  arch arm: "-arm64"

  version "9.5.0"
  sha256 intel: "165c9e4bf75d2c949be65da0c85325afd149f51a007e6e84431cfb959ddfc188",
         arm:   "78d09d8a962bca1d0354eb673698ed69b8a430626491e52880da225d74018ff0"

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