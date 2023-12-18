cask "jgrennison-openttd" do
  version "0.56.1"
  sha256 "ff847a0cb69c289e4e933c363dd84532acb6aa26a19c4c69e4a0c1dc52b75484"

  url "https:github.comJGRennisonOpenTTD-patchesreleasesdownloadjgrpp-#{version}openttd-jgrpp-#{version}-macos-universal.dmg"
  name "JGR's OpenTTD Patchpack"
  desc "Collection of patches applied to OpenTTD"
  homepage "https:github.comJGRennisonOpenTTD-patches"

  app "OpenTTD.app"

  zap trash: [
    "~DocumentsOpenTTD",
    "~LibraryApplication SupportCrashReporteropenttd_*.plist",
    "~LibraryLogsDiagnosticReportsopenttd_*.crash",
    "~LibrarySaved Application Stateorg.openttd.openttd.jgrpp.savedState",
    "~LibrarySaved Application Stateorg.openttd.openttd.savedState",
  ]
end