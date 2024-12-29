cask "alt-tab" do
  version "7.14.1"
  sha256 "eb6fb637e4e32aaf93749b9a3a2ce9892bc6427902dbe561057fb703641ea702"

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