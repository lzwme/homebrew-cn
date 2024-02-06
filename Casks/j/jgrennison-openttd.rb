cask "jgrennison-openttd" do
  version "0.57.1"
  sha256 "f37942fcfb7a4eea651ef5c7ea8a825f1ecebcc8f847182d920eb0b0447da535"

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