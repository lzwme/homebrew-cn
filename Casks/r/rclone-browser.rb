cask "rclone-browser" do
  version "1.2,a1156a0"
  sha256 "542cd23eea128736999a7e512a9f2ff89be081c688d1581e6c78ab3d3ca118dd"

  url "https:github.commmozeikoRcloneBrowserreleasesdownload#{version.csv.first}rclone-browser-#{version.csv.first}-#{version.csv.second}-macOS.zip",
      verified: "github.commmozeikoRcloneBrowser"
  name "Rclone Browser"
  desc "GUI for rclone"
  homepage "https:martins.ninjaRcloneBrowser"

  disable! date: "2024-12-16", because: :discontinued

  depends_on formula: "rclone"

  app "rclone-browser-#{version.csv.first}-#{version.csv.second}-macOSRclone Browser.app"

  zap trash: [
    "~LibraryPreferencescom.rclone-browser.rclone-browser.plist",
    "~LibraryPreferencesRclone Browser.plist",
  ]
end