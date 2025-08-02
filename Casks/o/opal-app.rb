cask "opal-app" do
  version "1.5.5"
  sha256 "5fe3866b6fb842eeceb8ffa9a4fc74a3fef5ef560ad36374b28881b3659079ca"

  url "https://downloads.opal.so/mac/Opal%20#{version}.dmg"
  name "Opal"
  desc "Screen time app"
  homepage "https://www.opal.so/"

  livecheck do
    url "https://downloads.opal.so/mac/appcast.xml"
    strategy :sparkle, &:short_version
  end

  auto_updates true
  depends_on macos: ">= :ventura"

  app "Opal.app"

  uninstall quit: "com.withopal.opalmacos"

  zap trash: [
    "~/Library/Application Support/com.withopal.opalmacos",
    "~/Library/Caches/com.crashlytics.data/com.withopal.opalmacos",
    "~/Library/Caches/com.withopal.opalmacos",
    "~/Library/Group Containers/*.com.withopal.AppleScreentimeKit",
    "~/Library/Group Containers/*.com.withopal.opal",
    "~/Library/HTTPStorages/com.withopal.opalmacos",
    "~/Library/HTTPStorages/com.withopal.opalmacos.binarycookies",
    "~/Library/Preferences/com.withopal.opalmacos.plist",
    "~/Library/Preferences/com.withopal.opalmacos.revenuecat.etags.plist",
    "~/Library/Preferences/group.com.withopal.opalmacos.firebase.plist",
    "~/Library/WebKit/com.withopal.opalmacos",
  ]
end