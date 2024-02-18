cask "qownnotes" do
  version "24.2.5"
  sha256 "48e478149e3d1f305452fc09320f58094862c30b521472df9df925827c1cd888"

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