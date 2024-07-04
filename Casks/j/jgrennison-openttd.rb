cask "jgrennison-openttd" do
  version "0.60.0"
  sha256 "0a57bec5c794e44496d422c07cd023eb0684d99fa16dbbc70f7a094058412721"

  url "https:github.comJGRennisonOpenTTD-patchesreleasesdownloadjgrpp-#{version}openttd-jgrpp-#{version}-macos-universal.zip"
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