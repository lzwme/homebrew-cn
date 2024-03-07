cask "lulu" do
  version "2.6.3"
  sha256 "fa677999f1f6eeac725d235de64e24235c34ca71d93040f26ac69e76ea4a68e5"

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