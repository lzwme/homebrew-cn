cask "beaver-notes" do
  version "3.7.0"
  sha256 "a4cd9fa4db758507747c32b55c2cc8908ddd0d2e6729033fb5cc7105642e6929"

  url "https:github.comBeaver-NotesBeaver-Notesreleasesdownload#{version}Beaver-notes.dmg",
      verified: "github.comBeaver-NotesBeaver-Notes"
  name "Beaver Notes"
  desc "Privacy-focused note-taking app"
  homepage "https:beavernotes.com"

  depends_on macos: ">= :catalina"

  app "Beaver-Notes.app"

  zap trash: [
    "~LibraryCachescom.danielerolli.beaver-notes",
    "~LibraryPreferencescom.danielerolli.beaver-notes.plist",
    "~LibrarySaved Application Statecom.danielerolli.beaver-notes.savedState",
  ]
end