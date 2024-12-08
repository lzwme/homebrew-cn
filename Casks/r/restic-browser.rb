cask "restic-browser" do
  version "0.3.1"
  sha256 "30fc1daebc2705d15f85803f1aee9a37ff2b5d99278c3ee4db9482e427a04c2c"

  url "https:github.comemuellrestic-browserreleasesdownloadv#{version}Restic-Browser-v#{version}-macOS.zip"
  name "Restic Browser"
  desc "GUI to browse and restore restic backup repositories"
  homepage "https:github.comemuellrestic-browser"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on formula: "restic"
  depends_on macos: ">= :high_sierra"

  app "Restic-Browser.app"

  zap trash: [
    "~LibraryApplication Supportorg.restic.browser",
    "~LibraryCachesorg.restic.browser",
    "~LibraryLogsorg.restic.browser",
    "~LibraryPreferencesorg.restic.browser.plist",
    "~LibraryWebKitorg.restic.browser",
  ]
end