cask "ente" do
  version "1.7.2"
  sha256 "9f85376f5a43560c46e87cf2bcff831871619bccf834af4a7405e76043dcffb5"

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