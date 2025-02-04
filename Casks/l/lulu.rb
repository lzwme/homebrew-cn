cask "lulu" do
  version "3.1.0"
  sha256 "0429a9d2e4b571701ddaa4046245683a026d79f4f48f8d1a6333e30eea37d338"

  url "https:github.comobjective-seeLuLureleasesdownloadv#{version}LuLu_#{version}.dmg",
      verified: "github.comobjective-seeLuLu"
  name "LuLu"
  desc "Open-source firewall to block unknown outgoing connections"
  homepage "https:objective-see.orgproductslulu.html"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on macos: ">= :catalina"

  app "LuLu.app"

  # Lulu's uninstaller removes all preference files breaking brew upgrade

  zap trash: [
    "~LibraryCachescom.objective-see.lulu",
    "~LibraryCachescom.objective-see.lulu.helper",
    "~LibraryPreferencescom.objective-see.lulu.helper.plist",
    "~LibraryPreferencescom.objective-see.lulu.plist",
  ]
end