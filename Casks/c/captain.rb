cask "captain" do
  arch arm: "-arm64"

  version "10.4.0"
  sha256 arm:   "082e8960c018eb4542f35624cd1300b51c5c965dfb49a90f2761ad1a69d68488",
         intel: "23f8cd8ceafa78d63d21d2fdfa54c89e91442846fcdccecae3a36e70eeaa1e14"

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