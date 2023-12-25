cask "jitouch" do
  version "2.82.1"
  sha256 "3f5194a4da6fe19d17c843fa8a876131f7878905dcbb2e1d740d34d286d740c4"

  url "https:github.comJitouchAppJitouchreleasesdownloadv#{version}Install-Jitouch.pkg",
      verified: "github.comJitouchAppJitouch"
  name "Jitouch"
  desc "Multi-touch gestures editor"
  homepage "https:www.jitouch.com"

  depends_on macos: ">= :high_sierra"

  pkg "Install-Jitouch.pkg"

  uninstall launchctl: "com.jitouch.Jitouch.agent",
            quit:      "com.jitouch.Jitouch",
            pkgutil:   "com.jitouch.Jitouch"

  zap trash: [
    "~LibraryLaunchAgentscom.jitouch.Jitouch.plist",
    "~LibraryLogscom.jitouch.Jitouch.log",
    "~LibraryLogscom.jitouch.Jitouch.prefpane.log",
    "~LibraryPreferencescom.jitouch.Jitouch.plist",
  ]
end