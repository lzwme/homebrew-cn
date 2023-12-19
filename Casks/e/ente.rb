cask "ente" do
  version "1.6.59"
  sha256 "fae9acabb708b540639ce19a71631ad42a059debe87ecd3078423ca700108dbb"

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