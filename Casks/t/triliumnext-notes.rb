cask "triliumnext-notes" do
  arch arm: "arm64", intel: "x64"

  version "0.93.0"
  sha256 arm:   "9268ce38a584214b75f265b304968df1575480912ec3ce65e17f94dbccacad90",
         intel: "66856caf81ed6236f2b47155a19534aaa2ec491fc19eb1ecd23fc2cbe18aba8f"

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