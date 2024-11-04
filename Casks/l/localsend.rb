cask "localsend" do
  version "1.16.0"
  sha256 "08f01c545430905c76f01957270f1d1016472eaf9fd0351d12d586582d834bca"

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