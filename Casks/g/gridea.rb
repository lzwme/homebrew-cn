cask "gridea" do
  version "0.9.3"
  sha256 "16c9c9a1fdf4773f165878f995a9eb4b0a9c6eb815410a723170623dd23e4354"

  url "https://ghfast.top/https://github.com/getgridea/gridea/releases/download/v#{version}/Gridea-#{version}.dmg",
      verified: "github.com/getgridea/gridea/"
  name "Gridea"
  desc "Static blog writing client"
  homepage "https://gridea.dev/"

  no_autobump! because: :requires_manual_review

  auto_updates true

  app "Gridea.app"

  zap trash: [
        "~/.gridea",
        "~/Library/Application Support/gridea",
        "~/Library/Preferences/com.electron.gridea.plist",
        "~/Library/Saved Application State/com.electron.gridea.savedState",
      ],
      rmdir: "~/Documents/Gridea"

  caveats do
    requires_rosetta
  end
end