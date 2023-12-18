cask "lulu" do
  version "2.5.1"
  sha256 "e9d55acc568c7037d435225c0c44759a10f605886161a60263a632f12806daf2"

  url "https:github.comobjective-seeLuLureleasesdownloadv#{version}LuLu_#{version}.dmg",
      verified: "github.comobjective-seeLuLu"
  name "LuLu"
  desc "Open-source firewall to block unknown outgoing connections"
  homepage "https:objective-see.comproductslulu.html"

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