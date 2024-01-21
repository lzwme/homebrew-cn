cask "uvtools" do
  arch arm: "arm64", intel: "x64"

  version "4.1.0"
  sha256 arm:   "04d2bdc333398a523357deffacdb0f450299cf8dc826f7f79b2bca144cbae8a7",
         intel: "657dd0f1f80f44438875d696fc062768c78661989ccbe2f682705658b7ba79e7"

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