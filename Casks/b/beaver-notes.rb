cask "beaver-notes" do
  version "3.8.0"
  sha256 "c7680d03949fcf890fcfc94adfcda0dc231501581ad4d713d788c02ebadd666c"

  url "https:github.comBeaver-NotesBeaver-Notesreleasesdownload#{version}Beaver-notes-#{version}-universal.dmg",
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