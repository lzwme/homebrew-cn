cask "qownnotes" do
  version "25.3.4"
  sha256 "3865419baca7cc382b7c31bec2d68be0c7d7e8ce4da817e74690dc12ea9e8e68"

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
  depends_on macos: ">= :high_sierra"

  app "QOwnNotes.app"

  zap trash: [
    "~LibraryPreferencescom.pbe.QOwnNotes.plist",
    "~LibrarySaved Application Statecom.PBE.QOwnNotes.savedState",
  ]

  caveats do
    requires_rosetta
  end
end