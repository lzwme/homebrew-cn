cask "alt-tab" do
  version "7.9.0"
  sha256 "c1cc601b502f9c1ce6be975a617c7e8d1080f274f740045d5b18c42110f2e68a"

  url "https:github.comlwouisalt-tab-macosreleasesdownloadv#{version}AltTab-#{version}.zip",
      verified: "github.comlwouisalt-tab-macos"
  name "AltTab"
  desc "Enable Windows-like alt-tab"
  homepage "https:alt-tab-macos.netlify.app"

  livecheck do
    url :url
    strategy :github_latest
  end

  auto_updates true
  depends_on macos: ">= :sierra"

  app "AltTab.app"

  uninstall quit: "com.lwouis.alt-tab-macos"

  zap trash: [
    "~LibraryApplication Supportcom.lwouis.alt-tab-macos",
    "~LibraryCachescom.lwouis.alt-tab-macos",
    "~LibraryCookiescom.lwouis.alt-tab-macos.binarycookies",
    "~LibraryHTTPStoragescom.lwouis.alt-tab-macos",
    "~LibraryLaunchAgentscom.lwouis.alt-tab-macos.plist",
    "~LibraryPreferencescom.lwouis.alt-tab-macos.plist",
  ]
end