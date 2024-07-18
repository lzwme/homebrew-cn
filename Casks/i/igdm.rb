cask "igdm" do
  version "3.0.4"
  sha256 "fe032a9657267018efc16697d218dbdcda02564f5d42e4b2e21bf68ea9e715c7"

  url "https:github.comifedapoolarewajuigdmreleasesdownloadv#{version}IGdm-#{version}.dmg",
      verified: "github.comifedapoolarewajuigdm"
  name "IG:dm"
  desc "Desktop application for Instagram DMs"
  homepage "https:igdm.me"

  app "IGdm.app"

  uninstall quit: "com.ifedapoolarewaju.desktop.igdm"

  zap trash: [
    "~LibraryApplication SupportIGdm",
    "~LibraryLogsIGdm",
    "~LibraryPreferencescom.ifedapoolarewaju.desktop.igdm.helper.plist",
    "~LibraryPreferencescom.ifedapoolarewaju.desktop.igdm.plist",
    "~LibrarySaved Application Statecom.ifedapoolarewaju.desktop.igdm.savedState",
  ]

  caveats do
    requires_rosetta
  end
end