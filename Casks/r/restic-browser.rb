cask "restic-browser" do
  version "0.3.2"
  sha256 "8b2138661571a6f6f80210cffe5c4b03b4b7436c751a28941a77a113fded7a68"

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