cask "ente" do
  version "1.7.13"
  sha256 "2e4329d22f3234b78e782948cb41c2eb73b9f6e4379f296ae23f4911a72d0c96"

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