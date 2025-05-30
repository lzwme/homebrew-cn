cask "uvtools" do
  arch arm: "arm64", intel: "x64"

  version "5.1.2"
  sha256 arm:   "add076598862d08e3b54f9ffdd1141bc3381c04dfc8c39c2ce442d2a36edb3a5",
         intel: "77c93b15d55472a19069b128988c0bf5bba9eebdcb68c84f71367c31db4777bc"

  url "https:github.comsn4k3UVtoolsreleasesdownloadv#{version}UVtools_osx-#{arch}_v#{version}.zip"
  name "UVtools"
  desc "MSLADLP, file analysis, calibration, repair, conversion and manipulation"
  homepage "https:github.comsn4k3UVtools"

  auto_updates true
  depends_on macos: ">= :catalina"

  app "UVtools.app"

  zap trash: [
    "~LibraryPreferencescom.UVtools.plist",
    "~LibrarySaved Application Statecom.UVtools.savedState",
  ]
end