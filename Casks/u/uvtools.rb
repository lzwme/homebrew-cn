cask "uvtools" do
  arch arm: "arm64", intel: "x64"

  version "5.0.8"
  sha256 arm:   "d7cebe2927306c65b6ebcf055b1159d8c2592a1ee8dd01e6ca98c62fb563beb4",
         intel: "761c7b4cddf6dd0042289630057833f1e24b2f9792f66099f3c5e87d1891502a"

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