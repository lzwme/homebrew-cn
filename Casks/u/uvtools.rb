cask "uvtools" do
  arch arm: "arm64", intel: "x64"

  version "4.0.5"
  sha256 arm:   "b2d3d2a1e3277cecb04946e4e5bf73bded3d697e943fb6347e3d353352913667",
         intel: "cd7a9e6c7d9b7ad58de9da55c284562f24304695dd5c4c46d974cc986b4f8d94"

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