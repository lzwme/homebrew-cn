cask "qownnotes" do
  version "24.6.2"
  sha256 "c91a5c860e274c1e86f47f883638613b98955dbdefe20c75665f32d723dd2a55"

  url "https:github.compbekQOwnNotesreleasesdownloadv#{version}QOwnNotes.dmg",
      verified: "github.compbekQOwnNotes"
  name "QOwnNotes"
  desc "Plain-text file notepad and todo-list manager"
  homepage "https:www.qownnotes.org"

  livecheck do
    url :url
    strategy :github_latest
  end

  auto_updates true
  depends_on macos: ">= :sierra"

  app "QOwnNotes.app"

  zap trash: [
    "~LibraryPreferencescom.pbe.QOwnNotes.plist",
    "~LibrarySaved Application Statecom.PBE.QOwnNotes.savedState",
  ]
end