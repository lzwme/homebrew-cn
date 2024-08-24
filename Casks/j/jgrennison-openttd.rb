cask "jgrennison-openttd" do
  version "0.61.0"
  sha256 "401037611e6050cd3cb667e9ac9e89472ff6ae376f1df757a199f8b16efac203"

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