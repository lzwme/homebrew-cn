cask "screens-connect" do
  version "5.1,22719"
  sha256 "b9dda43626c1064f3c41d0b8be37bea4bcb42aceb701c4c041e53b7d8ec4ac13"

  url "https:updates.edovia.comcom.edovia.screens.connect.macScreensConnect_#{version.csv.first}b#{version.csv.second}.zip"
  name "Screens Connect"
  desc "Remote desktop software"
  homepage "https:edovia.comenscreens-connect"

  livecheck do
    url "https:updates.edovia.comcom.edovia.screens.connect.macappcast.xml"
    strategy :sparkle
  end

  auto_updates true
  depends_on macos: ">= :ventura"

  app "Screens Connect.app"

  # Uninstall script can fail when trying to remove legacy PKGIDS
  # Original discussion: https:github.comHomebrewhomebrew-caskpull8833
  uninstall launchctl: [
              "com.edovia.Screens-Connect.launcher",
              "com.edovia.screens.connect",
            ],
            quit:      "com.edovia.Screens-Connect",
            script:    {
              executable:   "#{appdir}Screens Connect.appContentsResourcessc-uninstaller.tool",
              must_succeed: false,
              sudo:         true,
            }

  zap trash: [
    "~LibraryPreferencescom.edovia.Screens-Connect.plist",
    "~LibraryPreferencescom.edovia.ScreensConnect.Shared.plist",
  ]
end