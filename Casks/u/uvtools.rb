cask "uvtools" do
  arch arm: "arm64", intel: "x64"

  version "4.3.0"
  sha256 arm:   "398fba832da67ce97175c0ed28fc9a4a5ada5801d127f7a5cce0af9da14e24de",
         intel: "82a1fa0334b0c0ee4c981700782f23d09e9a1db26561989c7dbf8dd4814fefac"

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