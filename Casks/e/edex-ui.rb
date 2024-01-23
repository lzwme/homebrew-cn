cask "edex-ui" do
  version "2.2.8"
  sha256 "db38e5dea11e8b0f528c1a59971fe97cbecbcdd8cf29b21621ad7105173c3407"

  url "https:github.comGitSquarededex-uireleasesdownloadv#{version}eDEX-UI-macOS-x64.dmg"
  name "eDEX-UI"
  desc "Sci-fi themed terminal emulator and system monitor"
  homepage "https:github.comGitSquarededex-ui"

  deprecate! date: "2023-12-17", because: :discontinued

  app "eDEX-UI.app"

  zap trash: [
    "~LibraryApplication SupporteDEX-UI",
    "~LibraryPreferencescom.edex.ui.plist",
    "~LibrarySaved Application Statecom.edex.ui.savedState",
  ]
end