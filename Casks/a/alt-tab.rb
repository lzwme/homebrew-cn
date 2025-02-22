cask "alt-tab" do
  version "7.21.0"
  sha256 "c5a55b17e641a9be954a48e1835bd5ab77c259e8b12eabccabaf28765fe9b947"

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