cask "macforge" do
  version "1.1.0"
  sha256 "5a28c4f43b9b9bb868e26e45096804a1b7ae604fbf3ae857bed63d495a43ec50"

  url "https:github.comw0lfschildapp_updatesrawmasterMacForge1MacForge.#{version}.zip",
      verified: "github.comw0lfschildapp_updates"
  name "MacForge"
  desc "Plugin, App, and Theme store which includes plugin injection"
  homepage "https:www.macenhance.commacforge"

  livecheck do
    url "https:raw.githubusercontent.comw0lfschildapp_updatesmasterMacForge1appcast.xml"
    strategy :sparkle, &:short_version
  end

  auto_updates true
  depends_on macos: ">= :high_sierra"

  app "MacForge.app"

  uninstall launchctl:  "com.macenhance.MacForge.Injector",
            quit:       [
              "com.macenhance.MacForge",
              "com.macenhance.MacForge.PreferenceLoader",
              "com.macenhance.MacForgeDockTile",
              "com.macenhance.MacForgeHelper",
              "com.macenhance.SIPKit",
            ],
            login_item: "MacForgeHelper",
            delete:     [
              "LibraryApplication SupportMacEnhance",
              "LibraryLaunchDaemonscom.macenhance.MacForge.Injector.plist",
              "LibraryPrivilegedHelperToolscom.macenhance.MacForge.Injector",
            ]

  zap trash: [
    "~LibraryApplication Supportcom.macenhance.MacForge",
    "~LibraryApplication SupportMacEnhance",
    "~LibraryCachescom.macenhance.MacForge",
    "~LibraryCachescom.macenhance.MacForgeHelper",
    "~LibraryHTTPStoragescom.macenhance.MacForge",
    "~LibraryHTTPStoragescom.macenhance.MacForge.binarycookies",
    "~LibraryHTTPStoragescom.macenhance.MacForgeHelper",
    "~LibraryPreferencescom.macenhance.MacForge.plist",
    "~LibraryPreferencescom.macenhance.MacForgeHelper.plist",
    "~LibrarySaved Application Statecom.macenhance.MacForge.savedState",
    "~LibraryWebKitcom.macenhance.MacForge",
  ]
end