cask "inky" do
  version "0.14.1"
  sha256 "95a99301939ed16ef4602b6eba1cd754df1ecb521750e366871b12988f024115"

  url "https:github.cominkleinkyreleasesdownload#{version}Inky_mac.dmg",
      verified: "github.cominkleinky"
  name "Inky"
  desc "Editor for ink: inkle's narrative scripting language"
  homepage "https:www.inklestudios.comink"

  livecheck do
    url :url
    strategy :github_latest
  end

  app "Inky.app"

  zap trash: [
    "~LibraryApplication SupportInky",
    "~LibraryLogsInky",
    "~LibraryPreferencescom.inkle.inky.helper.plist",
    "~LibraryPreferencescom.inkle.inky.plist",
    "~LibrarySaved Application Statecom.inkle.inky.savedState",
  ]
end