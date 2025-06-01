cask "beaver-notes" do
  version "4.0.0"
  sha256 "633630cb1d8b96df25edb4dd8328910f61d53c19370d8344fb65642303a45d7c"

  url "https:github.comBeaver-NotesBeaver-Notesreleasesdownload#{version}Beaver-notes-#{version}-universal.dmg",
      verified: "github.comBeaver-NotesBeaver-Notes"
  name "Beaver Notes"
  desc "Privacy-focused note-taking app"
  homepage "https:beavernotes.com"

  depends_on macos: ">= :big_sur"

  app "Beaver-notes.app"

  zap trash: [
    "~LibraryCachescom.danielerolli.beaver-notes",
    "~LibraryPreferencescom.danielerolli.beaver-notes.plist",
    "~LibrarySaved Application Statecom.danielerolli.beaver-notes.savedState",
  ]
end