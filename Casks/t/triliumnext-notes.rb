cask "triliumnext-notes" do
  arch arm: "arm64", intel: "x64"

  version "0.92.6"
  sha256 arm:   "c1cbaa47982b02fdfdfc1fb8c07aa24237a7c431c5892b8fa03a8b084597c016",
         intel: "aaf6db58a44c339879294512da07093ac1cff44b93a00afe3500ff82ca4d427c"

  url "https:github.comTriliumNextNotesreleasesdownloadv#{version}TriliumNextNotes-v#{version}-macos-#{arch}.dmg",
      verified: "github.comTriliumNextNotes"
  name "TriliumNext Notes"
  desc "Hierarchical note taking application"
  homepage "https:triliumnext.github.ioDocs"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on macos: ">= :big_sur"

  app "TriliumNext Notes.app"

  zap trash: [
    "~LibraryApplication Supporttrilium-data",
    "~LibraryApplication SupportTriliumNext Notes",
    "~LibraryPreferencescom.electron.triliumnext-notes.plist",
    "~LibrarySaved Application Statecom.electron.triliumnext-notes.savedState",
  ]
end