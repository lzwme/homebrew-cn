cask "edex-ui" do
  version "2.2.8"
  sha256 "db38e5dea11e8b0f528c1a59971fe97cbecbcdd8cf29b21621ad7105173c3407"

  url "https://ghfast.top/https://github.com/GitSquared/edex-ui/releases/download/v#{version}/eDEX-UI-macOS-x64.dmg"
  name "eDEX-UI"
  desc "Sci-fi themed terminal emulator and system monitor"
  homepage "https://github.com/GitSquared/edex-ui"

  disable! date: "2024-12-16", because: :discontinued

  app "eDEX-UI.app"

  zap trash: [
    "~/Library/Application Support/eDEX-UI",
    "~/Library/Preferences/com.edex.ui.plist",
    "~/Library/Saved Application State/com.edex.ui.savedState",
  ]

  caveats do
    requires_rosetta
  end
end