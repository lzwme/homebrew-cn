cask "localsend" do
  version "1.16.1"
  sha256 "920ab7028ca90dd47093d6ca6b5ce3509a38b471d46c36488341b4464f52de7e"

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