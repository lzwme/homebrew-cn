cask "localsend" do
  version "1.17.0"
  sha256 "fdf1a42ee13eb9fdd6ae94dc5883981e8a09599e758bde23f6e677c4fab5c93c"

  url "https:github.comlocalsendlocalsendreleasesdownloadv#{version}LocalSend-#{version}.dmg",
      verified: "github.comlocalsendlocalsend"
  name "LocalSend"
  desc "Open-source cross-platform alternative to AirDrop"
  homepage "https:localsend.org"

  depends_on macos: ">= :big_sur"

  app "LocalSend.app"

  zap trash: [
    "~LibraryApplication Scriptsorg.localsend.localsendApp",
    "~LibraryContainersorg.localsend.localsendApp",
    "~LibraryPreferencesorg.localsend.localsendApp.plist",
    "~LibrarySaved Application Stateorg.localsend.localsendApp.savedState",
  ]
end