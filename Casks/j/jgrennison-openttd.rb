cask "jgrennison-openttd" do
  version "0.64.1"
  sha256 "b12d85c2be0e63b5667c89b6c35ce29867e4a4cc3def059d8ebc58bec5e3248e"

  url "https:github.comJGRennisonOpenTTD-patchesreleasesdownloadjgrpp-#{version}openttd-jgrpp-#{version}-macos-universal.dmg"
  name "JGR's OpenTTD Patchpack"
  desc "Collection of patches applied to OpenTTD"
  homepage "https:github.comJGRennisonOpenTTD-patches"

  depends_on macos: ">= :high_sierra"

  app "OpenTTD.app"

  zap trash: [
    "~DocumentsOpenTTD",
    "~LibraryApplication SupportCrashReporteropenttd_*.plist",
    "~LibraryLogsDiagnosticReportsopenttd_*.crash",
    "~LibrarySaved Application Stateorg.openttd.openttd.jgrpp.savedState",
    "~LibrarySaved Application Stateorg.openttd.openttd.savedState",
  ]
end