cask "gargoyle" do
  arch arm: "arm64", intel: "x64"

  version "2023.1"
  sha256 arm:   "8f0aa0550abde4427a93052009ef68c3eb663d61c7ffae95dfae9b247d49412b",
         intel: "58788637188d91eded3144dcce9490e65c08fcc5dbc6c9fae93e80805dd5603b"

  url "https:github.comgarglkgarglkreleasesdownload#{version}gargoyle-#{version}-mac-#{arch}.dmg"
  name "Gargoyle"
  desc "IO layer for interactive fiction players"
  homepage "https:github.comgarglkgarglk"

  livecheck do
    url :url
    strategy :github_latest
  end

  no_autobump! because: :requires_manual_review

  app "Gargoyle.app"

  zap trash: [
    "~LibraryApplication Supportcom.apple.sharedfilelistcom.apple.LSSharedFileList.ApplicationRecentDocumentscom.googlecode.garglk.launcher.sfl*",
    "~LibraryPreferencescom.googlecode.garglk.Launcher.plist",
    "~LibrarySaved Application Statecom.googlecode.garglk.Launcher.savedState",
  ]
end