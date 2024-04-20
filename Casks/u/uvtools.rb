cask "uvtools" do
  arch arm: "arm64", intel: "x64"

  version "4.3.2"
  sha256 arm:   "b7246a2f4cfc4eb3585c28c3942dcb080ed0c69767f257d343a85297482fd031",
         intel: "5724792bf0faa13bba558cb9f8536d732b78dfc378e21e5d2e0b4f6901ad9cc5"

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