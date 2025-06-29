cask "notes-better" do
  version "2.3.1"
  sha256 "c89fde7f77137c3d19170191c775b3ce097021d3d74741429d166b7f9686e272"

  url "https:github.comnuttyartistnotesreleasesdownloadv#{version}Notes.#{version}.dmg",
      verified: "github.comnuttyartistnotes"
  name "Notes"
  desc "Simple note-taking app for markdown and kanban"
  homepage "https:get-notes.com"

  livecheck do
    url "https:raw.githubusercontent.comnuttyartistnotesmasterUPDATES_FOSS.json"
    strategy :json do |json|
      json.dig("updates", "osx", "latest-version")
    end
  end

  no_autobump! because: :requires_manual_review

  depends_on macos: ">= :big_sur"

  app "Notes Better.app"

  zap trash: [
    "~LibraryCachesNotes",
    "~LibraryPreferencesio.github.nuttyartist.notes.plist",
    "~LibrarySaved Application Stateio.github.nuttyartist.notes.savedState",
  ]
end