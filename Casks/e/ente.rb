cask "ente" do
  version "1.6.60"
  sha256 "bd76bde717510602dc47798d8cebecdcbe0dc69c83c33b8e17206ec9cfa88ffa"

  url "https:github.comente-iophotos-desktopreleasesdownloadv#{version}ente-#{version}-universal.dmg",
      verified: "github.comente-iophotos-desktop"
  name "Ente"
  desc "Desktop client for Ente"
  homepage "https:ente.io"

  livecheck do
    url :url
    strategy :github_latest
  end

  app "ente.app"

  zap trash: [
    "~LibraryApplication Supportente",
    "~LibraryLogsente",
    "~LibraryPreferencesio.ente.bhari-frame.plist",
    "~LibraryPreferencesio.ente.bhari-frame.helper.plist",
    "~LibrarySaved Application Stateio.ente.bhari-frame.savedState",
  ]
end