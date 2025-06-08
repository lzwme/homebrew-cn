cask "triliumnext-notes" do
  arch arm: "arm64", intel: "x64"

  version "0.94.1"
  sha256 arm:   "1448281ab40042f1a2f3d8513f84439cef9cb8b466c554fe26904dabf7d2db61",
         intel: "101d3bfc66912a31e05468c300e3ad1fa897c1011d8e13deacd73a56acee2d84"

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