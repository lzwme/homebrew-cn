cask "ueli" do
  arch arm: "-arm64"

  version "9.7.0"
  sha256 intel: "a13f691d1be7c6ae99b441c7b6f6165858f156d20c2b6898853f5a7cfed76d5b",
         arm:   "8cb6dd9e449b03666c57a656ac23a3e15802819db78088dd0f3e68ed66e52c62"

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