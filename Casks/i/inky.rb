cask "inky" do
  version "0.15.1"
  sha256 "75a8a28202a093a3ba5f6d8e66137f4208df5705aed420af0d460fe6efb2252f"

  url "https:github.cominkleinkyreleasesdownload#{version}inky.dmg",
      verified: "github.cominkleinky"
  name "Inky"
  desc "Editor for ink: inkle's narrative scripting language"
  homepage "https:www.inklestudios.comink"

  livecheck do
    url :url
    strategy :github_latest
  end

  no_autobump! because: :requires_manual_review

  depends_on macos: ">= :catalina"

  app "Inky.app"

  zap trash: [
    "~LibraryApplication SupportInky",
    "~LibraryLogsInky",
    "~LibraryPreferencescom.inkle.inky.helper.plist",
    "~LibraryPreferencescom.inkle.inky.plist",
    "~LibrarySaved Application Statecom.inkle.inky.savedState",
  ]
end