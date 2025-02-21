cask "alt-tab" do
  version "7.20.1"
  sha256 "66668438e2cbd15615deff019422f7137d83960d35b56a991534de39295fd9ed"

  url "https:github.comlwouisalt-tab-macosreleasesdownloadv#{version}AltTab-#{version}.zip",
      verified: "github.comlwouisalt-tab-macos"
  name "AltTab"
  desc "Enable Windows-like alt-tab"
  homepage "https:alt-tab-macos.netlify.app"

  livecheck do
    url "https:raw.githubusercontent.comlwouisalt-tab-macosmasterappcast.xml"
    strategy :sparkle
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