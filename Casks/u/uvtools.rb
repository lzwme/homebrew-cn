cask "uvtools" do
  arch arm: "arm64", intel: "x64"

  version "4.2.2"
  sha256 arm:   "ab3b130ee4d28b90bf729ec42702bf83422349a64f913409fcea0a10ae90dca0",
         intel: "5588304844d1cae67618ff024593babbe52bf6199c6b6e2ed793e0c3cfb9e30e"

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