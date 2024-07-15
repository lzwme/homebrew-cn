cask "alt-tab" do
  version "6.72.0"
  sha256 "6fb54e8f8661b10fe0465c488f0a128b2037abe188273b35b440d64d45c0fefd"

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