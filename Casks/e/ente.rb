cask "ente" do
  version "1.6.62"
  sha256 "9b9b1043d4e435247b85f2ecb972dfa0a4b4659f9a4df3b5bc4de1959cde64f6"

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
    "~LibraryPreferencesio.ente.bhari-frame.helper.plist",
    "~LibraryPreferencesio.ente.bhari-frame.plist",
    "~LibrarySaved Application Stateio.ente.bhari-frame.savedState",
  ]
end