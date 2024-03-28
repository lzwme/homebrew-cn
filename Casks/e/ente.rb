cask "ente" do
  version "1.6.63"
  sha256 "3598e03ab794e023f50711458d22438a26c23bc1211f2c867406fc1d0b08ee71"

  url "https:github.comente-iophotos-desktopreleasesdownloadv#{version}ente-#{version}-universal.dmg",
      verified: "github.comente-iophotos-desktop"
  name "Ente"
  desc "Desktop client for Ente Photos"
  homepage "https:ente.io"

  livecheck do
    url :url
    strategy :github_latest
  end

  auto_updates true

  app "ente.app"

  zap trash: [
    "~LibraryApplication Supportente",
    "~LibraryLogsente",
    "~LibraryPreferencesio.ente.bhari-frame.helper.plist",
    "~LibraryPreferencesio.ente.bhari-frame.plist",
    "~LibrarySaved Application Stateio.ente.bhari-frame.savedState",
  ]
end