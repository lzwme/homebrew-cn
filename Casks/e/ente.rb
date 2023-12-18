cask "ente" do
  version "1.6.58"
  sha256 "61875a51112402aab957d0568fb9e05e91f4c6759b3891a0fc960c76ccdf0a81"

  url "https:github.comente-iophotos-desktopreleasesdownloadv#{version}ente-#{version}.dmg",
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