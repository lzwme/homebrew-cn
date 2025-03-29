cask "ente" do
  version "1.7.11"
  sha256 "9e2911a7963a42935b311096c6c55fa479ca36c8bf90826c2e50f6778da72474"

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
  depends_on macos: ">= :big_sur"

  app "ente.app"

  zap trash: [
    "~LibraryApplication Supportente",
    "~LibraryLogsente",
    "~LibraryPreferencesio.ente.bhari-frame.helper.plist",
    "~LibraryPreferencesio.ente.bhari-frame.plist",
    "~LibrarySaved Application Stateio.ente.bhari-frame.savedState",
  ]
end