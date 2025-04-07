cask "lulu" do
  version "3.1.4"
  sha256 "4b97e370f736357274adcb114c9500a105eed60c8812f9cd57e9b5dc18dbbd5a"

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