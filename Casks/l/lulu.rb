cask "lulu" do
  version "3.0.0"
  sha256 "eb2d1920ce0ebbfbe6c895197cec30170291a08e05ea616f7036bacb25b1a5b4"

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