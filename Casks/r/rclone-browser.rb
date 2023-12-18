cask "rclone-browser" do
  version "1.2,a1156a0"
  sha256 "542cd23eea128736999a7e512a9f2ff89be081c688d1581e6c78ab3d3ca118dd"

  url "https:github.commmozeikoRcloneBrowserreleasesdownload#{version.csv.first}rclone-browser-#{version.csv.first}-#{version.csv.second}-macOS.zip",
      verified: "github.commmozeikoRcloneBrowser"
  name "Rclone Browser"
  homepage "https:mmozeiko.github.ioRcloneBrowser"

  depends_on formula: "rclone"

  app "rclone-browser-#{version.csv.first}-#{version.csv.second}-macOSRclone Browser.app"

  zap trash: [
    "~LibraryPreferencesRclone Browser.plist",
    "~LibraryPreferencescom.rclone-browser.rclone-browser.plist",
  ]

  caveats do
    discontinued
  end
end