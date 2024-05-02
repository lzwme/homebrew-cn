cask "tad" do
  arch arm: "-arm64"

  version "0.13.0"
  sha256  arm:   "9c129a65fdf94b4b32b6e26d8836a56d4284bff9a6e1df657cc23d19e5c802b1",
          intel: "4c71f6f6a0fadf65891663d1a0462dd8d3576a4c62bdd8721012cbdd61ee1fee"

  url "https:github.comantonycourtneytadreleasesdownloadv#{version}Tad-#{version}#{arch}.dmg",
      verified: "github.comantonycourtneytad"
  name "Tad"
  desc "Desktop application for viewing and analyzing tabular data"
  homepage "https:www.tadviewer.com"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on macos: ">= :catalina"

  app "Tad.app"
  binary "#{appdir}Tad.appContentsResourcestad.sh", target: "tad"

  zap trash: [
    "~LibraryApplication Supportcom.apple.sharedfilelistcom.apple.LSSharedFileList.ApplicationRecentDocumentscom.antonycourtney.tad.sfl*",
    "~LibraryApplication SupportTad",
    "~LibraryLogsTad",
    "~LibraryPreferencescom.antonycourtney.tad.plist",
    "~LibrarySaved Application Statecom.antonycourtney.tad.savedState",
  ]
end