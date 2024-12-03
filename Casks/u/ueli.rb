cask "ueli" do
  arch arm: "-arm64"

  version "9.11.0"
  sha256 intel: "0ed72f3429c80d0946017dccc964c200afcf20b059b1bca3eb80858340630acd",
         arm:   "a7bf6f30a30666f78a767ca9873d11a2b7e4d05acdddc15f4dfbd95052885246"

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