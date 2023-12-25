cask "iconchamp" do
  version "1.3.6"
  sha256 :no_check

  url "https:github.comMacEnhanceappcastrawmasterIconChampIconChamp.zip",
      verified: "github.comMacEnhanceappcast"
  name "IconChamp"
  desc "Icon theming app for Big Sur and Monterey"
  homepage "https:www.macenhance.comiconchamp"

  livecheck do
    url "https:raw.githubusercontent.comMacEnhanceappcastmasterIconChampappcast.xml"
    strategy :sparkle, &:short_version
  end

  depends_on macos: ">= :big_sur"

  app "IconChamp.app"

  uninstall launchctl: "com.macenhance.ICHelper",
            quit:      "com.macenhance.IconChamp",
            delete:    [
              "LibraryLaunchDaemonscom.macenhance.ICHelper.plist",
              "LibraryPrivilegedHelperToolscom.macenhance.ICHelper",
            ]

  zap trash: [
    "UsersSharedIconChamp",
    "~LibraryApplication Supportcom.macenhance.IconChamp",
    "~LibraryApplication SupportIconChamp",
    "~LibraryCachescom.macenhance.IconChamp",
    "~LibraryHTTPStoragescom.macenhance.IconChamp",
    "~LibraryHTTPStoragescom.macenhance.IconChamp.binarycookies",
    "~LibraryPreferencescom.macenhance.IconChamp.plist",
    "~LibrarySaved Application Statecom.macenhance.IconChamp.savedState",
  ]
end