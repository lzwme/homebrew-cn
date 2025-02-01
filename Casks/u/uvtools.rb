cask "uvtools" do
  arch arm: "arm64", intel: "x64"

  version "5.0.6"
  sha256 arm:   "954f8df16af1fbd889be641e939a12760ee508ae55cd0fc3417ccbe69b34ba35",
         intel: "1fc4fa09df3f986cfd88c1b085f09cbab9dbeed71d1f54f63eddc03542940923"

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