cask "captain" do
  arch arm: "-arm64"

  version "10.1.0"
  sha256 arm:   "3528a42f3c355e8ebae7a1148106552902fdd251e8436ac628767f60a69aa94e",
         intel: "a9a52030eaf01f40e9f0664474e661f10040f5b03e509bfb10aabfae0e620688"

  url "https:github.comRickWongCaptainreleasesdownloadv#{version}Captain-#{version}#{arch}.dmg",
      verified: "github.comRickWongCaptain"
  name "Captain"
  desc "Manage Docker containers from the menu bar"
  homepage "https:getcaptain.co"

  app "Captain.app"

  zap trash: [
    "~LibraryApplication Supportcaptain",
    "~LibraryPreferencescom.electron.captain.helper.plist",
    "~LibraryPreferencescom.electron.captain.plist",
    "~LibrarySaved Application Statecom.electron.captain.savedState",
  ]
end