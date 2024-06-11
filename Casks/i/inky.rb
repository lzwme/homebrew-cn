cask "inky" do
  version "0.15.0"
  sha256 "e11b90b8723417a85792f8233384e9240bb0ec84d729a3da9d69d873a1b5563c"

  url "https:github.cominkleinkyreleasesdownload#{version}inky.dmg",
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